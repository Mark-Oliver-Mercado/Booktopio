// forgot_password_screen.dart
import 'package:flutter/material.dart';

// Define the blue color scheme based on the new login screen image (image_20bf2c.png)
const Color kPrimaryBlue = Color(0xFF1A73E8); // A strong, vibrant blue for main elements
const Color kDarkBlueText = Color(0xFF202124); // Dark text color for headings/labels
const Color kLightBlue = Color(0xFFE6F2FF); // Very light blue background
const Color kCardBackgroundColor = Colors.white; // White for the card background
const Color kHintTextColor = Color(0xFF80868B); // Greyish color for hint text
const Color kBorderColor = Color(0xFFDADCE0); // Light grey for borders

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBlue, // Set scaffold background to light blue
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0, // No shadow
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: kDarkBlueText, // Dark blue for back icon
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView( // Use SingleChildScrollView to prevent overflow on small screens
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
          children: [
            // Booktopia Prestige Logo (Placeholder)
            const SizedBox(height: 20.0),
            Image.asset(
              'assets/booktopia_logo.png', // Replace with your actual logo asset path
              height: 60,
              errorBuilder: (context, error, stackTrace) {
                return const Text(
                  'BOOKTOPIA PRESTIGE', // Fallback text if logo not found
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kDarkBlueText,
                  ),
                );
              },
            ),
            const SizedBox(height: 40.0),

            // Main Title
            const Text(
              'Forgot Password', // Changed from 'Lima Hotel' to 'Forgot Password'
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: kDarkBlueText,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Enter your email address to receive a reset link.', // Updated descriptive text
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color: kHintTextColor, // Lighter text color
              ),
            ),
            const SizedBox(height: 40.0),

            // Card containing the input field and button
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: kCardBackgroundColor, // White card background
                borderRadius: BorderRadius.circular(16.0), // Rounded card corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email Address',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: kDarkBlueText,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'your.email@example.com',
                      hintStyle: TextStyle(color: kHintTextColor),
                      prefixIcon: const Icon(Icons.email_outlined, color: kHintTextColor), // Email icon
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: kBorderColor, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: kBorderColor, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: kPrimaryBlue, width: 2.0),
                      ),
                      filled: true,
                      fillColor: Colors.white, // Input field background white
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 14.0,
                      ),
                    ),
                    style: const TextStyle(color: kDarkBlueText),
                  ),
                  const SizedBox(height: 32.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton( // Changed back to ElevatedButton (no icon in reference)
                      onPressed: () {
                        // Send reset link logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password reset link sent!'),
                            backgroundColor: kPrimaryBlue,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryBlue, // Solid primary blue
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0), // Rounded corners
                        ),
                        elevation: 0, // No shadow for this button style
                      ),
                      child: const Text(
                        'Send Reset Link',
                        style: TextStyle(
                          color: Colors.white, // White text
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
