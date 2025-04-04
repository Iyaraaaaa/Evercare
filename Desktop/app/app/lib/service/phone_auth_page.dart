import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthPage extends StatefulWidget {
  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _phoneController = TextEditingController();
  PhoneNumber? _phoneNumber;
  bool _isLoading = false;

  Future<void> _verifyPhoneNumber() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.verifyPhoneNumber(
        phoneNumber: _phoneNumber!.phoneNumber!,
        verificationCompleted: _verificationCompleted,
        verificationFailed: _verificationFailed,
        codeSent: _codeSent,
        codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
      );
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}', SnackBarType.error);
      setState(() => _isLoading = false);
    }
  }

  void _verificationCompleted(PhoneAuthCredential credential) async {
    try {
      await _authService.signInWithOTP(credential.verificationId!, credential.smsCode!);
      _showSnackBar('Phone number verified successfully!', SnackBarType.success);
      if (mounted) Navigator.pushReplacementNamed(context, '/profile-setup');
    } catch (e) {
      _showSnackBar('Verification failed: ${e.toString()}', SnackBarType.error);
    }
  }

  void _verificationFailed(FirebaseAuthException e) {
    _showSnackBar('Verification failed: ${e.message}', SnackBarType.error);
    setState(() => _isLoading = false);
  }

  void _codeSent(String verificationId, int? resendToken) {
    setState(() => _isLoading = false);
    Navigator.pushNamed(
      context,
      '/otp-verification',
      arguments: {
        'verificationId': verificationId,
        'phoneNumber': _phoneNumber!.phoneNumber,
        'resendToken': resendToken,
      },
    );
  }

  void _codeAutoRetrievalTimeout(String verificationId) {
    _showSnackBar('Code auto-retrieval timed out', SnackBarType.info);
  }

  void _showSnackBar(String message, SnackBarType type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: type == SnackBarType.success
            ? Colors.green
            : type == SnackBarType.error
                ? Colors.red
                : Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Authentication')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) => _phoneNumber = number,
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.DIALOG,
                ),
                initialValue: PhoneNumber(isoCode: 'US'),
                textFieldController: _phoneController,
                inputDecoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter phone number' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyPhoneNumber,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Send OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum SnackBarType { success, error, info }
