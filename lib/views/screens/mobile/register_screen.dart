import 'package:flutter/material.dart';
import '../../../core/constants/constant_string.dart';
import '../../widgets/mobile/app_bar.dart';
import '../../widgets/mobile/buttons.dart';
import '../../widgets/mobile/inputs.dart';
import '../../widgets/mobile/registration_progress.dart';

class RegisterFirstScreen extends StatefulWidget {
  const RegisterFirstScreen({super.key});

  @override
  RegisterFirstScreenState createState() => RegisterFirstScreenState();
}

class RegisterFirstScreenState extends State<RegisterFirstScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final String _agreement = "agreement";
  final bool _read = false;
  final bool _agree = false;
  bool _isLoading = false;

  void _navigate() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RegisterSecondScreen()),
      );
    } // Simulate loading
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: ConstantString.register,
        iconColor: ConstantString.darkBlue,
        fontColor: ConstantString.darkBlue,
        fontSize: 20,
        fontFamily: ConstantString.fontFredokaOne,
        fontWeight: FontWeight.bold,
      ),
      body: Container(
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [ConstantString.darkBlue, ConstantString.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + kToolbarHeight + 20,
              bottom: 20,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: screenHeight * 0.04),
                  Text(
                    ConstantString.userProfile,
                    style: TextStyle(
                      color: ConstantString.darkBlue,
                      fontSize: 40,
                      fontFamily: ConstantString.fontFredokaOne,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.07),
                  CustomInput(
                    hintText: ConstantString.fistname,
                    prefixIcon: Icons.person_2_rounded,
                    controller: _firstNameController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  CustomInput(
                    hintText: ConstantString.middlename,
                    prefixIcon: Icons.person_2_rounded,
                    controller: _middleNameController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  CustomInput(
                    hintText: ConstantString.lastname,
                    prefixIcon: Icons.person_2_rounded,
                    controller: _lastNameController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Container(
                    width: screenWidth * 0.8,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: _read,
                              groupValue: _agreement,
                              onChanged: (value) {
                                debugPrint('Radio $value');
                              },
                            ),
                            Text(
                              ConstantString.readPolicy,
                              style: TextStyle(
                                color: ConstantString.white,
                                fontSize: 15,
                                fontFamily: ConstantString.fontFredoka,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: _agree,
                              groupValue: _agreement,
                              onChanged: (value) {
                                debugPrint('Radio $value');
                              },
                            ),
                            Text(
                              ConstantString.agreePolicy,
                              style: TextStyle(
                                color: ConstantString.white,
                                fontSize: 15,
                                fontFamily: ConstantString.fontFredoka,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  CustomButton(
                    text: ConstantString.next,
                    color: ConstantString.darkBlue,
                    textColor: ConstantString.white,
                    fontSize: screenHeight * 0.025,
                    fontWeight: FontWeight.bold,
                    fontFamily: ConstantString.fontFredokaOne,
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.06,
                    borderRadius: 30,
                    isLoading: _isLoading,
                    onPressed: _navigate,
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  RegistrationProgress(currentStep: 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterSecondScreen extends StatefulWidget {
  const RegisterSecondScreen({super.key});

  @override
  RegisterSecondScreenState createState() => RegisterSecondScreenState();
}

class RegisterSecondScreenState extends State<RegisterSecondScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _confirmEmail = TextEditingController();
  final TextEditingController _birthday = TextEditingController();
  final TextEditingController _pin = TextEditingController();
  final TextEditingController _confimPin = TextEditingController();
  bool _isLoading = false;

  void _navigate() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RegisterThirdScreen()),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: ConstantString.register,
        iconColor: ConstantString.darkBlue,
        fontColor: ConstantString.darkBlue,
        fontSize: 20,
        fontFamily: ConstantString.fontFredokaOne,
        fontWeight: FontWeight.bold,
      ),
      body: Container(
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [ConstantString.darkBlue, ConstantString.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + kToolbarHeight + 20,
              bottom: 20,
            ),
            child: Column(
              children: <Widget>[
                SizedBox(width: screenWidth),
                Text(
                  ConstantString.userProfile,
                  style: TextStyle(
                    color: ConstantString.darkBlue,
                    fontSize: 40,
                    fontFamily: ConstantString.fontFredokaOne,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                CustomInput(
                  hintText: ConstantString.email,
                  prefixIcon: Icons.email_rounded,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomInput(
                  hintText: ConstantString.confirmEmail,
                  prefixIcon: Icons.email_rounded,
                  controller: _confirmEmail,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
                const SizedBox(height: 20),
                CustomInput(
                  hintText: ConstantString.birthday,
                  prefixIcon: Icons.calendar_month_rounded,
                  controller: _birthday,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
                SizedBox(height: screenHeight * 0.05),
                Text(
                  "Note: Always remember this pin.",
                  style: TextStyle(
                    fontFamily: ConstantString.fontFredoka,
                    fontSize: 20,
                    color: ConstantString.white,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                CustomInput(
                  hintText: ConstantString.pin,
                  prefixIcon: Icons.lock_rounded,
                  controller: _pin,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
                SizedBox(height: screenHeight * 0.03),
                CustomInput(
                  hintText: ConstantString.confirmPin,
                  prefixIcon: Icons.lock_rounded,
                  controller: _confimPin,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
                SizedBox(height: screenHeight * 0.05),
                CustomButton(
                  text: ConstantString.next,
                  color: ConstantString.darkBlue,
                  textColor: ConstantString.white,
                  fontSize: screenHeight * 0.025,
                  fontWeight: FontWeight.bold,
                  fontFamily: ConstantString.fontFredokaOne,
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.06,
                  borderRadius: 30,
                  isLoading: _isLoading,
                  onPressed: _navigate,
                ),
                SizedBox(height: screenHeight * 0.05),
                RegistrationProgress(currentStep: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterThirdScreen extends StatefulWidget {
  const RegisterThirdScreen({super.key});

  @override
  RegisterThirdScreenState createState() => RegisterThirdScreenState();
}

class RegisterThirdScreenState extends State<RegisterThirdScreen> {
  bool _isLoading = false;

  void _navigate() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pushNamed(context, "/landing");
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: "Register New Account",
        iconColor: ConstantString.darkBlue,
        fontColor: ConstantString.darkBlue,
        fontSize: 20,
        fontFamily: ConstantString.fontFredokaOne,
        fontWeight: FontWeight.bold,
      ),
      body: Container(
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [ConstantString.darkBlue, ConstantString.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + kToolbarHeight + 20,
              bottom: 20,
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: screenHeight * 0.07),
                Icon(
                  Icons.playlist_add_check_rounded,
                  color: ConstantString.green,
                  size: 200,
                ),
                // SizedBox(height: screenHeight * 0.02),
                Text(
                  "Informatin",
                  style: TextStyle(
                    color: ConstantString.darkBlue,
                    fontSize: 35,
                    fontFamily: ConstantString.fontFredokaOne,
                  ),
                ),
                Text(
                  "Ready.",
                  style: TextStyle(
                    color: ConstantString.darkBlue,
                    fontSize: 35,
                    fontFamily: ConstantString.fontFredokaOne,
                  ),
                ),
                SizedBox(height: screenHeight * 0.15),
                Text("Click continue to fully register.", style: TextStyle(
                  fontFamily: ConstantString.fontFredoka,
                  fontSize: 18,
                  color: ConstantString.white,
                ),),
                SizedBox(height: screenHeight * 0.03),
                CustomButton(
                  text: ConstantString.continueTxt,
                  color: ConstantString.darkBlue,
                  textColor: ConstantString.white,
                  fontSize: screenHeight * 0.025,
                  fontWeight: FontWeight.bold,
                  fontFamily: ConstantString.fontFredokaOne,
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.06,
                  borderRadius: 30,
                  isLoading: _isLoading,
                  onPressed: _navigate,
                ),
                SizedBox(height: screenHeight * 0.05),
                RegistrationProgress(currentStep: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
