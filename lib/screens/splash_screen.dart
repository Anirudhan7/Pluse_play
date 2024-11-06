import 'package:flutter/material.dart';
import 'package:pluseplay/database/function/internal_storage.dart';
import 'package:pluseplay/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pluseplay/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstOpen = prefs.getBool('isFirstOpen') ?? true;

    await Future.delayed(const Duration(seconds: 3));

    if (isFirstOpen) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
      await prefs.setBool('isFirstOpen', false);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "lib/assets/images/splashScreen.jpg",
              fit: BoxFit.cover,
            ),
          ),
          const Center(
            child: Text(
              "PulsePlay",
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
