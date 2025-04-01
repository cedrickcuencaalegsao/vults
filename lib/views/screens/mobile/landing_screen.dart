import 'package:flutter/material.dart';
import 'package:vults/core/constants/constant_string.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                SizedBox(height: size.height * 0.20),
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
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ConstantString.lightBlue,
                          foregroundColor: ConstantString.white,
                          minimumSize: const Size(double.infinity, 70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: ConstantString.fontFredokaOne,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ConstantString.darkBlue,
                          side: BorderSide(
                            color: ConstantString.white,
                            width: 2,
                          ),
                          minimumSize: const Size(double.infinity, 70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          backgroundColor: ConstantString.white,
                        ),
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: ConstantString.fontFredokaOne,
                            color: ConstantString.darkBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
