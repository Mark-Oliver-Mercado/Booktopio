// lib/main.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Authentication Screens ---
import 'auth/signup.dart';
import 'auth/login.dart';
import 'auth/forgot_password_screen.dart';

// --- Main App Screens ---
import 'screens/home.dart';
import 'screens/admin.dart'; // Import for AdminDashboard
import 'screens/settings_screen.dart';
import 'screens/notification.dart'; // Corrected import for NotificationsScreen

// --- Settings Sub-Screens ---
import 'screens/profile.dart';
import 'screens/change_password_screen.dart';
import 'screens/language_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/support_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/terms_conditions_screen.dart';


// THIS IS YOUR MAIN ENTRY POINT
void main() async { // Ensure 'void main() async' is at the top level
  WidgetsFlutterBinding.ensureInitialized(); // Required for SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final String? loggedInUserRole = prefs.getString('loggedInUserRole'); // Get stored role

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    initialUserRole: loggedInUserRole,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? initialUserRole;

  const MyApp({
    super.key,
    required this.isLoggedIn,
    this.initialUserRole,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hotel Booking App',
      theme: ThemeData(primarySwatch: Colors.brown),

      initialRoute: '/signup',

      routes: {
        '/signup': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/forgot_password_screen': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const HomePage(),
        '/admin': (context) => AdminDashboard(), // Removed 'const' here
        '/settings': (context) => const SettingsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/change_password': (context) => const ChangePasswordScreen(),
        '/language': (context) => const LanguageScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/terms_conditions': (context) => const TermsConditionsScreen(),
        '/privacy_policy': (context) => const PrivacyPolicyScreen(),
        '/support': (context) => const SupportScreen(),
        '/feedback': (context) => const FeedbackScreen(),
      },
    );
  }
}