import 'package:flutter/material.dart';

// Import the color constants from home.dart
import 'home.dart'; // Make sure home.dart is in the same directory or accessible via path

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBlue, // Changed to light blue background
      appBar: AppBar(
        title: const Text(
          'Feedback',
          style: TextStyle(color: Colors.white), // White title text
        ),
        backgroundColor:
            kPrimaryBlue, // Use kPrimaryBlue for AppBar background
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white, // White back icon
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
            // Leave a Review Section
            Text(
              'Leave a Review',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: kDarkBlue), // Changed to dark blue
            ),
            const SizedBox(height: 16.0),
            Text(
              'Hotel/Room',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: kDarkBlue), // Changed to dark blue
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white, // Changed to white background
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey.shade300), // Added a subtle border
              ),
              child: const Text(
                'Grand Hyatt',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            const SizedBox(height: 24.0),

            // Your Rating
            Text(
              'Your Rating',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: kDarkBlue), // Changed to dark blue
            ),
            const SizedBox(height: 8.0),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < 3
                      ? Icons.star
                      : Icons.star_border, // Example: 3 filled stars
                  color: Colors.orange, // Keeping orange for star rating
                  size: 32.0,
                );
              }),
            ),
            const SizedBox(height: 24.0),

            // Your Review
            Text(
              'Your Review',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: kDarkBlue), // Changed to dark blue
            ),
            const SizedBox(height: 8.0),
            Container(
              height: 120.0,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white, // Changed to white background
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey.shade300), // Added a subtle border
              ),
              child: const TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Share your experience...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Submit review
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      kPrimaryBlue, // Use kPrimaryBlue for the button
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Submit Review',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
            ),
            const SizedBox(height: 32.0),

            // Recent Reviews Section
            Text(
              'Recent Reviews',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: kDarkBlue), // Changed to dark blue
            ),
            const SizedBox(height: 16.0),
            _buildReviewCard(
              context,
              'Alice Johnson',
              4, // 4 stars
              'Fantastic stay! The room was clean, spacious, and had a great view. Staff were incredibly friendly and helpful. Highly recommend!',
              'October 25, 2023',
              'https://via.placeholder.com/150/FF5733/FFFFFF?text=A', // Placeholder for avatar
            ),
            const SizedBox(height: 16.0),
            _buildReviewCard(
              context,
              'Bob Williams',
              3, // 3 stars
              'Good location, but the breakfast was a bit underwhelming. Room was comfortable enough for a short business trip.',
              'October 20, 2023',
              'https://via.placeholder.com/150/33A3FF/FFFFFF?text=B', // Placeholder for avatar
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(
    BuildContext context,
    String name,
    int rating,
    String reviewText,
    String date,
    String avatarUrl,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(avatarUrl),
                radius: 20,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.orange,
                          size: 18.0,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Text('"$reviewText"', style: const TextStyle(fontSize: 14.0)),
          const SizedBox(height: 8.0),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              date,
              style: const TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
