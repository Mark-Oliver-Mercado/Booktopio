// forgot_password_screen.dart
import 'package:flutter/material.dart';

// Define the main green color and its variations for consistency based on image_24f71b.png
const Color kPrimaryGreen = Color(0xFF73C088); // A refreshing mid-green
const Color kDarkGreen = Color(0xFF235D3A); // A darker shade for text/icons
const Color kButtonGreen = Color(0xFFA8E0B7); // A mid-light green for buttons

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(color: Colors.white), // Set title color to white
        ),
        backgroundColor:
            kPrimaryGreen, // Set app bar background to kPrimaryGreen
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white, // Set back icon color to white
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your email address below and we\'ll send you a link to reset your password.',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Email Address',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8.0),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'your.email@example.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 14.0,
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Send reset link logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      kButtonGreen, // Set button background to kButtonGreen
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Send Reset Link',
                  style: TextStyle(
                    color: kDarkGreen,
                    fontSize: 18.0,
                  ), // Set button text color to kDarkGreen
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
