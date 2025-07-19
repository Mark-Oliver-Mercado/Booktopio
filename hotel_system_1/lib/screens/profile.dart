// lib/screens/profile.dart
import 'package:flutter/material.dart';

// Corrected and updated color definitions based on the provided image palette
const Color kPrimaryBlue = Color(0xFF1E88E5); // A distinct blue for app bars and accents (from image)
const Color kDarkBlue = Color(0xFF1565C0); // A darker shade for text/icons (from image)
const Color kLightBlue = Color(0xFFE3F2FD); // A very light blue for backgrounds (from image)
const Color kWhite = Colors.white; // Pure white for elements
const Color kGreyText = Color(0xFF757575); // A medium grey for secondary text (from image/common practice)

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'My Profileadsas',
          style: TextStyle(
            color: kWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kPrimaryBlue, // Set app bar background to kPrimaryBlue
        elevation: 0,
      ),
      body: Container(
        color: kLightBlue, // Consistent light blue background
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/profile_placeholder.png'), // Placeholder image
                backgroundColor: kWhite, // Ensures white background for avatar if image is transparent
              ),
              const SizedBox(height: 20),
              const Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kDarkBlue, // Changed to kDarkBlue
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'johndoe@example.com',
                style: TextStyle(
                  fontSize: 16,
                  color: kGreyText, // Using kGreyText
                ),
              ),
              const SizedBox(height: 30),
              _buildProfileInfoRow(Icons.phone, 'Phone', '+63 912 345 6789'),
              _buildProfileInfoRow(Icons.location_on, 'Address', '123 Main St, Malvar, Batangas'),
              _buildProfileInfoRow(Icons.calendar_month, 'Member Since', 'January 2023'),
              const SizedBox(height: 30),
              // Add more profile details or options here
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit Profile button pressed!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryBlue, // Changed to kPrimaryBlue for button
                  foregroundColor: kWhite,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: kDarkBlue, size: 20), // Changed to kDarkBlue
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: kDarkBlue, // Changed to kDarkBlue
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: kGreyText, // Using kGreyText
            ),
          ),
        ],
      ),
    );
  }
}