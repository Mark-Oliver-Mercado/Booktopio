import 'package:flutter/material.dart';
// Corrected import to use a relative path instead of 'package:'
import 'contact_us_screen.dart';

// Define color constants directly in this file for self-containment
const Color kPrimaryBlue = Color(
  0xFF1E88E5,
); // A distinct blue for app bars and accents
const Color kDarkBlue = Color(0xFF1565C0); // A darker shade for text/icons
const Color kLightBlue = Color(0xFFE3F2FD); // A very light blue for backgrounds
const Color kWhite = Colors.white; // Pure white for elements
const Color kGreyText = Color(0xFF757575); // A medium grey for secondary text

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBlue,
      appBar: AppBar(
        title: const Text('Support', style: TextStyle(color: Colors.white)),
        backgroundColor: kPrimaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search support articles...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: kDarkBlue),
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // Common Topics
            Text(
              'Common Topics',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: kDarkBlue,
              ),
            ),
            _buildTopicItem(context, 'Troubleshooting', Icons.build_outlined),
            _buildTopicItem(context, 'Account & Profile', Icons.person_outline),
            _buildTopicItem(context, 'Booking & Payments', Icons.book_outlined),
            const SizedBox(height: 32.0),

            // Contact Us
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: kDarkBlue,
              ),
            ),
            const SizedBox(height: 16.0),
            _buildContactButton(
              context,
              'Email Support',
              Icons.email_outlined,
              kPrimaryBlue,
            ),
            const SizedBox(height: 12.0),
            _buildContactButton(
              context,
              'Live Chat',
              Icons.chat_bubble_outline,
              kPrimaryBlue,
            ),
            const SizedBox(height: 12.0),
            _buildContactButton(
              context,
              'Call Us',
              Icons.call_outlined,
              kPrimaryBlue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicItem(BuildContext context, String title, IconData icon) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: kDarkBlue),
          title: Text(title, style: TextStyle(color: kDarkBlue)),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16.0,
            color: kDarkBlue,
          ),
          onTap: () {
            // Handle navigation for each topic
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Navigating to $title topic...')),
            );
          },
        ),
        const Divider(height: 1.0, color: Colors.grey),
      ],
    );
  }

  Widget _buildContactButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // Navigate to ContactUsScreen when any of these buttons are pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ContactUsScreen()),
          );
        },
        icon: Icon(icon, color: Colors.white),
        label: Text(text, style: const TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
