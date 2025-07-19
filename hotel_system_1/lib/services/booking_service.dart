// lib/services/booking_service.dart
import 'package:flutter/foundation.dart';
import '../models/booking.dart'; // Ensure this path is correct

class BookingService extends ChangeNotifier {
  // Singleton instance
  static final BookingService _instance = BookingService._internal();

  factory BookingService() {
    return _instance;
  }

  BookingService._internal();

  // The list to hold all confirmed bookings
  final List<Booking> _bookings = [];

  // Getter to provide an immutable copy of the bookings list
  List<Booking> get bookings => List.unmodifiable(_bookings);

  // Method to add a new booking
  void addBooking(Booking newBooking) {
    _bookings.add(newBooking);
    // Notify all listeners that the list has changed
    notifyListeners();
  }

  // Optional: Clear all bookings (for testing or logout)
  void clearBookings() {
    _bookings.clear();
    notifyListeners();
  }
}