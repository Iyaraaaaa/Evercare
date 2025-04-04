import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Phone number authentication
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String, int?) codeSent,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(String) codeAutoRetrievalTimeout,
    int? resendToken,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      forceResendingToken: resendToken,
    );
  }

  // Sign in with OTP
  Future<UserCredential> signInWithOTP(String verificationId, String smsCode) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return await _auth.signInWithCredential(credential);
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Create user profile in Firestore
  Future<void> createUserProfile({
    required String uid,
    required String phoneNumber,
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'phoneNumber': phoneNumber,
      'firstName': firstName ?? '',
      'lastName': lastName ?? '',
      'email': email ?? '',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String uid,
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    await _firestore.collection('users').doc(uid).update({
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (email != null) 'email': email,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get user profile
  Future<Map<String, dynamic>> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data() ?? {};
  }

  // Stream user profile changes
  Stream<Map<String, dynamic>> userProfileStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map(
          (snapshot) => snapshot.data() ?? {},
        );
  }
}
