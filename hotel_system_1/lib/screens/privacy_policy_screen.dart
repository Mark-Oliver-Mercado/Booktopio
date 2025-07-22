import 'package:flutter/material.dart';
import '../utils/constants.dart';


class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBlue, // Set background color to kLightBlue
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
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
              'Your Privacy is Important to Us', // Main title
              style: TextStyle(
                fontSize: 24.0, // Slightly larger for main title
                fontWeight: FontWeight.bold,
                color: kDarkBlue, // Text color to kDarkBlue
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'This Privacy Policy describes how your personal information is collected, used, and shared when you visit or make a booking through our Hotel Booking Reservation System.',
              style: TextStyle(
                fontSize: 15.0, // Slightly larger for readability
                color: kGreyText, // Text color to kGreyText
              ),
            ),
            const SizedBox(height: 24.0), // Consistent spacing

            _buildSectionHeader('1. What information do we collect?'),
            const SizedBox(height: 8.0),
            Text(
              'We collect personal information such as your name, email address, phone number, payment details, and booking preferences when you use our service.',
              style: TextStyle(fontSize: 15.0, color: kGreyText),
            ),
            const SizedBox(height: 24.0), // Consistent spacing

            _buildSectionHeader('2. How do we use your information?'),
            const SizedBox(height: 8.0),
            Text(
              'We use your information to process your bookings, communicate with you about your reservations, provide customer support, and improve our services.',
              style: TextStyle(fontSize: 15.0, color: kGreyText),
            ),
            const SizedBox(height: 24.0), // Consistent spacing

            _buildSectionHeader('3. Sharing Your Personal Information'),
            const SizedBox(height: 8.0),
            Text(
              'We do not share your personal information with third parties except as necessary to complete your booking (e.g., with hotels), to comply with legal obligations, or with your explicit consent. We may share aggregated or anonymized data for analytical purposes.',
              style: TextStyle(fontSize: 15.0, color: kGreyText),
            ),
            const SizedBox(height: 24.0),

            _buildSectionHeader('4. Data Security'),
            const SizedBox(height: 8.0),
            Text(
              'We implement a variety of security measures to maintain the safety of your personal information when you place an order or enter, submit, or access your personal information. These measures include data encryption and secure server infrastructure.',
              style: TextStyle(fontSize: 15.0, color: kGreyText),
            ),
            const SizedBox(height: 24.0),

            _buildSectionHeader('5. Your Rights'),
            const SizedBox(height: 8.0),
            Text(
              'You have the right to access, correct, or delete your personal information. You may also have the right to restrict or object to certain processing of your data. Please contact us to exercise these rights.',
              style: TextStyle(fontSize: 15.0, color: kGreyText),
            ),
            const SizedBox(height: 24.0),

            _buildSectionHeader('6. Cookies'),
            const SizedBox(height: 8.0),
            Text(
              'Our website uses "cookies" to enhance user experience. Your web browser places cookies on your hard drive for record-keeping purposes and sometimes to track information about them. You may choose to set your web browser to refuse cookies, or to alert you when cookies are being sent.',
              style: TextStyle(fontSize: 15.0, color: kGreyText),
            ),
            const SizedBox(height: 24.0),

            _buildSectionHeader('7. Changes to This Privacy Policy'),
            const SizedBox(height: 8.0),
            Text(
              'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes.',
              style: TextStyle(fontSize: 15.0, color: kGreyText),
            ),
            const SizedBox(height: 24.0),

            _buildSectionHeader('8. Contact Us'),
            const SizedBox(height: 8.0),
            Text(
              'If you have any questions about this Privacy Policy, please contact us at privacy@hotelbookingapp.com.',
              style: TextStyle(fontSize: 15.0, color: kGreyText),
            ),
            const SizedBox(height: 24.0), // Extra space at the bottom
          ],
        ),
      ),
    );
  }

  // Helper function to build consistent section headers
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18.0, // Slightly larger for section headers
        fontWeight: FontWeight.bold,
        color: kDarkBlue, // Section header color to kDarkBlue
      ),
    );
  }
}
