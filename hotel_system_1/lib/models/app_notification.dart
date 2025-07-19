// lib/models/app_notification.dart
class AppNotification {
  final String title;
  final String message;
  final DateTime timestamp;
  final String type; // e.g., 'booking', 'offer', 'system'

  AppNotification({
    required this.title,
    required this.message,
    required this.timestamp,
    this.type = 'general', // Default type
  });
}