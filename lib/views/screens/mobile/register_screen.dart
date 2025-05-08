import 'package:flutter/material.dart';
import 'package:vults/core/constants/constant_string.dart';
import '../../widgets/mobile/app_bar.dart';
import '../../widgets/mobile/buttons.dart';
import '../../widgets/mobile/inputs.dart';
import '../../widgets/mobile/registration_progress.dart';
import 'package:vults/views/widgets/mobile/error.dart';

class RegisterFirstScreen extends StatefulWidget {
  const RegisterFirstScreen({super.key});

  @override
  RegisterFirstScreenState createState() => RegisterFirstScreenState();
}

class RegisterFirstScreenState extends State<RegisterFirstScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  bool _read = false;
  bool _agree = false;
  bool _isLoading = false;

  void _navigate() async {
    if (_firstNameController.text.isEmpty) {
      ErrorSnackBar.show(context: context, message: 'First name is required.');
      return;
    }

    if (_lastNameController.text.isEmpty) {
      ErrorSnackBar.show(context: context, message: 'Last name is required.');
      return;
    }

    if (!_read || !_agree) {
      ErrorSnackBar.show(
        context: context,
        message: 'Please read and agree to the policy.',
      );
      return;
    }
    final firstName = _firstNameController.text;
    final middleName = _middleNameController.text;
    final lastName = _lastNameController.text;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => RegisterSecondScreen(
                firstName: firstName,
                middleName: middleName,
                lastName: lastName,
              ),
        ),
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
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  CustomInput(
                    hintText: ConstantString.middlename,
                    prefixIcon: Icons.person_2_rounded,
                    controller: _middleNameController,
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  CustomInput(
                    hintText: ConstantString.lastname,
                    prefixIcon: Icons.person_2_rounded,
                    controller: _lastNameController,
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
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _read = !_read; // Toggle the state
                            });
                          },
                          child: Row(
                            children: [
                              Radio<bool>(
                                value: true,
                                groupValue: _read, // Current state
                                onChanged: (bool? value) {
                                  setState(() {
                                    _read = value ?? false;
                                  });
                                },
                                activeColor: ConstantString.white,
                                fillColor: WidgetStateProperty.resolveWith<
                                  Color
                                >((Set<WidgetState> states) {
                                  if (states.contains(WidgetState.disabled)) {
                                    return Colors.grey;
                                  }
                                  return ConstantString.white;
                                }),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.padded,
                              ),
                              Text(
                                _read
                                    ? ConstantString.readPolicy
                                    : ConstantString.readPolicy,
                                style: TextStyle(
                                  color: ConstantString.white,
                                  fontSize: 15,
                                  fontFamily: ConstantString.fontFredoka,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _agree = !_agree; // Toggle the state
                            });
                          },
                          child: Row(
                            children: [
                              Radio<bool>(
                                value: true,
                                groupValue: _agree, // Current state
                                onChanged: (bool? value) {
                                  setState(() {
                                    _agree = value ?? false;
                                  });
                                },
                                activeColor: ConstantString.white,
                                fillColor: WidgetStateProperty.resolveWith<
                                  Color
                                >((Set<WidgetState> states) {
                                  if (states.contains(WidgetState.disabled)) {
                                    return Colors.grey;
                                  }
                                  return ConstantString.white;
                                }),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.padded,
                              ),
                              Text(
                                _agree
                                    ? ConstantString.agreePolicy
                                    : ConstantString.agreePolicy,
                                style: TextStyle(
                                  color: ConstantString.white,
                                  fontSize: 15,
                                  fontFamily: ConstantString.fontFredoka,
                                ),
                              ),
                            ],
                          ),
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
  final String firstName;
  final String middleName;
  final String lastName;

  const RegisterSecondScreen({
    super.key,
    required this.firstName,
    required this.middleName,
    required this.lastName,
  });

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
    if (_email.text.isEmpty) {
      ErrorSnackBar.show(context: context, message: 'Email is required.');
      return;
    }

    if (_confirmEmail.text.isEmpty) {
      ErrorSnackBar.show(
        context: context,
        message: 'Confirm email is required.',
      );
      return;
    }

    if (_confirmEmail.text != _email.text) {
      ErrorSnackBar.show(
        context: context,
        message: 'Email and confirm email do not match.',
      );
      return;
    }

    if (_birthday.text.isEmpty) {
      ErrorSnackBar.show(context: context, message: 'Birthday is required.');
      return;
    }

    // Validate birthday format (mm/dd/yyyy)
    final birthdayRegex = RegExp(
      r'^(0[1-9]|1[0-2])/(0[1-9]|[12][0-9]|3[01])/\d{4}$',
    );

    if (!birthdayRegex.hasMatch(_birthday.text)) {
      ErrorSnackBar.show(
        context: context,
        message: 'Birthday must be in mm/dd/yyyy (Month/Day/Year) format.',
      );
      return;
    }

    if (_pin.text.isEmpty) {
      ErrorSnackBar.show(context: context, message: 'Pin is required.');
      return;
    }

    if (int.tryParse(_pin.text) == null) {
      ErrorSnackBar.show(
        context: context,
        message: 'Pin must be a numbers only.',
      );
      return;
    }

    if (_pin.text.length != 8) {
      ErrorSnackBar.show(
        context: context,
        message: 'Pin must be exactly 8 digits long.',
      );
      return;
    }

    if (_confimPin.text.isEmpty) {
      ErrorSnackBar.show(context: context, message: 'Confirm pin is required.');
      return;
    }

    if (_confimPin.text != _pin.text) {
      ErrorSnackBar.show(
        context: context,
        message: 'Pin and confirm pin do not match.',
      );
      return;
    }

    final email = _email.text;
    final confirmEmail = _confirmEmail.text;
    final birthday = _birthday.text;
    final pin = _pin.text;
    final confirmPin = _confimPin.text;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => RegisterThirdScreen(
                firstName: widget.firstName,
                middleName: widget.middleName,
                lastName: widget.lastName,
                email: email,
                confirmEmail: confirmEmail,
                birthday: birthday,
                pin: pin,
                confirmPin: confirmPin,
              ),
        ),
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
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String confirmEmail;
  final String birthday;
  final String pin;
  final String confirmPin;

  const RegisterThirdScreen({
    super.key,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.confirmEmail,
    required this.birthday,
    required this.pin,
    required this.confirmPin,
  });

  // const RegisterThirdScreen({super.key});

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

    debugPrint('Navigating to landing screen...');
    debugPrint('First Name: ${widget.firstName}');
    debugPrint('Middle Name: ${widget.middleName}');
    debugPrint('Last Name: ${widget.lastName}');
    debugPrint('Email: ${widget.email}');
    debugPrint('Confirm Email: ${widget.confirmEmail}');
    debugPrint('Birthday: ${widget.birthday}');
    debugPrint('PIN: ${widget.pin}');
    debugPrint('Confirm PIN: ${widget.confirmPin}');
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
                Text(
                  "Click continue to fully register.",
                  style: TextStyle(
                    fontFamily: ConstantString.fontFredoka,
                    fontSize: 18,
                    color: ConstantString.white,
                  ),
                ),
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
