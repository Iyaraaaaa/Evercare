import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'splash_screen.dart';
import 'on_boarding_screen.dart';
import 'login.dart';
import 'signup.dart';
import 'verified_screen.dart';
import 'service/OTPVerification.dart';
import 'home.dart'; // Ensure this file contains the definition of HomePage
import 'doctor_home.dart';
import 'doctor.dart';
import 'schedule.dart';
import 'edit_profile.dart';
import 'notifications.dart';
import 'privacy.dart';
import 'permission.dart';
import 'about_us.dart';
import 'message.dart';
import 'payment.dart';
import 'forget.dart';
import 'doctor_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();

    // Enable Firebase App Check for security (switch to production provider)
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug, // Change to .playIntegrity in production
      appleProvider: AppleProvider.appAttest,
    );
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
    // Optionally, show a user-friendly message or fallback screen
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doctor Channeling App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash_screen',
      routes: {
        '/splash_screen': (context) => const SplashScreen(),
        '/on_boarding': (context) => const OnBoardingScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/forget': (context) => ForgotPasswordPage(),
        '/otp_verification': (context) => OTPVerificationPage(verificationId: ''),
        '/verified': (context) => VerifiedScreen(),
        '/doctor_dashboard': (context) => const DoctorDashboard(),
        '/home': (context) => HomePage(),
        '/doctor_home': (context) => DoctorHomePage(),
        '/doctor': (context) => DoctorPage(),
        '/schedule': (context) => SchedulePage(),
        '/edit_profile': (context) => EditProfilePage(
          userName: 'Default Name',
          userEmail: 'default@example.com',
          userImage: 'default_image_url',
        ),
        '/notifications': (context) => NotificationsPage(),
        '/privacy': (context) => PrivacyPage(),
        '/permission': (context) => PermissionPage(),
        '/about_us': (context) => AboutUsPage(),
        '/payment': (context) => const PaymentPage(patientName: 'John Doe'),
        '/message': (context) => MessagePage(doctor: {'id': 'defaultDoctorId'}), // Default doctor data
      },
    );
  }
}
