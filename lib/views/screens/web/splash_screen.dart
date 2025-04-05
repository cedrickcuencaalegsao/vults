import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // child: Text('Splash Screen WEB.'),

        // for testing CORS issue
        child: Image.network(
          'https://firebasestorage.googleapis.com/v0/b/volts-app-70252.firebasestorage.app/o/test%2Ftest.jpg?alt=media&token=2dd28365-6d3a-4100-b6e7-de03edcb71af',
        ),
      ),
    );
  }
}
