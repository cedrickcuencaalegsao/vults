import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'package:vults/model/settings_model.dart';
import 'package:vults/viewmodels/bloc/settings/settings_bloc.dart';
import 'package:vults/views/screens/mobile/downloadpdf_screen.dart';
import 'package:vults/views/widgets/mobile/app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(LoadSettingsRequested());
  }

  Widget _buildSettingItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: ConstantString.darkBlue,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: ConstantString.darkBlue,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsSignedOut) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/login', (route) => false);
        } else if (state is SettingsError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: ConstantString.lightGrey,
            appBar: const CustomAppBar(
              title: 'Settings',
              iconColor: ConstantString.darkBlue,
              fontColor: ConstantString.darkBlue,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: ConstantString.fontFredokaOne,
            ),
            body: SafeArea(
              child:
                  state is SettingsLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state is SettingsLoaded
                      ? _buildSettingsContent(context, state.settings)
                      : const Center(
                        child: Text('Error loading settings'),
                      ), // Fixed: removed 'text:' parameter
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingsContent(BuildContext context, SettingsModel settings) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account Section
          Text(
            "Account",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: ConstantString.fontFredokaOne,
              color: ConstantString.darkBlue,
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.lock_person_rounded,
                color: ConstantString.orange,
              ),
            ),
            title: Text(
              "${settings.firstName} ${settings.lastName}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ConstantString.darkBlue,
              ),
            ),
            subtitle: Text(
              settings.email,
              style: TextStyle(color: ConstantString.darkBlue.withOpacity(0.7)),
            ),
            trailing: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: ConstantString.darkBlue,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, '/accountsettings'),
          ),
          const SizedBox(height: 24),

          // Settings Section
          Text(
            "Settings",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: ConstantString.fontFredokaOne,
              color: ConstantString.darkBlue,
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            icon: Icons.notifications_active_outlined,
            iconColor: ConstantString.red,
            title: "Notification",
            onTap: () {
              Navigator.pushNamed(context, '/notificationsetting');
            },
          ),
          _buildSettingItem(
            icon: Icons.picture_as_pdf,
            iconColor: ConstantString.green,
            title: "Download Transaction",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DownloadPdfScreen(),
                ),
              );
            },
          ),
          _buildSettingItem(
            icon: Icons.devices,
            iconColor: ConstantString.lightBlue,
            title: "Devices",
            onTap: () {
              Navigator.pushNamed(context, '/devices');
            },
          ),
          const Spacer(),

          // Sign Out Button
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Add event to bloc
                BlocProvider.of<SettingsBloc>(context).add(SignOutRequested());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ConstantString.darkBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: Text(
                "Sign Out",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: ConstantString.fontFredokaOne,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
