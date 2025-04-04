import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter/material.dart';

class PhoneAuthPage extends StatefulWidget {
  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  PhoneNumber? _phoneNumber;
  // Removed unused _verificationId field
  int? _resendToken;
  String? _verificationId;

  // Abstracted SnackBar display logic to a separate method
  void _showSnackBar(String message, {Color backgroundColor = Colors.blue}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    _showSnackBar(message, backgroundColor: Colors.green);
  }

  void _showErrorSnackBar(String message) {
    _showSnackBar(message, backgroundColor: Colors.red);
  }

  void _showInfoSnackBar(String message) {
    _showSnackBar(message, backgroundColor: Colors.blue);
  }

  Future<void> sendOTP() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneNumber!.phoneNumber!,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _handleVerificationComplete(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          _handleVerificationFailed(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          _handleCodeSent(verificationId, resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _handleTimeout(verificationId);
        },
        forceResendingToken: _resendToken,
      );
    } catch (e) {
      _showErrorSnackBar("An error occurred: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _handleVerificationComplete(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      _showSuccessSnackBar("Phone number verified successfully!");
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      _showErrorSnackBar("Verification failed: $e");
    }
  }

  void _handleVerificationFailed(FirebaseAuthException e) {
    String errorMessage;
    switch (e.code) {
      case 'invalid-phone-number':
        errorMessage = "Invalid phone number format";
        break;
      case 'too-many-requests':
        errorMessage = "Too many requests. Try again later";
        break;
      default:
        errorMessage = "Verification failed: ${e.message}";
    }
    _showErrorSnackBar(errorMessage);
  }

  void _handleCodeSent(String verificationId, int? resendToken) {
    _verificationId = verificationId;
    _resendToken = resendToken;
    if (mounted) {
      Navigator.pushNamed(
        context,
        '/otp_verification',
        arguments: {
          'verificationId': verificationId,
          'phoneNumber': _phoneNumber!.phoneNumber,
          'resendToken': resendToken,
        },
      );
    }
  }

  void _handleTimeout(String verificationId) {
    _showInfoSnackBar("OTP auto-retrieval timed out");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone Authentication"),
        backgroundColor: Colors.pink,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                "Enter your phone number",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  _phoneNumber = number;
                },
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.DROPDOWN,
                  showFlags: true,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: const TextStyle(color: Colors.black),
                initialValue: PhoneNumber(isoCode: 'US'),
                textFieldController: phoneController,
                formatInput: true,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                inputDecoration: InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your phone number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : sendOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Send OTP",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
