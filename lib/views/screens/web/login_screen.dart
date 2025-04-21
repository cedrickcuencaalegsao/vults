import 'package:flutter/material.dart';
import 'package:vults/core/constants/constant_string.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    Navigator.pushNamed(context, '/dashboard');
    // if (_formKey.currentState!.validate()) {
    //   setState(() => _isLoading = true);

    //   // TODO: Implement actual login logic here

    //   // Simulate API call
    //   Future.delayed(const Duration(seconds: 2), () {
    //     setState(() => _isLoading = false);
    //     // Navigate to home or show error
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      backgroundColor: ConstantString.lightGrey.withOpacity(0.1),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: ConstantString.white,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo or App Name
                        const Icon(
                          Icons.lock_outline_rounded,
                          size: 64,
                          color: ConstantString.lightBlue,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Welcome to ${ConstantString.appName}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: ConstantString.fontFredokaOne,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: ConstantString.darkBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Sign in to continue',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: ConstantString.fontFredoka,
                            color: ConstantString.grey,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Email field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: ConstantString.email,
                            hintText: 'Enter your email',
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: ConstantString.darkBlue,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: ConstantString.lightBlue,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: ConstantString.lightBlue,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: ConstantString.lightGrey.withOpacity(
                              0.1,
                            ),
                            labelStyle: const TextStyle(
                              fontFamily: ConstantString.fontFredoka,
                              color: ConstantString.darkBlue,
                            ),
                          ),
                          style: const TextStyle(
                            fontFamily: ConstantString.fontFredoka,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: ConstantString.darkBlue,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: ConstantString.darkBlue,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: ConstantString.lightBlue,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: ConstantString.lightBlue,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: ConstantString.lightGrey.withOpacity(
                              0.1,
                            ),
                            labelStyle: const TextStyle(
                              fontFamily: ConstantString.fontFredoka,
                              color: ConstantString.darkBlue,
                            ),
                          ),
                          style: const TextStyle(
                            fontFamily: ConstantString.fontFredoka,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Login button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: ConstantString.white,
                            backgroundColor: ConstantString.lightBlue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            disabledBackgroundColor: ConstantString.lightBlue
                                .withOpacity(0.6),
                          ),
                          child:
                              _isLoading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: ConstantString.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text(
                                    ConstantString.loginAction,
                                    style: const TextStyle(
                                      fontFamily: ConstantString.fontFredoka,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
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
}
