// about_us_screen.dart
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBlue, // Set background color to kLightBlue
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(
            color: kWhite, // Text color to white
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kPrimaryBlue, // AppBar background to kPrimaryBlue
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: kWhite, // Icon color to white
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
              'Our Story',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: kDarkBlue, // Text color to kDarkBlue
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              'Welcome to Booktopia! We are passionate about making travel easy and enjoyable. Founded with the goal of simplifying hotel reservations, our platform connects you with a wide array of accommodations across the globe. From luxurious stays to cozy boutique hotels, we strive to provide an intuitive and efficient booking experience, ensuring you find the perfect place for every trip.',
              style: TextStyle(
                fontSize: 15.0, // Adjusted font size for consistency
                color: kGreyText, // Text color to kGreyText
              ),
            ),
            const SizedBox(height: 24.0),

            const Text(
              'Our Mission',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: kDarkBlue, // Text color to kDarkBlue
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              'Our mission is to empower travelers by offering a reliable, user-friendly, and comprehensive hotel booking solution. We are dedicated to providing competitive prices, a diverse selection of properties, and exceptional customer support. Our aim is to make your journey from searching for a hotel to checking in as smooth and enjoyable as possible, every step of the way.',
              style: TextStyle(
                fontSize: 15.0, // Adjusted font size for consistency
                color: kGreyText, // Text color to kGreyText
              ),
            ),
            const SizedBox(height: 32.0),

            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: kDarkBlue, // Text color to kDarkBlue
              ),
            ),
            const SizedBox(height: 16.0),
            _buildContactInfoRow(
              Icons.email_outlined,
              'support@booktopia.com',
            ), // Updated email
            const SizedBox(height: 12.0),
            _buildContactInfoRow(
              Icons.call_outlined,
              '+1 (800) 123-4567',
            ), // Example phone
            const SizedBox(height: 12.0),
            _buildContactInfoRow(
              Icons.location_on_outlined,
              '123 Main St, San Pablo City, Laguna, Philippines', // Updated address
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
          color: kDarkBlue, // Changed icon color to kDarkBlue
        ),
        const SizedBox(width: 12.0),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16.0,
            color: kGreyText, // Text color to kGreyText
          ),
        ),
      ],
    );
  }
}
