import 'package:flutter/material.dart';
import './core/constants/constant_string.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import './views/screens/mobile/splash_screen.dart' as mobile;
import './views/screens/web/splash_screen.dart' as web;

// Firebase.
import 'package:firebase_core/firebase_core.dart';
import './firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ConstantString.appName,
      debugShowCheckedModeBanner: false,
      home: kIsWeb ? const web.SplashScreen() : const mobile.SplashScreen(),
    );
  }
}
