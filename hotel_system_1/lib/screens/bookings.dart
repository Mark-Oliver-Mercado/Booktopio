// lib/screens/bookings.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting timestamps
import 'package:hotel_system_1/models/booking.dart'; // Adjust this import path if needed
import 'package:hotel_system_1/services/booking_service.dart'; // Import the BookingService

// Corrected and updated color definitions based on the provided image palette
const Color kPrimaryBlue = Color(0xFF1E88E5); // A distinct blue for app bars and accents (from image)
const Color kDarkBlue = Color(0xFF1565C0); // A darker shade for text/icons (from image)
const Color kLightBlue = Color(0xFFE3F2FD); // A very light blue for backgrounds (from image)
const Color kWhite = Colors.white; // Pure white for elements
const Color kGreyText = Color(0xFF757575); // A medium grey for secondary text (from image/common practice)

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final BookingService _bookingService = BookingService();

  @override
  void initState() {
    super.initState();
    _bookingService.addListener(_onBookingsChanged);
  }

  @override
  void dispose() {
    _bookingService.removeListener(_onBookingsChanged);
    super.dispose();
  }

  void _onBookingsChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<Booking> currentBookings = _bookingService.bookings;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'My Bookings',
          style: TextStyle(
            color: kWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kPrimaryBlue, // Set app bar background to kPrimaryBlue
        elevation: 0,
      ),
      body: Container(
        color: kLightBlue, // Consistent light blue background
        child: currentBookings.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.receipt_long,
                      size: 80,
                      color: kDarkBlue, // Changed to kDarkBlue
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'You have no upcoming bookings.',
                      style: TextStyle(
                        fontSize: 18,
                        color: kDarkBlue, // Changed to kDarkBlue
                      ),
                    ),
                    const Text(
                      'Start exploring hotels to plan your next trip!',
                      style: TextStyle(
                        fontSize: 14,
                        color: kGreyText, // Using kGreyText for secondary messages
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: currentBookings.length,
                itemBuilder: (context, index) {
                  final booking = currentBookings[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.hotelName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kDarkBlue, // Changed to kDarkBlue
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Room Type: ${booking.roomType}',
                            style: const TextStyle(fontSize: 16, color: kGreyText), // Using kGreyText
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Price per night: ₱${booking.pricePerNight}',
                            style: const TextStyle(fontSize: 16, color: kGreyText), // Using kGreyText
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Nights: ${booking.numberOfNights}',
                            style: const TextStyle(fontSize: 16, color: kGreyText), // Using kGreyText
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Total Price: ₱${booking.totalPrice}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryBlue, // Changed to kPrimaryBlue
                            ),
                          ),
                          const Divider(height: 20, thickness: 1, color: kLightBlue), // Added color for Divider
                          _buildBookingDetailRow(
                            'Check-in:',
                            '${DateFormat('yMMMd').format(booking.checkInDate)} at ${booking.checkInTime.format(context)}',
                            Icons.calendar_today,
                          ),
                          _buildBookingDetailRow(
                            'Check-out:',
                            '${DateFormat('yMMMd').format(booking.checkOutDate)} at ${booking.checkOutTime.format(context)}',
                            Icons.calendar_today,
                          ),
                          _buildBookingDetailRow(
                            'Payment Method:',
                            '${booking.paymentMethod} (${booking.cardType})',
                            Icons.payment,
                          ),
                          _buildBookingDetailRow(
                            'Cardholder:',
                            booking.cardholderName,
                            Icons.person,
                          ),
                          if (booking.specialRequests != null && booking.specialRequests!.isNotEmpty)
                            _buildBookingDetailRow(
                              'Requests:',
                              booking.specialRequests!,
                              Icons.notes,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  // Helper widget to build consistent detail rows
  Widget _buildBookingDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: kDarkBlue), // Changed to kDarkBlue
          const SizedBox(width: 8),
          Text(
            '$label ',
            style: const TextStyle(fontWeight: FontWeight.bold, color: kDarkBlue), // Changed to kDarkBlue
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: kGreyText), // Using kGreyText
            ),
          ),
        ],
      ),
    );
  }
}