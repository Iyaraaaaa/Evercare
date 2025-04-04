import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PigeonUserDetails {
  final String id;
  final String email;

  PigeonUserDetails({
    required this.id,
    required this.email,
  });

  // Convert Firestore document to PigeonUserDetails
  factory PigeonUserDetails.fromJson(Map<String, dynamic> json) {
    return PigeonUserDetails(
      id: json['id'] ?? 'unknown_id',
      email: json['email'] ?? 'unknown@example.com',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
      };
}

class UserService {
  // Get user details from Firestore
  Future<PigeonUserDetails?> getUserDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (doc.exists) {
        var data = doc.data();

        if (data is Map<String, dynamic>) {
          return PigeonUserDetails.fromJson(data);
        } else {
          print("Firestore returned unexpected data: $data");
          return null;
        }
      } else {
        print('No user document found in Firestore');
        return null;
      }
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }

  // Save or update user details in Firestore
  Future<void> saveUserDetails(User user, {required String email}) async {
    try {
      // Check if document exists before updating or setting
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      DocumentSnapshot docSnapshot = await userDocRef.get();

      if (docSnapshot.exists) {
        // If the document exists, update the email
        await userDocRef.update({'email': email});
        print('User details updated successfully.');
      } else {
        // If the document does not exist, create it
        await userDocRef.set({
          'id': user.uid,
          'email': email,
        });
        print('User details saved successfully.');
      }
    } catch (e) {
      print('Error saving user details: $e');
    }
  }
}
