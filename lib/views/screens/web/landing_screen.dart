import 'package:flutter/material.dart';
import 'package:vults/views/widgets/web/guess_custom_appbar.dart';
import 'package:vults/core/constants/constant_string.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  LandingScreenState createState() => LandingScreenState();
}

class LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: GuessCustomAppbar(title: "Landing Page"),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ConstantString.lightBlue, ConstantString.darkBlue],
          ),
        ),
        child: Center(
          child: Text(
            "Landing Page",
            style: const TextStyle(
              fontFamily: ConstantString.fontFredokaOne,
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
