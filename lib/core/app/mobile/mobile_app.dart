import 'package:flutter/material.dart';

class MobileApp extends StatefulWidget {
  const MobileApp({super.key});

  @override
  MobileAppState createState() => MobileAppState();
}

class MobileAppState extends State<MobileApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile App',
      home: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[Text('Mobile App')],
        ),
      ),
    );
  }
}
