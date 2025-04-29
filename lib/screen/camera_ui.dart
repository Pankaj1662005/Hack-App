import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../features/camera_service.dart';

class CameraUploaderScreen extends StatefulWidget {
  const CameraUploaderScreen({super.key});

  @override
  State<CameraUploaderScreen> createState() => _CameraUploaderScreenState();
}

class _CameraUploaderScreenState extends State<CameraUploaderScreen> {
  final CameraService _cameraService = CameraService();
  CameraController? _controller;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _controller = await _cameraService.initializeCamera();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _cameraService.disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Camera Preview")),
      body: _controller != null && _controller!.value.isInitialized
          ? Stack(
        children: [
          CameraPreview(_controller!),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () async {
                await _cameraService.switchCamera();
                _controller = _cameraService.cameraController;
                setState(() {});
              },
              child: const Icon(Icons.switch_camera),
            ),
          )
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
