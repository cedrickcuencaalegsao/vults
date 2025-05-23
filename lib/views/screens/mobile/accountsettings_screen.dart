import 'package:flutter/material.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'package:vults/viewmodels/bloc/account_settings/account_settings_bloc.dart';
// import 'dart:ui';
import 'package:vults/views/widgets/mobile/app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _pinController = TextEditingController();
  bool _obscurePin = true;

  void _showImageDialog() {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Color(0xFF0A0043),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          // Save new photo logic
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            color: Color(0xFF0A0043),
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
    );
  }

  @override
  void initState() {
    super.initState();
    // Load user settings when screen is initialized
    context.read<AccountSettingsBloc>().add(LoadAccountSettings());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountSettingsBloc, AccountSettingsState>(
      listener: (context, state) {
        if (state is AccountSettingsError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is AccountSettingsUpdated) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is AccountSettingsLoaded) {
          // Update text controllers with loaded data
          _firstNameController.text = state.firstName;
          _lastNameController.text = state.lastName;
          _emailController.text = state.email;
          // Handle nullable pin
          _pinController.text =
              state.pin ?? ''; // Use empty string if pin is null

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: const CustomAppBar(
              title: 'Account',
              iconColor: Color(0xFF0A0043),
              fontColor: Color(0xFF0A0043),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'FredokaOne',
            ),
            body: Stack(
              children: [
                // Main content
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // Profile section
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                // Profile image
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[300],
                                    border: Border.all(
                                      color: Colors.grey[400]!,
                                      width: 3,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),

                                // Status icons - positioned at bottom of circle
                                Positioned(
                                  bottom: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.warning_rounded,
                                          color: Colors.red,
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // User info
                            Text(
                              "${state.firstName} ${state.lastName}", // Dynamic name from state
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0A0043),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.email, // Dynamic email from state
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF0A0043),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Verified badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFF0A0043),
                                ),
                              ),
                              child: Text(
                                state.isVerified
                                    ? "Verified"
                                    : "Unverified", // Dynamic verification status
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0A0043),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Form section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // First Name label
                              const Text(
                                "First Name",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0A0043),
                                ),
                              ),
                              const SizedBox(height: 4),

                              // First Name input
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextField(
                                  controller: _firstNameController,
                                  onChanged: (value) {
                                    context.read<AccountSettingsBloc>().add(
                                      UpdateAccountSettings(
                                        firstName: value,
                                        lastName: _lastNameController.text,
                                        email: _emailController.text,
                                      ),
                                    );
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Last Name label
                              const Text(
                                "Last Name",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0A0043),
                                ),
                              ),
                              const SizedBox(height: 4),

                              // Last Name input
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextField(
                                  controller: _lastNameController,
                                  onChanged: (value) {
                                    context.read<AccountSettingsBloc>().add(
                                      UpdateAccountSettings(
                                        firstName: _firstNameController.text,
                                        lastName: value,
                                        email: _emailController.text,
                                      ),
                                    );
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Email field
                              const Text(
                                "Email",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0A0043),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextField(
                                  controller: _emailController,
                                  onChanged: (value) {
                                    context.read<AccountSettingsBloc>().add(
                                      UpdateAccountSettings(
                                        firstName: _firstNameController.text,
                                        lastName: _lastNameController.text,
                                        email: value,
                                      ),
                                    );
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Security Pin field with history icon outside
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Security Pin",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF0A0043),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller: _pinController,
                                                  obscureText: _obscurePin,
                                                  decoration:
                                                      const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  _obscurePin
                                                      ? Icons.visibility_off
                                                      : Icons.visibility,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _obscurePin = !_obscurePin;
                                                  });
                                                },
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.history,
                                        color: Color(0xFF0A0043),
                                        size: 24,
                                      ),
                                      onPressed: () {
                                        // Reset PIN logic
                                      },
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Save button
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // Save logic
                              _handleSave();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0A0043),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Camera button positioned at top right below app bar
                Positioned(
                  top: 10,
                  right: 16,
                  child: InkWell(
                    onTap: _showImageDialog,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: const Icon(
                        Icons.camera_alt,
                        color: ConstantString.darkBlue,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  void _handleSave() {
    context.read<AccountSettingsBloc>().add(
      UpdateAccountSettings(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
      ),
    );
  }

  void _handlePinReset() {
    if (_pinController.text.isNotEmpty) {
      context.read<AccountSettingsBloc>().add(
        UpdateSecurityPin(pin: _pinController.text),
      );
    }
  }
}
