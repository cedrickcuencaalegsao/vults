import 'package:flutter/material.dart';
import 'package:vults/views/screens/mobile/login_screen.dart';

class AuthGuard {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // Will be implemented by Firebase team
    bool isAuthenticated = false;

    if (!isAuthenticated && settings.name != '/login') {
      return MaterialPageRoute(builder: (_) => LoginScreen());
    }
    return null;
  }
}
