import 'package:flutter/material.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  NotificationSettingScreenState createState() => NotificationSettingScreenState();
}
class NotificationSettingScreenState extends State<NotificationSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Setting"),
      ),
      body: const Center(
        child: Text("Notification Setting Screen"),
      ),
    );
  }
}