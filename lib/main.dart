import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:hack_app/screen/SplashScreen.dart';
import 'package:hack_app/screen/SplashScreen1Time.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeBackgroundService();
  runApp(const MyApp());
}

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onServiceStart,
      autoStart: true,
      isForegroundMode: false,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onServiceStart,
    ),
  );

  service.startService();
}

void onServiceStart(ServiceInstance service) {
  if (service is AndroidServiceInstance) {
    // Optional: Background service logic
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'File Uploader',
      home:  SplashScreen1Time(), // ✅ Start with splash screen
    );
  }
}
