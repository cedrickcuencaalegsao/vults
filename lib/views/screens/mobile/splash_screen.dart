import 'package:flutter/material.dart';
import './landing_screen.dart';
import '../../../core/constants/constant_string.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LandingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  <Widget>[
            Image(
              image: AssetImage('assets/icons/vultsicon.png'),
              width: screenHeight * 0.5,
              height: screenWidth * 0.5,
            ),
            Text(
              ConstantString.appName,
              style: TextStyle(
                fontFamily: ConstantString.fontFredokaOne,
                fontSize: 30,
                color: ConstantString.darkBlue,
              ),
            ),
            SizedBox(height: 150),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
