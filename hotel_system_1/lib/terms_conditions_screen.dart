// terms_conditions_screen.dart
import 'package:flutter/material.dart';

// Define the main green color and its variations for consistency based on home.dart
const Color kPrimaryGreen = Color(0xFF73C088); // A refreshing mid-green
const Color kDarkGreen = Color(0xFF235D3A); // A darker shade for text/icons
const Color kLightGreen = Color(
  0xFFC8EAD1,
); // A very light green for backgrounds
const Color kAppBarTitleGreen = Color(
  0xFF397D54,
); // A darker green for high contrast titles
const Color kButtonGreen = Color(0xFFA8E0B7); // A mid-light green for buttons

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGreen, // Set background color to kLightGreen
      appBar: AppBar(
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(
            color: Colors.white, // Text color to white
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kPrimaryGreen, // AppBar background to kPrimaryGreen
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white, // Icon color to white
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hotelio Terms & Conditions',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: kDarkGreen, // Text color to kDarkGreen
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Welcome to Hotelio! These Terms & Conditions ("Terms") govern your access to and use of the Hotelio website, mobile applications, and services (collectively, the "Service"). By accessing or using the Service, you agree to be bound by these Terms and our Privacy Policy. If you do not agree to these Terms, please do not use the Service.',
              style: TextStyle(
                fontSize: 14.0,
                color: kDarkGreen, // Text color to kDarkGreen
              ),
            ),
            const SizedBox(height: 24.0),

            _buildSectionHeader('1. Acceptance of Terms'),
            const SizedBox(height: 8.0),
            const Text(
              'By creating an account, making a booking, or otherwise using the Service, you acknowledge that you have read, understood, and agree to be bound by these Terms, as well as any additional terms and conditions that are referenced herein or that may apply to specific features of the Service.',
              style: TextStyle(
                fontSize: 14.0,
                color: kDarkGreen, // Text color to kDarkGreen
              ),
            ),
            const SizedBox(height: 24.0),

            _buildSectionHeader('2. Changes to Terms'),
            const SizedBox(height: 8.0),
            const Text(
              'Hotelio reserves the right to modify or update these Terms at any time. We will notify you of any material changes by posting the new Terms on the Service or by other means. Your continued use of the Service after such modifications will constitute your acknowledgment of the modified Terms and agreement to abide by and be bound by them.',
              style: TextStyle(
                fontSize: 14.0,
                color: kDarkGreen, // Text color to kDarkGreen
              ),
            ),
            const SizedBox(height: 24.0),

            _buildSectionHeader('3. User Accounts'),
            const SizedBox(height: 8.0),
            const Text(
              'To access certain features of the Service, you may be required to create an account. You agree to provide accurate, current, and complete information during the registration process and to update such information to keep it accurate, current, and complete. You are responsible for maintaining the confidentiality of your account password and for all activities that occur under your account. You agree to notify Hotelio immediately of any unauthorized use of your account.',
              style: TextStyle(
                fontSize: 14.0,
                color: kDarkGreen, // Text color to kDarkGreen
              ),
            ),
            // Add more sections as needed based on the full terms and conditions
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: kDarkGreen, // Section header color to kDarkGreen
      ),
    );
  }
}
