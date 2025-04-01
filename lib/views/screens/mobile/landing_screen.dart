import 'package:flutter/material.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'package:vults/views/widgets/mobile/buttons.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void _login(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }
  void _register(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // final size = MediaQuery.of(context).size;

    return Scaffold(
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.20),
                // Title
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: ConstantString.white,
                      fontFamily: ConstantString.fontFredoka,
                      height: 1.1,
                    ),
                    children: [
                      TextSpan(
                        text: "Vult\$",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: ConstantString.fontFredokaOne,
                        ),
                      ),
                      TextSpan(text: " the\nbest mobile\nbank App."),
                    ],
                  ),
                ),
                const SizedBox(height: 8), // Reduced from 25 to 8
                // Description
                Text(
                  "Secure, fast, and\nseamless financial\nmanagement anytime,\nanywhere.",
                  style: TextStyle(
                    color: ConstantString.white,
                    fontSize: 28,
                    fontFamily: ConstantString.fontFredoka,
                    height: 1.3,
                  ),
                ),
                const Spacer(flex: 2),
                // Buttons
                Center(
                  child: Column(
                    children: [
                      CustomButton(
                        text: ConstantString.login,
                        color: ConstantString.lightBlue,
                        textColor: ConstantString.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: ConstantString.fontFredokaOne,
                        width: screenWidth * 0.85,
                        height: screenHeight * 0.07,
                        borderRadius: 30,
                        onPressed: ()=>_login(context),  
                      ), 
                       SizedBox(height: screenHeight * 0.02),
                      CustomButton(
                        text: ConstantString.register,
                        color: ConstantString.white,
                        textColor: ConstantString.darkBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: ConstantString.fontFredokaOne,
                        width: screenWidth * 0.85,
                        height: screenHeight * 0.07,
                        borderRadius: 30,
                        onPressed: ()=>_register(context),  
                      ), 
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.07),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
