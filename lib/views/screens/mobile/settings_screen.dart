import 'package:flutter/material.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'package:vults/views/screens/mobile/accountsettings_screen.dart';
import 'package:vults/views/screens/mobile/downloadpdf_screen.dart';
import 'package:vults/views/screens/mobile/notificationsetting_screen.dart';
import 'package:vults/views/widgets/mobile/app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

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
        child: Padding(
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
                  "Firstname Lastname",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ConstantString.darkBlue,
                  ),
                ),
                subtitle: Text(
                  "example@email.com",
                  style: TextStyle(
                    color: ConstantString.darkBlue.withOpacity(0.7),
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
                onTap: () {
                  // Navigate to account settings
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountSettingsScreen(),
                    ),
                  );
                },
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
                  // Navigate to notification settings
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationSettingScreen(),
                    ),
                  );
                },
              ),
              _buildSettingItem(
                icon: Icons.picture_as_pdf,
                iconColor: ConstantString.green,
                title: "Download PDF",
                onTap: () {
                  // Navigate to Download PDF screen
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
                  // Devices settings
                  // Add navigation to Devices screen when available
                },
              ),
              const Spacer(),

              // Sign Out Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Sign out
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
        ),
      ),
    );
  }
}
