// lib/screens/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting timestamps
import 'package:hotel_system_1/models/app_notification.dart'; // Import AppNotification model
import 'package:hotel_system_1/services/notification_service.dart'; // Import NotificationService

// Updated color definitions based on the consistent blue/white palette
const Color kPrimaryBlue = Color(0xFF1E88E5); // A distinct blue for app bars and accents
const Color kDarkBlue = Color(0xFF1565C0); // A darker shade for text/icons
const Color kLightBlue = Color(0xFFE3F2FD); // A very light blue for backgrounds
const Color kWhite = Colors.white; // Pure white for elements
const Color kGreyText = Color(0xFF757575); // A medium grey for secondary text

// Converted to StatefulWidget to listen for changes
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notificationService = NotificationService();
  List<AppNotification> _notifications = [];

  @override
  void initState() {
    super.initState();
    // Initialize notifications from the service
    _notifications = _notificationService.notifications;
    // Add a listener to rebuild the widget when notifications change
    _notificationService.addListener(_onNotificationsChanged);
  }

  @override
  void dispose() {
    // Remove the listener to prevent memory leaks
    _notificationService.removeListener(_onNotificationsChanged);
    super.dispose();
  }

  void _onNotificationsChanged() {
    // Update the local state and trigger a rebuild
    setState(() {
      _notifications = _notificationService.notifications;
    });
  }

  // Helper function to format time difference
  String _formatTimeDifference(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return DateFormat('MMM dd, yyyy').format(timestamp);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBlue, // Set scaffold background to light blue
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: kWhite, // Make app bar title white
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kPrimaryBlue, // Set app bar background to kPrimaryBlue
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: kWhite, // Make back icon white
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.notifications_off,
                    size: 80,
                    color: kDarkBlue, // Changed to kDarkBlue
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No new notifications.',
                    style: TextStyle(fontSize: 18, color: kDarkBlue), // Changed to kDarkBlue
                  ),
                  const Text(
                    'All clear here!',
                    style: TextStyle(fontSize: 14, color: kGreyText), // Changed to kGreyText
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildNotificationCard(
                    context,
                    // Determine icon based on notification type
                    notification.type == 'booking'
                        ? Icons.event_available_outlined
                        : notification.type == 'offer'
                            ? Icons.local_offer_outlined
                            : Icons.info_outline,
                    notification.title,
                    notification.message,
                    _formatTimeDifference(notification.timestamp),
                  ),
                );
              },
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
        color: kWhite, // Keep card background white
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1), // Adjusted to black with opacity for softer shadow
            spreadRadius: 1,
            blurRadius: 5, // Slightly increased blur for softer shadow
            offset: const Offset(0, 3), // Adjusted offset
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kPrimaryBlue, size: 30.0), // Changed icon color to kPrimaryBlue
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
                    color: kDarkBlue, // Changed title color to kDarkBlue
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14.0, color: kGreyText), // Changed subtitle color to kGreyText
                ),
                const SizedBox(height: 8.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    time,
                    style: const TextStyle(fontSize: 12.0, color: kGreyText), // Changed time color to kGreyText
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