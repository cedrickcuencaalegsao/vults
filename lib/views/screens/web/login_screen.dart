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
  bool _rememberMe = false;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate network delay
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        _nav();
      });
    }
  }

  void _nav() {
    Navigator.pushNamed(context, '/webApp');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 768;

    return Scaffold(
      backgroundColor: ConstantString.lightGrey.withOpacity(0.1),
      body: Row(
        children: [
          // Left side - Brand section (hidden on small screens)
          if (!isSmallScreen)
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: ConstantString.darkBlue,
                  image: DecorationImage(
                    image: const AssetImage('assets/images/login_bg.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      ConstantString.darkBlue.withOpacity(0.7),
                      BlendMode.srcOver,
                    ),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ConstantString.appName,
                          style: const TextStyle(
                            fontFamily: ConstantString.fontFredokaOne,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: const Text(
                            'Enterprise-grade financial management platform for organizations and individuals',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: ConstantString.fontFredoka,
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Right side - Login form
          Expanded(
            flex: isSmallScreen ? 10 : 5,
            child: Center(
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
                              // Logo or App Icon
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: ConstantString.lightBlue.withOpacity(
                                    0.1,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.shield_outlined,
                                  size: 48,
                                  color: ConstantString.lightBlue,
                                  semanticLabel: 'Security shield icon',
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Welcome',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: ConstantString.fontFredokaOne,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: ConstantString.darkBlue,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Please sign in to access your account',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: ConstantString.fontFredoka,
                                  fontSize: 16,
                                  color: ConstantString.grey,
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Email field
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Email Address',
                                  hintText: 'Enter your email address',
                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
                                    color: ConstantString.darkBlue,
                                    semanticLabel: 'Email icon',
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
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: ConstantString.lightGrey
                                      .withOpacity(0.1),
                                  labelStyle: const TextStyle(
                                    fontFamily: ConstantString.fontFredoka,
                                    color: ConstantString.darkBlue,
                                  ),
                                  errorText: _emailError,
                                ),
                                style: const TextStyle(
                                  fontFamily: ConstantString.fontFredoka,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email address is required';
                                  }
                                  if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                  ).hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                                onChanged: (_) {
                                  if (_emailError != null) {
                                    setState(() {
                                      _emailError = null;
                                    });
                                  }
                                },
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 20),

                              // Password field
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  hintText: 'Enter your password',
                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: ConstantString.darkBlue,
                                    semanticLabel: 'Password lock icon',
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: ConstantString.darkBlue,
                                      semanticLabel:
                                          _obscurePassword
                                              ? 'Show password'
                                              : 'Hide password',
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                    tooltip:
                                        _obscurePassword
                                            ? 'Show password'
                                            : 'Hide password',
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
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: ConstantString.lightGrey
                                      .withOpacity(0.1),
                                  labelStyle: const TextStyle(
                                    fontFamily: ConstantString.fontFredoka,
                                    color: ConstantString.darkBlue,
                                  ),
                                  errorText: _passwordError,
                                ),
                                style: const TextStyle(
                                  fontFamily: ConstantString.fontFredoka,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                                onChanged: (_) {
                                  if (_passwordError != null) {
                                    setState(() {
                                      _passwordError = null;
                                    });
                                  }
                                },
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _handleLogin(),
                              ),
                              const SizedBox(height: 16),

                              // Remember me and forgot password
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Checkbox(
                                          value: _rememberMe,
                                          onChanged: (value) {
                                            setState(() {
                                              _rememberMe = value ?? false;
                                            });
                                          },
                                          activeColor: ConstantString.lightBlue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Remember me',
                                        style: TextStyle(
                                          fontFamily:
                                              ConstantString.fontFredoka,
                                          color: ConstantString.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        fontFamily: ConstantString.fontFredoka,
                                        color: ConstantString.lightBlue,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Login button
                              ElevatedButton(
                                onPressed: _isLoading ? null : _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: ConstantString.white,
                                  backgroundColor: ConstantString.lightBlue,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                  disabledBackgroundColor: ConstantString
                                      .lightBlue
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
                                          'Sign In',
                                          style: const TextStyle(
                                            fontFamily:
                                                ConstantString.fontFredoka,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                              ),

                              const SizedBox(height: 24),

                              // Sign up option
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Don\'t have an account?',
                                    style: TextStyle(
                                      fontFamily: ConstantString.fontFredoka,
                                      color: ConstantString.grey,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Register',
                                      style: TextStyle(
                                        fontFamily: ConstantString.fontFredoka,
                                        color: ConstantString.lightBlue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
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
          ),
        ],
      ),
    );
  }
}
