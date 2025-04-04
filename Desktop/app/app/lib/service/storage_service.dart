import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload profile image
  Future<String> uploadProfileImage(String userId, File imageFile) async {
    try {
      // Create a unique reference using userId and timestamp to prevent overwriting
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = _storage.ref().child('profile_images/$userId/$timestamp-profile_picture');

      final uploadTask = ref.putFile(imageFile);

      // Show upload progress (optional)
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        print('Upload progress: ${(progress * 100).toStringAsFixed(2)}%');
      });

      // Wait for the upload to complete and get the download URL
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

  // Delete profile image
  Future<void> deleteProfileImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);

      // Before deleting, check if the image exists
      bool imageExists = await ref.getMetadata().then((metadata) => metadata != null).catchError((_) => false);
      if (imageExists) {
        await ref.delete();
        print('Image deleted successfully.');
      } else {
        print('Image does not exist.');
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }
}
