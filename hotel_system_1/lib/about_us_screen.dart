// about_us_screen.dart
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(
            color: Color(0xFF5D4037), // Matches profile.dart title color
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(
          0xFFFFCCBC,
        ), // Matches profile.dart app bar color
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF5D4037),
          ), // Match leading icon color
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
              'Our Story',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12.0),
            const Text(
              'Welcome to our hotel booking app, your ultimate companion for seamless travel planning. Founded with a vision to simplify hotel reservations, we connect you with a vast network of accommodations worldwide, from luxurious resorts to cozy boutique hotels. Our platform is designed to offer an intuitive and efficient booking experience, ensuring you find the perfect stay every time.',
              style: TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 24.0),

            const Text(
              'Our Mission',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12.0),
            const Text(
              'Our mission is to empower travelers by providing a reliable, user-friendly, and comprehensive hotel booking solution. We are committed to offering competitive prices, a diverse selection of properties, and exceptional customer support, making your journey from search to check-in as smooth and enjoyable as possible.',
              style: TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 32.0),

            const Text(
              'Contact Us',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            _buildContactInfoRow(Icons.email_outlined, 'support@hotelapp.com'),
            const SizedBox(height: 12.0),
            _buildContactInfoRow(Icons.call_outlined, '+1 (800) 123-4567'),
            const SizedBox(height: 12.0),
            _buildContactInfoRow(
              Icons.location_on_outlined,
              '123 Hotel St, Travel City, TC 98765',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF5D4037),
        ), // Changed from Colors.teal to match profile.dart icons
        const SizedBox(width: 12.0),
        Text(text, style: const TextStyle(fontSize: 16.0)),
      ],
    );
  }
}
