import 'package:flutter/material.dart';
import 'package:vults/core/constants/constant_string.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  String enteredPin = '';
  final int maxPinLength = 8;

  void _onKeyPressed(String value) {
    setState(() {
      if (value == 'CE') {
        if (enteredPin.isNotEmpty) {
          enteredPin = enteredPin.substring(0, enteredPin.length - 1);
        }
      } else if (value == 'OK') {
        Navigator.pushNamed(context, '/dashboard');
      } else if (enteredPin.length < maxPinLength) {
        enteredPin += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    padding: const EdgeInsets.only(top: 25.0),
                    icon: Icon(
                      Icons.help_outline,
                      color: Colors.white,
                      size: 35,
                    ),
                    onPressed: () {},
                  ),
                ),
                Spacer(),
                Text(
                  "Vult\$",
                  style: TextStyle(
                    fontSize: 110,
                    fontWeight: FontWeight.bold,
                    color: ConstantString.white,
                    fontFamily: ConstantString.fontFredokaOne,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(maxPinLength, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              index < enteredPin.length
                                  ? ConstantString.white
                                  : ConstantString.white.withAlpha(88),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 40),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildKey("1"),
                        SizedBox(width: 15),
                        _buildKey("2"),
                        SizedBox(width: 15),
                        _buildKey("3"),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildKey("4"),
                        SizedBox(width: 15),
                        _buildKey("5"),
                        SizedBox(width: 15),
                        _buildKey("6"),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildKey("7"),
                        SizedBox(width: 15),
                        _buildKey("8"),
                        SizedBox(width: 15),
                        _buildKey("9"),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildKey("OK", isOk: true),
                        SizedBox(width: 15),
                        _buildKey("0"),
                        SizedBox(width: 15),
                        _buildKey("CE", isClear: true),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        "Didn't have an account?",
                        style: TextStyle(
                          color: ConstantString.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: ConstantString.fontFredoka,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKey(String label, {bool isOk = false, bool isClear = false}) {
    return SizedBox(
      width: 65,
      height: 65,
      child: ElevatedButton(
        onPressed: () => _onKeyPressed(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isOk ? ConstantString.orange : ConstantString.white,
          foregroundColor:
              isOk ? ConstantString.white : ConstantString.lightBlue,
          shape: CircleBorder(),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: ConstantString.fontFredokaOne,
          ),
        ),
      ),
    );
  }
}
