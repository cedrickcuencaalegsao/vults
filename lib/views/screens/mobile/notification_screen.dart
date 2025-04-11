import 'package:flutter/material.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'package:vults/views/widgets/mobile/app_bar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  NotificationScreenState createState() => NotificationScreenState();
  
}

class NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: "Notifications",
        iconColor: ConstantString.darkBlue,
        fontColor: ConstantString.darkBlue,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: ConstantString.fontFredokaOne,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ConstantString.lightGrey, ConstantString.darkBlue],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            SizedBox(height: 70),
            _buildNotificationItem(
              context,
              title: "Notification",
              message: "You've received ₱100.00....",
              fullMessage:
                  "You have received ₱100.00 from (sender name).\n\nYou can track this transaction using Ref.\n(ref=(ref_Num)).",
            ),
            _buildNotificationItem(
              context,
              title: "Alert!",
              message: "You've recently logged into....",
              fullMessage:
                  "You have recently logged into this new device:\n(device name).",
              isAlert: true,
            ),
            _buildNotificationItem(
              context,
              title: "Update",
              message: "You've successfully updated your...",
              fullMessage:
                  "You have successfully updated your profile.\nTo see the update click the profile section.",
              isUpdate: true,
            ),
            _buildNotificationItem(
              context,
              title: "Notification",
              message: "You've received ₱100.00....",
              fullMessage:
                  "You have received ₱100.00 from (sender name).\n\nYou can track this transaction using Ref.\n(ref=(ref_Num)).",
            ),
            _buildNotificationItem(
              context,
              title: "Alert!",
              message: "You've recently logged into....",
              fullMessage:
                  "You have recently logged into this new device:\n(device name).",
              isAlert: true,
            ),
            _buildNotificationItem(
              context,
              title: "Update",
              message: "You've successfully updated your...",
              fullMessage:
                  "You have successfully updated your profile.\nTo see the update click the profile section.",
              isUpdate: true,
            ),
            _buildNotificationItem(
              context,
              title: "Notification",
              message: "You've received ₱100.00....",
              fullMessage:
                  "You have received ₱100.00 from (sender name).\n\nYou can track this transaction using Ref.\n(ref=(ref_Num)).",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context, {
    required String title,
    required String message,
    required String fullMessage,
    bool isAlert = false,
    bool isUpdate = false,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: ConstantString.white,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color:
                isAlert
                    ? ConstantString.red.withOpacity(0.2)
                    : isUpdate
                    ? ConstantString.green.withOpacity(0.2)
                    : ConstantString.lightBlue.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isAlert
                ? Icons.warning
                : isUpdate
                ? Icons.update
                : Icons.notifications,
            color:
                isAlert
                    ? ConstantString.red
                    : isUpdate
                    ? ConstantString.green
                    : ConstantString.lightBlue,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: ConstantString.fontFredokaOne,
            color: ConstantString.darkGrey,
          ),
        ),
        subtitle: Text(
          message,
          style: TextStyle(
            fontFamily: ConstantString.fontFredoka,
            color: ConstantString.grey,
          ),
        ),
        onTap:
            () => _showNotificationDetails(
              context,
              title,
              fullMessage,
              isAlert
                  ? Icons.warning
                  : (isUpdate ? Icons.update : Icons.notifications),
            ),
      ),
    );
  }

  void _showNotificationDetails(
    BuildContext context,
    String title,
    String message,
    IconData icon,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(icon, size: 50, color: ConstantString.darkGrey),
                  SizedBox(height: 16),
                  Text(
                    message,
                    style: TextStyle(
                      fontFamily: ConstantString.fontFredoka,
                      fontSize: 16,
                      color: ConstantString.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Close",
                        style: TextStyle(
                          color: ConstantString.lightBlue,
                          fontFamily: ConstantString.fontFredokaOne,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}