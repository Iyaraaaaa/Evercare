import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class MobileSignupPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute(builder: (context) => const MobileSignupPage());
  }

  const MobileSignupPage({super.key});

  @override
  State<MobileSignupPage> createState() => _MobileSignupPageState();
}

class _MobileSignupPageState extends State<MobileSignupPage> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _phoneNumber = "";
  bool _isLoading = false;
  PhoneNumber _initialPhoneNumber = PhoneNumber(isoCode: 'LK');

  // Color theme
  final Color _primaryColor = const Color(0xFF075E54);
  final Color _buttonColor = const Color(0xFF25D366);

  Future<void> _sendOTP() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // For development testing only - remove in production
      await FirebaseAuth.instance.setSettings(
        appVerificationDisabledForTesting: true,
      );

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        verificationFailed: (e) {
          _showErrorSnackBar(_getErrorMessage(e));
        },
        codeSent: (verificationId, resendToken) {
          if (mounted) {
            Navigator.pushNamed(
              context,
              '/otp_verification',
              arguments: {
                'verificationId': verificationId,
                'resendToken': resendToken,
                'phoneNumber': _phoneNumber,
              },
            );
          }
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'operation-not-allowed') {
        _showErrorSnackBar(
          "SMS verification is not enabled for this region. "
          "Please contact support.",
        );
      } else {
        _showErrorSnackBar("Error: ${_getErrorMessage(e)}");
      }
    } catch (e) {
      _showErrorSnackBar("An error occurred: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return "Invalid phone number format";
      case 'too-many-requests':
        return "Too many attempts. Try again later";
      case 'quota-exceeded':
        return "Quota exceeded. Contact support";
      case 'operation-not-allowed':
        return "SMS verification not enabled";
      default:
        return e.message ?? "Verification failed";
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Sign Up'),
        backgroundColor: _primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  "Enter your mobile number",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "We'll send you a verification code",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 32),
                InternationalPhoneNumberInput(
                  onInputChanged: (number) {
                    setState(() {
                      _phoneNumber = number.phoneNumber ?? "";
                    });
                  },
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.DIALOG,
                    showFlags: true,
                    useEmoji: true,
                  ),
                  initialValue: _initialPhoneNumber,
                  textFieldController: _phoneController,
                  formatInput: true,
                  keyboardType: TextInputType.phone,
                  inputDecoration: InputDecoration(
                    labelText: "Phone Number",
                    hintText: "712345678",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _primaryColor),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a phone number";
                    }
                    if (_phoneNumber.isEmpty) {
                      return "Please select a valid country code";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _buttonColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text(
                            "Send Verification Code",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Already have an account? Sign In",
                    style: TextStyle(color: _primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}