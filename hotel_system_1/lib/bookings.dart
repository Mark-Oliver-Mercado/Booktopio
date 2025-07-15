// bookings.dart
import 'package:flutter/material.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking History'),
        backgroundColor: Color(0xFFFFCCBC),
        iconTheme: IconThemeData(color: Color(0xFF5D4037)),
      ),
      backgroundColor: const Color(0xFFFBE9E7),
      body: const Center(
        child: Text(
          'No bookings yet.',
          style: TextStyle(fontSize: 18, color: Colors.brown),
        ),
      ),
    );
  }
}
