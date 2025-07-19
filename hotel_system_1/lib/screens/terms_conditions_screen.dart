// lib/screens/terms_conditions_screen.dart
import 'package:flutter/material.dart';

// Updated color definitions based on the consistent blue/white palette
const Color kPrimaryBlue = Color(0xFF1E88E5); // A distinct blue for app bars and accents
const Color kDarkBlue = Color(0xFF1565C0); // A darker shade for text/icons
const Color kLightBlue = Color(0xFFE3F2FD); // A very light blue for backgrounds
const Color kWhite = Colors.white; // Pure white for elements
const Color kGreyText = Color(0xFF757575); // A medium grey for secondary text

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBlue, // Set background color to kLightBlue
      appBar: AppBar(
        title: const Text(
          'Terms & Conditions',
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
              'Hotelio Terms & Conditions',
              style: TextStyle(
                fontSize: 24.0, // Slightly larger for main title
                fontWeight: FontWeight.bold,
                color: kDarkBlue, // Text color to kDarkBlue
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Welcome to Hotelio! These Terms & Conditions ("Terms") govern your access to and use of the Hotelio website, mobile applications, and services (collectively, the "Service"). By accessing or using the Service, you agree to be bound by these Terms and our Privacy Policy. If you do not agree to these Terms, please do not use the Service.',
              style: TextStyle(
                fontSize: 15.0, // Slightly larger for readability
                color: kGreyText, // Text color to kGreyText
              ),
            ),
            const SizedBox(height: 24.0),

            _buildSectionHeader('1. Acceptance of Terms'),
            const SizedBox(height: 8.0),
            Text(
              'By creating an account, making a booking, or otherwise using the Service, you acknowledge that you have read, understood, and agree to be bound by these Terms, as well as any additional terms and conditions that are referenced herein or that may apply to specific features of the Service. Your continued use of the Service constitutes your acceptance of these Terms.',
              style: TextStyle(
                fontSize: 15.0,
                color: kGreyText, // Text color to kGreyText
              ),
            ),
            const SizedBox(height: 24.0),

            _buildSectionHeader('2. Changes to Terms'),
            const SizedBox(height: 8.0),
            Text(
              'Hotelio reserves the right to modify or update these Terms at any time. We will notify you of any material changes by posting the new Terms on the Service or by other reasonable means. Your continued use of the Service after such modifications will constitute your acknowledgment of the modified Terms and agreement to abide by and be bound by them. We encourage you to review these Terms periodically.',
              style: TextStyle(
                fontSize: 15.0,
                color: kGreyText, // Text color to kGreyText
              ),
            ),
            const SizedBox(height: 24.0),

            _buildSectionHeader('3. User Accounts'),
            const SizedBox(height: 8.0),
            Text(
              'To access certain features of the Service, you may be required to create an account. You agree to provide accurate, current, and complete information during the registration process and to update such information to keep it accurate, current, and complete. You are solely responsible for maintaining the confidentiality of your account password and for all activities that occur under your account. You agree to notify Hotelio immediately of any unauthorized use of your account or any other breach of security.',
              style: TextStyle(
                fontSize: 15.0,
                color: kGreyText, // Text color to kGreyText
              ),
            ),
            const SizedBox(height: 24.0),

            _buildSectionHeader('4. Booking and Payment'),
            const SizedBox(height: 8.0),
            Text(
              'All bookings made through the Service are subject to the hotel\'s terms and conditions, including cancellation policies. You agree to pay all charges incurred by you or on your behalf through the Service, at the prices in effect when such charges are incurred. You are responsible for any applicable taxes. All payments are processed securely through our third-party payment gateway. Hotelio is not responsible for any issues arising from payment processing.',
              style: TextStyle(
                fontSize: 15.0,
                color: kGreyText,
              ),
            ),
            const SizedBox(height: 24.0),

            _buildSectionHeader('5. User Conduct'),
            const SizedBox(height: 8.0),
            Text(
              'You agree to use the Service only for lawful purposes and in a way that does not infringe the rights of, restrict or inhibit anyone else\'s use and enjoyment of the Service. Prohibited behavior includes harassing or causing distress or inconvenience to any other user, transmitting obscene or offensive content, or disrupting the normal flow of dialogue within the Service. You must not use the Service to conduct any fraudulent or illegal activities.',
              style: TextStyle(
                fontSize: 15.0,
                color: kGreyText,
              ),
            ),
            const SizedBox(height: 24.0),

            _buildSectionHeader('6. Intellectual Property'),
            const SizedBox(height: 8.0),
            Text(
              'All content on the Service, including text, graphics, logos, images, and software, is the property of Hotelio or its content suppliers and is protected by international copyright laws. You may not reproduce, distribute, modify, create derivative works of, publicly display, publicly perform, republish, download, store, or transmit any of the material on our Service, except as generally permitted by standard web browsing functionality.',
              style: TextStyle(
                fontSize: 15.0,
                color: kGreyText,
              ),
            ),
            const SizedBox(height: 24.0),

            _buildSectionHeader('7. Disclaimer of Warranties'),
            const SizedBox(height: 8.0),
            Text(
              'The Service is provided on an "as is" and "as available" basis, without any warranties of any kind, either express or implied, including, but not limited to, implied warranties of merchantability, fitness for a particular purpose, or non-infringement. Hotelio does not warrant that the Service will be uninterrupted, secure, or error-free, or that defects will be corrected.',
              style: TextStyle(
                fontSize: 15.0,
                color: kGreyText,
              ),
            ),
            const SizedBox(height: 24.0),

            _buildSectionHeader('8. Limitation of Liability'),
            const SizedBox(height: 8.0),
            Text(
              'In no event shall Hotelio, its affiliates, or their licensors, service providers, employees, agents, officers, or directors be liable for damages of any kind, under any legal theory, arising out of or in connection with your use, or inability to use, the Service, any websites linked to it, any content on the Service or such other websites, including any direct, indirect, special, incidental, consequential, or punitive damages, including but not limited to, personal injury, pain and suffering, emotional distress, loss of revenue, loss of profits, loss of business or anticipated savings, loss of use, loss of goodwill, loss of data, and whether caused by tort (including negligence), breach of contract, or otherwise, even if foreseeable.',
              style: TextStyle(
                fontSize: 15.0,
                color: kGreyText,
              ),
            ),
            const SizedBox(height: 24.0),

            _buildSectionHeader('9. Governing Law'),
            const SizedBox(height: 8.0),
            Text(
              'These Terms shall be governed by and construed in accordance with the laws of the Philippines, without regard to its conflict of law principles. Any legal action or proceeding arising under these Terms will be brought exclusively in the courts located in the Philippines, and you hereby consent to the personal jurisdiction and venue therein.',
              style: TextStyle(
                fontSize: 15.0,
                color: kGreyText,
              ),
            ),
            const SizedBox(height: 24.0),

            _buildSectionHeader('10. Contact Information'),
            const SizedBox(height: 8.0),
            Text(
              'If you have any questions about these Terms, please contact us at support@hotelio.com.',
              style: TextStyle(
                fontSize: 15.0,
                color: kGreyText,
              ),
            ),
            const SizedBox(height: 24.0), // Extra space at the bottom
          ],
        ),
      ),
    );
  }

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