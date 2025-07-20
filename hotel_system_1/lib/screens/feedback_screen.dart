import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the provider package

// Define color constants directly in this file for self-containment
const Color kPrimaryBlue = Color(
  0xFF1E88E5,
); // A distinct blue for app bars and accents
const Color kDarkBlue = Color(0xFF1565C0); // A darker shade for text/icons
const Color kLightBlue = Color(0xFFE3F2FD); // A very light blue for backgrounds
const Color kWhite = Colors.white; // Pure white for elements
const Color kGreyText = Color(0xFF757575); // A medium grey for secondary text

// Define a data class for a Review to better structure the data
class Review {
  final String name;
  final int rating;
  final String reviewText;
  final String date;
  final String avatarUrl;

  Review({
    required this.name,
    required this.rating,
    required this.reviewText,
    required this.date,
    required this.avatarUrl,
  });
}

/// NEW: FeedbackProvider to manage the list of reviews globally
class FeedbackProvider extends ChangeNotifier {
  // List to hold recent reviews, including newly submitted ones
  final List<Review> _reviews = [
    Review(
      name: 'Alice Johnson',
      rating: 4,
      reviewText:
          'Fantastic stay! The room was clean, spacious, and had a great view. Staff were incredibly friendly and helpful. Highly recommend!',
      date: 'October 25, 2023',
      avatarUrl:
          'https://placehold.co/150x150/FF5733/FFFFFF?text=A', // Placeholder for avatar
    ),
    Review(
      name: 'Bob Williams',
      rating: 3,
      reviewText:
          'Good location, but the breakfast was a bit underwhelming. Room was comfortable enough for a short business trip.',
      date: 'October 20, 2023',
      avatarUrl:
          'https://placehold.co/150x150/33A3FF/FFFFFF?text=B', // Placeholder for avatar
    ),
  ];

  // Getter to provide an unmodifiable view of the reviews list
  List<Review> get reviews => _reviews;

  // Method to add a new review and notify listeners
  void addReview(Review newReview) {
    _reviews.insert(0, newReview); // Add to the top of the list
    notifyListeners(); // Notify all widgets listening to this provider
  }
}

// Converted to StatefulWidget to manage mutable state (rating and text input)
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  // Controller for the review text field
  final TextEditingController _reviewController = TextEditingController();
  // State variable to hold the current rating
  int _currentRating = 0; // Initial rating is 0

  @override
  void dispose() {
    _reviewController
        .dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  // Function to handle submitting the review
  void _submitReview() {
    final String reviewText = _reviewController.text.trim(); // Trim whitespace
    if (reviewText.isEmpty || _currentRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a review and select a rating.'),
        ),
      );
      return;
    }

    // Create a new Review object
    final newReview = Review(
      name: 'You', // Placeholder for the current user's name
      rating: _currentRating,
      reviewText: reviewText,
      date: DateTime.now().toLocal().toString().split(' ')[0], // Current date
      avatarUrl:
          'https://placehold.co/150x150/8BC34A/FFFFFF?text=U', // Placeholder for user avatar
    );

    // Get the FeedbackProvider instance and add the new review
    Provider.of<FeedbackProvider>(context, listen: false).addReview(newReview);

    // Display a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Review Submitted Successfully!'),
        duration: Duration(seconds: 2),
      ),
    );

    // Clear the input fields and reset the rating after submission
    _reviewController.clear();
    setState(() {
      _currentRating = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access the list of reviews from the FeedbackProvider
    final feedbackProvider = Provider.of<FeedbackProvider>(context);
    final List<Review> recentReviews = feedbackProvider.reviews;

    return Scaffold(
      backgroundColor: kLightBlue,
      appBar: AppBar(
        title: const Text('Feedback', style: TextStyle(color: Colors.white)),
        backgroundColor: kPrimaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: kDarkBlue,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Hotel/Room',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: kDarkBlue,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Text(
                'Grand Hyatt', // This could be dynamically set based on selected hotel/room
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            const SizedBox(height: 24.0),

            // Your Rating
            Text(
              'Your Rating',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: kDarkBlue,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    // Display filled star if index is less than current rating, else border star
                    index < _currentRating ? Icons.star : Icons.star_border,
                    color: Colors.orange, // Keeping orange for star rating
                    size: 32.0,
                  ),
                  onPressed: () {
                    // Update the rating when a star is tapped
                    setState(() {
                      _currentRating =
                          index + 1; // Set rating to 1-5 based on tapped star
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 24.0),

            // Your Review
            Text(
              'Your Review',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: kDarkBlue,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              height: 120.0,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _reviewController, // Assign the controller
                maxLines: null, // Allows multiline input
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Share your experience...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: kGreyText.withOpacity(0.7)),
                ),
                style: TextStyle(color: kDarkBlue),
              ),
            ),
            const SizedBox(height: 24.0),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitReview, // Call the submit review function
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryBlue,
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
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: kDarkBlue,
              ),
            ),
            const SizedBox(height: 16.0),
            // Dynamically build review cards from the _recentReviews list
            ...recentReviews.map((review) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildReviewCard(
                  context,
                  review.name,
                  review.rating,
                  review.reviewText,
                  review.date,
                  review.avatarUrl,
                ),
              );
            }).toList(),
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
            color: Colors.grey.withOpacity(0.2), // Corrected alpha usage
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

// Example of how to integrate FeedbackScreen with FeedbackProvider in your main.dart
// You would typically put this in your main.dart file.
/*
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FeedbackProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FeedbackScreen(), // Or your main screen that can navigate to FeedbackScreen
    );
  }
}
*/
