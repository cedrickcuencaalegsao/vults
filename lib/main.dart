import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:vults/core/constants/constant_string.dart';

// Bloc.
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vults/viewmodels/bloc/auth/auth_bloc.dart';
import 'package:vults/viewmodels/bloc/settings/settings_bloc.dart';
import 'package:vults/viewmodels/bloc/transaction/transaction_bloc.dart';
import 'package:vults/viewmodels/bloc/account_settings/account_settings_bloc.dart';
import 'package:vults/viewmodels/bloc/device/device_bloc.dart';
// Mobile Views.
import 'package:vults/views/screens/mobile/register_screen.dart' as mobile;
import 'package:vults/views/screens/mobile/sendmoney_screen.dart' as mobile;
import 'package:vults/views/screens/mobile/transaction_screen.dart' as mobile;
import 'package:vults/views/screens/mobile/settings_screen.dart' as mobile;
import 'package:vults/views/screens/mobile/splash_screen.dart' as mobile;
import 'package:vults/views/screens/mobile/landing_screen.dart' as mobile;
import 'package:vults/views/screens/mobile/login_screen.dart' as mobile;
import 'package:vults/views/screens/mobile/dashboard_screen.dart' as mobile;
import 'package:vults/views/screens/mobile/scan_screen.dart' as mobile;
import 'package:vults/views/screens/mobile/notification_screen.dart' as mobile;
import 'package:vults/views/screens/mobile/devices_screen.dart' as mobile;
import 'package:vults/views/screens/mobile/downloadpdf_screen.dart' as mobile;
import 'package:vults/views/screens/mobile/notificationsetting_screen.dart'
    as mobile;
import 'package:vults/views/screens/mobile/accountsettings_screen.dart'
    as mobile;

// Web Views.
import 'package:vults/views/screens/web/splash_screen.dart' as web;
import 'package:vults/views/screens/web/landing_screen.dart' as web;
import 'package:vults/views/screens/web/login_screen.dart' as web;
// import 'package:vults/views/screens/web/admin_dashboard.dart' as web;
import 'package:vults/views/screens/web/app.dart' as web;

// Firebase.
import 'package:firebase_core/firebase_core.dart';
import './firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => SettingsBloc()),
        BlocProvider(create: (context) => AccountSettingsBloc()),
        BlocProvider(create: (context) => TransactionBloc()),
        BlocProvider(create: (context) => DeviceBloc()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ConstantString.appName,
      debugShowCheckedModeBanner: false,
      routes: kIsWeb ? MobileRoutes.getRoutes() : WebRoutes.getRoutes(),
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
      '/scanqr': (BuildContext context) => const mobile.ScanScreen(),
      '/transaction':
          (BuildContext context) => BlocProvider(
            create: (context) => TransactionBloc(),
            child: const mobile.TransactionScreen(),
          ),
      // '/transaction':
      //     (BuildContext context) => const mobile.TransactionScreen(),
      '/notification':
          (BuildContext context) => const mobile.NotificationScreen(),
      '/settings':
          (BuildContext context) => BlocProvider.value(
            value: BlocProvider.of<SettingsBloc>(context),
            child: const mobile.SettingsScreen(),
          ),
      '/downloadpdf':
          (BuildContext context) => const mobile.DownloadPdfScreen(),
      '/accountsettings':
          (context) => BlocProvider(
            create: (context) => AccountSettingsBloc(),
            child: const mobile.AccountSettingsScreen(),
          ),

      '/devices':
          (BuildContext context) => BlocProvider.value(
            value: BlocProvider.of<DeviceBloc>(context),
            child: const mobile.DevicesScreen(),
          ),
      '/notificationsetting':
          (BuildContext context) => const mobile.NotificationSettingScreen(),
    };
  }
}

class WebRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return <String, WidgetBuilder>{
      '/': (BuildContext context) => const web.SplashScreen(),
      '/landing': (BuildContext context) => const web.LandingScreen(),
      '/login': (BuildContext context) => const web.LoginScreen(),
      '/webApp': (BuildContext context) => const web.AppContainer(),
      // '/dashboard': (BuildContext context) => const web.AdminDashboard(),
    };
  }
}
