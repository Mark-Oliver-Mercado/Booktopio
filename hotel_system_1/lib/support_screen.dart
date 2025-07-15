// support_screen.dart
import 'package:flutter/material.dart';

// Assuming these colors are defined in home.dart and accessible here,
// or you can define them directly in this file if home.dart is not imported.
import 'home.dart'; // Import home.dart to access the color constants

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Support',
          style: TextStyle(
            color: Colors.white,
          ), // Set app bar title color to white
        ),
        backgroundColor:
            kPrimaryGreen, // Set app bar background color to kPrimaryGreen
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ), // Set back icon color to white
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
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search support articles...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // Common Topics
            const Text(
              'Common Topics',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            _buildTopicItem(context, 'Troubleshooting', Icons.build_outlined),
            _buildTopicItem(context, 'Account & Profile', Icons.person_outline),
            _buildTopicItem(context, 'Booking & Payments', Icons.book_outlined),
            const SizedBox(height: 32.0),

            // Contact Us
            const Text(
              'Contact Us',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            _buildContactButton(
              context,
              'Email Support',
              Icons.email_outlined,
              kPrimaryGreen, // Use kPrimaryGreen for button color
            ),
            const SizedBox(height: 12.0),
            _buildContactButton(
              context,
              'Live Chat',
              Icons.chat_bubble_outline,
              kPrimaryGreen, // Use kPrimaryGreen for button color
            ),
            const SizedBox(height: 12.0),
            _buildContactButton(
              context,
              'Call Us',
              Icons.call_outlined,
              kPrimaryGreen, // Use kPrimaryGreen for button color
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
          leading: Icon(
            icon,
            color: kDarkGreen,
          ), // Set topic item icon color to kDarkGreen
          title: Text(title),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16.0,
            color: kDarkGreen,
          ), // Set trailing icon color to kDarkGreen
          onTap: () {
            // Handle navigation for each topic
          },
        ),
        const Divider(height: 1.0),
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
          // Handle button press
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
