// contact_us_screen.dart
import 'package:flutter/material.dart';

// Updated color definitions based on the consistent blue/white palette
const Color kPrimaryBlue = Color(0xFF1E88E5); // A distinct blue for app bars and accents
const Color kDarkBlue = Color(0xFF1565C0); // A darker shade for text/icons
const Color kLightBlue = Color(0xFFE3F2FD); // A very light blue for backgrounds
const Color kWhite = Colors.white; // Pure white for elements
const Color kGreyText = Color(0xFF757575); // A medium grey for secondary text

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBlue, // Changed to kLightBlue
      appBar: AppBar(
        title: const Text(
          'Contact Us',
          style: TextStyle(
            color: kWhite, // Changed to kWhite
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kPrimaryBlue, // Changed to kPrimaryBlue
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: kWhite, // Changed to kWhite
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
            Text( // Changed to Text widget to allow style property
              'We\'re here to help! Choose an option below to get in touch with our support team.',
              style: TextStyle(fontSize: 16.0, color: kGreyText), // Changed text color to kGreyText
            ),
            const SizedBox(height: 24.0),

            _buildContactOption(
              context,
              Icons.email_outlined,
              'Email Support',
              'support@example.com',
            ),
            const SizedBox(height: 16.0),
            _buildContactOption(
              context,
              Icons.call_outlined,
              'Call Us',
              '+1 (800) 123-4567',
            ),
            const SizedBox(height: 16.0),
            _buildContactOption(
              context,
              Icons.help_outline,
              'Help Center',
              'Find answers to common questions',
            ),
            const SizedBox(height: 32.0),

            Text( // Changed to Text widget to allow style property
              'Your Message',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: kDarkBlue), // Changed text color to kDarkBlue
            ),
            const SizedBox(height: 8.0),
            Container(
              height: 150.0,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: kWhite, // Changed from Colors.grey[200] to kWhite
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: kLightBlue), // Added a subtle border for definition
              ),
              child: TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Describe your issue or question here...',
                  hintStyle: TextStyle(color: kGreyText.withValues(alpha: 0.7)), // Changed hint color
                  border: InputBorder.none,
                ),
                style: TextStyle(color: kDarkBlue), // Changed input text color to kDarkBlue
              ),
            ),
            const SizedBox(height: 32.0),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Send message logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Message sent! (Placeholder)')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryBlue, // Changed to kPrimaryBlue
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Send Message',
                  style: TextStyle(color: kWhite, fontSize: 18.0, fontWeight: FontWeight.bold), // Changed to kWhite
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Card( // Wrapped in Card for consistent styling
      elevation: 3, // Added elevation for card effect
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Rounded corners for card
      color: kWhite, // Card background white
      child: InkWell( // Added InkWell for tap feedback
        onTap: () {
          // Placeholder for actual navigation/action
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title tapped!')),
          );
        },
        borderRadius: BorderRadius.circular(12), // Match card border radius
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Icon(icon, color: kPrimaryBlue, size: 30.0), // Changed to kPrimaryBlue, increased size for prominence
              const SizedBox(width: 16.0),
              Expanded( // Added Expanded to prevent overflow
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: kDarkBlue, // Changed to kDarkBlue
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 14.0, color: kGreyText), // Changed to kGreyText
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: kGreyText), // Added arrow icon, changed color
            ],
          ),
        ),
      ),
    );
  }
}