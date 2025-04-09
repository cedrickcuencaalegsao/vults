import 'package:flutter/material.dart';
import 'package:vults/views/widgets/mobile/app_bar.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  NotificationSettingScreenState createState() =>
      NotificationSettingScreenState();
}

class NotificationSettingScreenState extends State<NotificationSettingScreen> {
  // Toggle states for different notification settings
  bool mainNotificationEnabled = true;
  bool newTransactionsEnabled = true;
  bool paymentConfirmationsEnabled = true;
  bool securityAlertsEnabled = true;
  bool promotionsEnabled = false;
  bool newsAndUpdatesEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Notification Setting',
        iconColor: Color(0xFF0A0043),
        fontColor: Color(0xFF0A0043),
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'FredokaOne',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main notification toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notification',
                    style: TextStyle(
                      color: Color(0xFF0A0043),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Switch(
                    value: mainNotificationEnabled,
                    onChanged: (value) {
                      setState(() {
                        mainNotificationEnabled = value;
                        // If main toggle is off, disable all other notifications
                        if (!value) {
                          newTransactionsEnabled = false;
                          paymentConfirmationsEnabled = false;
                          securityAlertsEnabled = false;
                          promotionsEnabled = false;
                          newsAndUpdatesEnabled = false;
                        }
                      });
                    },
                    activeTrackColor: Colors.grey.shade300,
                    activeColor: const Color(0xFF0A0043),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Transaction Notifications section
              const Text(
                'TRANSACTION NOTIFICATIONS',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15),

              // New Transactions toggle
              buildNotificationItem(
                'New Transactions',
                'Get notified when new transactions occur',
                newTransactionsEnabled,
                (value) {
                  if (mainNotificationEnabled) {
                    setState(() {
                      newTransactionsEnabled = value;
                    });
                  }
                },
              ),

              const Divider(height: 1),

              // Payment Confirmations toggle
              buildNotificationItem(
                'Payment Confirmations',
                'Get notified when payments are confirmed',
                paymentConfirmationsEnabled,
                (value) {
                  if (mainNotificationEnabled) {
                    setState(() {
                      paymentConfirmationsEnabled = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 30),

              // Security Notifications section
              const Text(
                'SECURITY NOTIFICATIONS',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15),

              // Security Alerts toggle
              buildNotificationItem(
                'Security Alerts',
                'Get notified about security-related events',
                securityAlertsEnabled,
                (value) {
                  if (mainNotificationEnabled) {
                    setState(() {
                      securityAlertsEnabled = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 30),

              // Marketing Notifications section
              const Text(
                'MARKETING NOTIFICATIONS',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15),

              // Promotions toggle
              buildNotificationItem(
                'Promotions',
                'Get notified about special offers and promotions',
                promotionsEnabled,
                (value) {
                  if (mainNotificationEnabled) {
                    setState(() {
                      promotionsEnabled = value;
                    });
                  }
                },
              ),

              const Divider(height: 1),

              // News & Updates toggle
              buildNotificationItem(
                'News & Updates',
                'Get notified about news and app updates',
                newsAndUpdatesEnabled,
                (value) {
                  if (mainNotificationEnabled) {
                    setState(() {
                      newsAndUpdatesEnabled = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              // Additional information text
              const Text(
                'You can manage your notification preferences anytime in your account settings.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNotificationItem(
    String title,
    String subtitle,
    bool isEnabled,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF0A0043),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    // Apply grey color if main toggle is off
                    // color: mainNotificationEnabled
                    //     ? const Color(0xFF0A0043)
                    //     : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled && mainNotificationEnabled,
            onChanged: mainNotificationEnabled ? onChanged : null,
            activeTrackColor: Colors.grey.shade300,
            activeColor: const Color(0xFF0A0043),
          ),
        ],
      ),
    );
  }
}
