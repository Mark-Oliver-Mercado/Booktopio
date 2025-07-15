// bookings.dart
import 'package:flutter/material.dart';

// Assuming these color constants are available globally or passed
// For this snippet, I'll define them here based on your home.dart
const Color kPrimaryGreen = Color(0xFF73C088); // A refreshing mid-green
const Color kDarkGreen = Color(0xFF235D3A); // A darker shade for text/icons
const Color kLightGreen = Color(
  0xFFC8EAD1,
); // A very light green for backgrounds

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(
            color: Colors.white, // Changed to white
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kPrimaryGreen, // Changed to kPrimaryGreen
        elevation: 0,
      ),
      body: Container(
        // Wrap with Container to apply background color
        color: kLightGreen, // Set body background to kLightGreen
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long,
                size: 80,
                color: kDarkGreen,
              ), // Changed to kDarkGreen
              SizedBox(height: 20),
              Text(
                'You have no upcoming bookings.',
                style: TextStyle(
                  fontSize: 18,
                  color: kDarkGreen,
                ), // Changed to kDarkGreen
              ),
              Text(
                'Start exploring hotels to plan your next trip!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ), // Kept grey, as per the other file's secondary text
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
