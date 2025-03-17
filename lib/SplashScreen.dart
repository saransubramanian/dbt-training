import 'package:flutter/material.dart';
import 'SigninPage.dart'; // ✅ Correct
// Ensure this file exists and contains SigninPage

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10), () {
      // Navigate to SigninPage after 10 seconds      .3

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SigninPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            "assets/images/black-textured-wallpaper.png",
            fit: BoxFit.cover,
          ),

          // Center Logo
          Center(
            child: Image.asset(
              "assets/images/logo.png",
              width: 300, // Logo size
            ),
          ),
        ],
      ),
    );
  }
}
