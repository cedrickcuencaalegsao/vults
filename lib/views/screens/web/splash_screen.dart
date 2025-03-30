import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Text('Splash Screen WEB.'),
      ),
    );
  }
}
