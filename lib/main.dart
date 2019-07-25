import 'package:demo/splash_screen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(SplashScreenDemoApp());
}

class SplashScreenDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Stateless Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: SplashScreen(),

    );
  }
}
