import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'package:vults/viewmodels/bloc/auth/auth_bloc.dart';
import 'package:vults/views/widgets/mobile/error.dart';
import 'package:vults/views/widgets/mobile/success.dart';
import 'package:vults/views/widgets/mobile/loading.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  String enteredPin = '';
  final int maxPinLength = 8;
  final TextEditingController emailController = TextEditingController();

  void _onKeyPressed(String value) {
    setState(() {
      if (value == 'CE') {
        if (enteredPin.isNotEmpty) {
          enteredPin = enteredPin.substring(0, enteredPin.length - 1);
        }
      } else if (value == 'OK') {
        // Validate email and PIN before attempting login
        if (emailController.text.isNotEmpty && enteredPin.isNotEmpty) {
          // Dispatch login event to the AuthBloc
          context.read<AuthBloc>().add(
            AuthLoginRequested(
              email: emailController.text.trim(),
              pin: enteredPin,
            ),
          );
        }
      } else if (enteredPin.length < maxPinLength) {
        enteredPin += value;
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _navigate(){
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          LoadingSnackBar.show(
            context: context,
            message: 'Logging in...',
            backgroundColor: ConstantString.lightBlue,
          );
        } else if (state is AuthAuthenticated) {
          // Navigate to dashboard on successful login
          SuccessSnackBar.show(
            context: context,
            message: 'Login successful!',
            backgroundColor: ConstantString.green,
          );
          Future.delayed(const Duration(seconds: 3), () {
            _navigate();
          });
        } else if (state is AuthError) {
          ErrorSnackBar.show(
            context: context,
            message: state.message,
            backgroundColor: ConstantString.red,
          );
        }
      },
      child: Scaffold(
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
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
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
                        SizedBox(height: 30),
                        Text(
                          ConstantString.appName,
                          style: TextStyle(
                            fontSize: 110,
                            fontWeight: FontWeight.bold,
                            color: ConstantString.white,
                            fontFamily: ConstantString.fontFredokaOne,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: ConstantString.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: TextField(
                              controller: emailController,
                              style: TextStyle(
                                color: ConstantString.white,
                                fontSize: 18,
                                fontFamily: ConstantString.fontFredoka,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: ConstantString.email,
                                hintStyle: TextStyle(
                                  color: ConstantString.white.withValues(
                                    alpha: 0.5,
                                  ),
                                  fontSize: 18,
                                  fontFamily: ConstantString.fontFredoka,
                                ),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: ConstantString.white,
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(maxPinLength, (index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                              ),
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
                        SizedBox(height: 30),
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
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 70),
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
