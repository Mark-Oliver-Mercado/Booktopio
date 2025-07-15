// notifications_screen.dart
import 'package:flutter/material.dart';

// Ensure you have these color definitions or import a file that contains them
// For this example, I'm assuming they are defined similarly to your home.dart
const Color kPrimaryGreen = Color(0xFF73C088); // A refreshing mid-green

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white, // Make app bar title white
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:
            kPrimaryGreen, // Set app bar background to kPrimaryGreen
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white, // Make back icon white
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
            _buildNotificationCard(
              context,
              Icons.event_available_outlined,
              'Booking Confirmed!',
              'Your reservation at Grand Hyatt Hotel for 3 nights has been successfully confirmed.',
              '2 hours ago',
            ),
            const SizedBox(height: 16.0),
            _buildNotificationCard(
              context,
              Icons.local_offer_outlined,
              'Special Offer for You',
              'Get 20% off your next booking at selected hotels. Limited time offer!',
              'Yesterday',
            ),
            const SizedBox(height: 16.0),
            _buildNotificationCard(
              context,
              Icons.info_outline,
              'System Update',
              "We've updated our app with new features and improvements. Check them out!",
              '3 days ago',
            ),
            const SizedBox(height: 16.0),
            _buildNotificationCard(
              context,
              Icons.notifications_active_outlined,
              'Welcome to Banani!',
              'Thank you for joining our community. Start exploring amazing hotels now!',
              '1 week ago',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    String time,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal, size: 30.0),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
                const SizedBox(height: 8.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    time,
                    style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
