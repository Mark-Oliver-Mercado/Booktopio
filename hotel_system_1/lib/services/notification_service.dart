// lib/services/notification_service.dart
import 'package:flutter/foundation.dart';
import '../models/app_notification.dart'; // Import your AppNotification model

class NotificationService extends ChangeNotifier {
  // Singleton instance
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  // The list to hold all notifications
  final List<AppNotification> _notifications = [];

  // Getter to provide an immutable copy of the notifications list
  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  // Method to add a new notification
  void addNotification(AppNotification newNotification) {
    // Add new notifications to the beginning of the list for chronological display
    _notifications.insert(0, newNotification);
    // Notify all listeners that the list has changed
    notifyListeners();
  }

  // Optional: Clear all notifications
  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }
}