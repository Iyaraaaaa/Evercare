import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/material.dart';

Future<File?> copyImageToDocumentsDirectory(File imageFile) async {
  try {
    // Get the app's documents directory
    final directory = await path_provider.getApplicationDocumentsDirectory();

    // Create a new path to store the image
    final newImagePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Copy the image to the new location
    final newImageFile = await imageFile.copy(newImagePath);

    print('Image copied to: ${newImageFile.path}');
    return newImageFile;
  } catch (e) {
    print('Error copying image: $e');
    return null;
  }
}
