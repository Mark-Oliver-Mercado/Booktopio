import 'package:flutter/material.dart';
import 'auth/signup.dart'; // Assuming this is your SignUpScreen
import 'auth/login.dart'; // Assuming this is your LoginScreen
import 'screens/home.dart'; // Assuming this is your HomePage
import 'screens/settings_screen.dart';
import 'screens/support_screen.dart'; // Renamed from customer_support_screen.dart in previous examples?
import 'screens/about_us_screen.dart';
import 'screens/feedback_screen.dart'; // Renamed from send_feedback_screen.dart in previous examples?
import 'screens/terms_conditions_screen.dart';
import 'screens/notification.dart'; // Corrected import for NotificationsScreen
import 'auth/forgot_password_screen.dart'; // Example for forgot password screen

// Additional imports for screens linked from settings that might not be in your main.dart yet
import 'screens/profile.dart'; // For 'Edit Profile'
import 'screens/change_password_screen.dart'; // For 'Change Password'
import 'screens/language_screen.dart'; // For 'Language'
import 'screens/privacy_policy_screen.dart'; // Assuming you have this screen for 'Privacy Policy'

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
        // Authentication routes
        '/signup': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/forgot_password_screen': (context) => const ForgotPasswordScreen(),

        // Main app routes
        '/': (context) =>
            HomePage(), // FIX: Removed 'const' keyword as HomePage likely needs a non-const constructor
        '/settings': (context) => const SettingsScreen(),

        // Routes linked from the Settings screen
        '/profile': (context) =>
            const ProfileScreen(), // Route for 'Edit Profile'
        '/change_password': (context) =>
            const ChangePasswordScreen(), // Route for 'Change Password'
        '/language': (context) =>
            const LanguageScreen(), // Route for 'Language'
        '/notifications': (context) =>
            const NotificationsScreen(), // Route for 'Notifications' (ensure correct class name)
        '/terms_conditions': (context) => const TermsConditionsScreen(),
        '/privacy_policy': (context) =>
            const PrivacyPolicyScreen(), // Route for 'Privacy Policy'
        '/support': (context) =>
            const SupportScreen(), // Route for 'Customer Support'
        '/feedback': (context) =>
            const FeedbackScreen(), // Route for 'Send Feedback'
        // Add other core routes like /roomlist, /bookingdetails, etc., if you have them
      },
    );
  }
}
