import 'dart:async';

import 'package:flutter/material.dart';

import '../homePage/homescreen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 7), () {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo(1).png",
              height: 200,
              width: 200,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 15),
            Text(
              "Kitchen Logo",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                foreground: Paint()..shader = LinearGradient(colors: [
                  Colors.red,Colors.lightBlue,
                ]).createShader(Rect.fromLTRB(50, 10, 300, 70)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}