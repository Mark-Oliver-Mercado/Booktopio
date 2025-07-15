// contact_us_screen.dart
import 'package:flutter/material.dart';

// Import the new screens for the drawer
// Define the main green color and its variations for consistency based on image_24f71b.png
const Color kPrimaryGreen = Color(0xFF73C088); // A refreshing mid-green
const Color kDarkGreen = Color(0xFF235D3A); // A darker shade for text/icons
const Color kLightGreen = Color(
  0xFFC8EAD1,
); // A very light green for backgrounds
const Color kAppBarTitleGreen = Color(
  0xFF397D54,
); // A darker green for high contrast titles
const Color kButtonGreen = Color(0xFFA8E0B7); // A mid-light green for buttons

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contact Us',
          style: TextStyle(
            color: Colors.white, // Changed to white
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kPrimaryGreen, // Main refreshing green for app bar
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white, // Changed to white
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
              'We\'re here to help! Choose an option below to get in touch with our support team.',
              style: TextStyle(fontSize: 16.0),
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

            const Text(
              'Your Message',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8.0),
            Container(
              height: 150.0,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Describe your issue or question here...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 32.0),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Send message logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryGreen, // Changed to kPrimaryGreen
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Send Message',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
      // The bottomNavigationBar has been removed from here
    );
  }

  Widget _buildContactOption(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Icon(icon, color: kDarkGreen), // Changed to kDarkGreen
          const SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
