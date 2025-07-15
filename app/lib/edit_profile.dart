import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Mock Database Helper for demonstration
class DatabaseHelper {
  Future<Map<String, dynamic>> getProfileByEmail(String email) async {
    return {'name': 'John Doe', 'email': email, 'password': '123456'};
  }

  Future<void> insertProfile(Map<String, dynamic> profileData) async {
    print('Profile data saved: $profileData');
  }
}

class EditProfilePage extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userImage;

  const EditProfilePage({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userImage,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final profile = await _dbHelper.getProfileByEmail(widget.userEmail);
      nameController.text = profile['name'] ?? widget.userName;
      emailController.text = profile['email'] ?? widget.userEmail;
      passwordController.text = profile['password'] ?? '';
    } catch (e) {
      _showErrorSnackbar('Failed to load profile: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final fileSize = await file.length() / 1024 / 1024;
        if (fileSize > 5) {
          _showErrorSnackbar('Image size should be less than 5MB');
          return;
        }
        setState(() => _image = file);
      }
    } catch (e) {
      _showErrorSnackbar('Failed to pick image: ${e.toString()}');
    }
  }

  Future<String?> _uploadImage(File image) async {
    setState(() => _isLoading = true);
    try {
      final userId = _auth.currentUser?.uid ?? 'unknown_user';
      final fileName = 'profile_images/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance.ref(fileName);

      final uploadTask = ref.putFile(image);
      final snapshot = await uploadTask.whenComplete(() {});

      if (snapshot.state == TaskState.success) {
        return await snapshot.ref.getDownloadURL();
      }
      return null;
    } on FirebaseException catch (e) {
      _showErrorSnackbar('Storage error: ${e.message}');
      return null;
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateEmail(String newEmail) async {
    try {
      if (_auth.currentUser?.email == newEmail) {
        _showErrorSnackbar('This is your current email address.');
        return;
      }

      await _auth.currentUser?.verifyBeforeUpdateEmail(newEmail);
      _showSuccessSnackbar('Verification email sent to $newEmail');
    } on FirebaseAuthException catch (e) {
      _showErrorSnackbar('Email update failed: ${e.message}');
    }
  }

  Future<void> _updatePassword(String newPassword) async {
    try {
      await _auth.currentUser?.updatePassword(newPassword);
      _showSuccessSnackbar('Password updated successfully');
    } on FirebaseAuthException catch (e) {
      _showErrorSnackbar('Password update failed: ${e.message}');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Future<void> _saveChanges() async {
    if (nameController.text.isEmpty) {
      _showErrorSnackbar('Name is required');
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailController.text)) {
      _showErrorSnackbar('Please enter a valid email');
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (emailController.text != widget.userEmail) {
        await _updateEmail(emailController.text);
      }

      if (passwordController.text.isNotEmpty && passwordController.text.length >= 6) {
        await _updatePassword(passwordController.text);
      } else if (passwordController.text.isNotEmpty) {
        _showErrorSnackbar('Password should be at least 6 characters');
        return;
      }

      String? imageUrl = widget.userImage;
      if (_image != null) {
        imageUrl = await _uploadImage(_image!);
        if (imageUrl == null) return;
      }

      final profileData = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'imagePath': imageUrl ?? '',
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      await _dbHelper.insertProfile(profileData);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', nameController.text);
      await prefs.setString('userEmail', emailController.text);
      await prefs.setString('userImage', imageUrl);

      _showSuccessSnackbar('Profile updated successfully!');
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      _showErrorSnackbar('Failed to save changes: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildProfileImage(),
                  const SizedBox(height: 25),
                  _buildFormFields(),
                  const SizedBox(height: 30),
                  _buildSaveButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.blue.shade100,
          backgroundImage: _getImageProvider(),
          child: _image == null && widget.userImage.isEmpty
              ? const Icon(Icons.person, size: 50, color: Colors.white)
              : null,
        ),
        Positioned(
          child: FloatingActionButton.small(
            onPressed: _pickImage,
            backgroundColor: Colors.blueAccent,
            child: const Icon(Icons.camera_alt, size: 20),
          ),
        ),
      ],
    );
  }

  ImageProvider _getImageProvider() {
    if (_image != null) return FileImage(_image!);
    if (widget.userImage.isNotEmpty) {
      if (widget.userImage.startsWith('http')) {
        return NetworkImage(widget.userImage);
      }
      return FileImage(File(widget.userImage));
    }
    return const AssetImage('assets/images/default_profile.png');
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        _customTextField(nameController, 'Full Name', Icons.person),
        const SizedBox(height: 15),
        _customTextField(emailController, 'Email', Icons.email),
        const SizedBox(height: 15),
        _customTextField(
          passwordController,
          'Password',
          Icons.lock,
          obscureText: !_isPasswordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() => _isPasswordVisible = !_isPasswordVisible);
            },
          ),
        ),
      ],
    );
  }

  Widget _customTextField(TextEditingController controller, String label, IconData icon,
      {bool obscureText = false, Widget? suffixIcon}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveChanges,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        child: const Text(
          'Save Changes',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
