import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Mapbox
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'config/mapbox_token.dart';

// Screens
import 'screens/welcome_screen.dart';
import 'screens/user_login.dart';
import 'screens/admin_login.dart';
import 'screens/signup_screen.dart';
import 'screens/user/home_screen.dart';
import 'screens/admin/admin_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Mapbox Access Token
  MapboxOptions.setAccessToken(MapBoxConfig.accessToken);

  runApp(const SmartBinApp());
}

class SmartBinApp extends StatelessWidget {
  const SmartBinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartBin',
      debugShowCheckedModeBanner: false,

      home: const WelcomeScreen(),

      routes: {
        '/login_user': (_) => const UserLoginScreen(),
        '/login_admin': (_) => const AdminLoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/user_dashboard': (_) => const UserHome(),
        '/admin_dashboard': (_) => const AdminDashboard(),
      },
    );
  }
}
