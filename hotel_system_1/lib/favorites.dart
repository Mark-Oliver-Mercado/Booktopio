// favorites.dart
import 'package:flutter/material.dart';
import 'home.dart'; // Import home.dart to access its color constants

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGreen, // Set background to kLightGreen
      appBar: AppBar(
        title: const Text(
          'My Favorites',
          style: TextStyle(
            color: Colors.white, // Changed to white
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kPrimaryGreen, // Changed to kPrimaryGreen
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite_border,
              size: 80,
              color:
                  kDarkGreen, // Changed to kDarkGreen to match BookingsScreen
            ),
            const SizedBox(height: 20),
            const Text(
              'No favorite hotels added yet.',
              style: TextStyle(
                fontSize: 18,
                color:
                    kDarkGreen, // Changed to kDarkGreen to match BookingsScreen
              ),
            ),
            const Text(
              'Tap the heart icon on hotel listings to add them here!',
              style: TextStyle(
                fontSize: 14,
                color: Colors
                    .grey, // Changed to Colors.grey to match BookingsScreen
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
