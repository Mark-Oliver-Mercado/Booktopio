// lib/models/booking.dart
import 'package:flutter/material.dart'; // Required for TimeOfDay

class Booking {
  final String hotelName;
  final String roomType;
  final int pricePerNight;
  final int numberOfNights;
  final int totalPrice;
  final DateTime checkInDate;
  final TimeOfDay checkInTime;
  final DateTime checkOutDate;
  final TimeOfDay checkOutTime;
  final String paymentMethod;
  final String cardType;
  final String cardholderName;
  final String? specialRequests; // Optional field

  Booking({
    required this.hotelName,
    required this.roomType,
    required this.pricePerNight,
    required this.numberOfNights,
    required this.totalPrice,
    required this.checkInDate,
    required this.checkInTime,
    required this.checkOutDate,
    required this.checkOutTime,
    required this.paymentMethod,
    required this.cardType,
    required this.cardholderName,
    this.specialRequests,
  });
}