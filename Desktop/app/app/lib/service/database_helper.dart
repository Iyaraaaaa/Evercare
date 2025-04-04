import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class DatabaseHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final String userId = "user_id"; // Replace with dynamic user ID if needed

  // Fetch profile data as a stream
  Stream<Map<String, dynamic>> getProfileStream() async* {
    // Replace this with your actual implementation to fetch profile data
    yield* _firestore.collection('users').doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        return {
          'firstName': 'John',
          'lastName': 'Doe',
          'email': 'john.doe@example.com',
          'password': 'password123',
          'imagePath': '', // Add a valid image path if needed
        };
      }
    });
  }

  // Save or update profile data in Firestore
  Future<void> insertProfile(Map<String, dynamic> profileData) async {
    try {
      await _firestore.collection('users').doc(userId).set(profileData);
      print("Profile saved to Firestore");
    } catch (e) {
      print("Error saving profile: $e");
    }
  }

  // Upload profile image to Firebase Storage and return the image URL
  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      // Create a reference to Firebase Storage with unique path
      Reference storageReference = _firebaseStorage
          .ref()
          .child('profile_images/$userId/${DateTime.now().millisecondsSinceEpoch}');

      // Upload the file
      UploadTask uploadTask = storageReference.putFile(imageFile);

      // Get the download URL after the upload is complete
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("Image uploaded to Firebase Storage, URL: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  // Fetch the most recent profile image URL from Firebase Storage
  Future<String?> getProfileImageUrl() async {
    try {
      Reference storageReference = _firebaseStorage.ref().child('profile_images/$userId');

      // Get the download URL for the most recent image
      String downloadUrl = await storageReference.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error fetching profile image URL: $e");
      return null;
    }
  }

  // Optional: Delete the existing profile image from Firebase Storage
  Future<void> deleteProfileImage() async {
    try {
      final storageReference = _firebaseStorage.ref().child('profile_images/$userId');

      // Get metadata to check if an image exists
      final metadata = await storageReference.getMetadata();
      if (metadata != null) {
        await storageReference.delete();
        print("Existing profile image deleted");
      } else {
        print("No existing profile image to delete");
      }
    } catch (e) {
      print("Error deleting profile image: $e");
    }
  }
}
