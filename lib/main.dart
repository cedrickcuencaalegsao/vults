import 'package:flutter/material.dart';
import './core/constants/constant_string.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// Mobile Views.
import './views/screens/mobile/splash_screen.dart' as mobile;
import './views/screens/mobile/landing_screen.dart' as mobile;
import './views/screens/mobile/login_screen.dart' as mobile;
import './views/screens/mobile/register_screen.dart' as mobile;
import './views/screens/mobile/dashboard_screen.dart' as mobile;
import './views/screens/mobile/sendmoney_screen.dart' as mobile;
import './views/screens/mobile/transaction_screen.dart' as mobile;
import './views/screens/mobile/settings_screen.dart' as mobile;
// Web Views.
import './views/screens/web/splash_screen.dart' as web;
import './views/screens/web/landing_screen.dart' as web;
import './views/screens/web/login_screen.dart' as web;

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
      // home: kIsWeb ? const web.SplashScreen() : const mobile.SplashScreen(),
      routes: kIsWeb ? WebRoutes.getRoutes() : MobileRoutes.getRoutes(),
    );
  }
}

class MobileRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return <String, WidgetBuilder>{
      '/': (BuildContext context) => const mobile.SplashScreen(),
      '/landing': (BuildContext context) => const mobile.LandingScreen(),
      '/login': (BuildContext context) => const mobile.LoginScreen(),
      '/register': (BuildContext context) => const mobile.RegisterFirstScreen(),
      '/dashboard': (BuildContext context) => const mobile.DashboardScreen(),
      '/sendmoney':
          (BuildContext context) => const mobile.SendmoneyFirstScreen(),
      '/transaction':
          (BuildContext context) => const mobile.TransactionScreen(),
      '/settings': (BuildContext context) => const mobile.SettingsScreen(),
    };
  }
}

class WebRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return <String, WidgetBuilder>{
      '/': (BuildContext context) => const web.SplashScreen(),
      '/landing': (BuildContext context) => const web.LandingScreen(),
      '/login': (BuildContext context) => const web.LoginScreen(),
    };
  }
}
