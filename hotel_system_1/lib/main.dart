// main.dart excerpt
import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart'; // Assuming you have a login screen
//import 'settings_screen.dart';//
import 'support_screen.dart';
import 'about_us_screen.dart';
import 'feedback_screen.dart';
import 'terms_conditions_screen.dart';
import 'notification_screen.dart'; // Make sure this is also imported if used elsewhere

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
      initialRoute: '/', // Or '/login' if you want to start there
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) =>
            const LoginScreen(), // Replace with your actual Login page
        //'/settings': (context) => const SettingsScreen(),
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
