import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a file to Firebase Storage at the specified [destinationPath].
  Future<void> uploadFile(File file, String destinationPath) async {
    try {
      // Create a reference to the destination in Firebase Storage
      Reference ref = _storage.ref().child(destinationPath);

      // Upload the file
      UploadTask uploadTask = ref.putFile(file);

      // Wait for completion
      await uploadTask.whenComplete(() => null);

      print("✅ File uploaded to: $destinationPath");
    } catch (e) {
      print("❌ Error uploading file: $e");
    }
  }
}
