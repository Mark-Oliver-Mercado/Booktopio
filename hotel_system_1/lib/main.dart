import 'package:flutter/material.dart';
import 'auth/signup.dart'; // Assuming this is your SignUpScreen
import 'auth/login.dart'; // Assuming this is your LoginScreen
import 'screens/home.dart'; // Assuming this is your HomePage
import 'screens/settings_screen.dart';//
import 'screens/support_screen.dart';
import 'screens/about_us_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/terms_conditions_screen.dart';
import 'screens/notification_screen.dart'; // Make sure this is also imported if used 
import '../auth/forgot_password_screen.dart'; // Example for forgot password screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hotel Booking App',
      theme: ThemeData(primarySwatch: Colors.brown),
      // Set initial route to signup screen
      initialRoute: '/signup',
      routes: {
        // Define the signup route
        '/signup': (context) => const SignUpScreen(),
        // Define the login route
        '/login': (context) => const LoginScreen(),
        '/forgot_password_screen': (context) => const ForgotPasswordScreen(), // Example for forgot password screen
        // Define the home route
        // FIX: Ensure HomePage is not const here because it uses a GlobalKey
        '/': (context) => HomePage(),
        '/settings': (context) => const SettingsScreen(),
        '/support': (context) => const SupportScreen(),
        '/about_us': (context) => const AboutUsScreen(),
        '/feedback': (context) => const FeedbackScreen(),
        '/terms_conditions': (context) => const TermsConditionsScreen(),
        '/notifications': (context) =>
            const NotificationsScreen(), // For notifications from profile
        // Add other routes like /roomlist, etc.
      },
    );
  }
}