import 'package:flutter/material.dart';
import '../services/booking_service.dart'; // Import BookingService
import '../models/booking.dart'; // Import the Booking model

// Represents an individual hotel booking transaction.
// This class is now named 'Booking' as per the updated model.
// (It was previously named 'Transaction' in this file's context, but 'Booking' is the consistent model name)
// No changes to this class itself, just keeping it here for reference of its fields.
class Transaction {
  // Keeping this as 'Transaction' for backward compatibility with existing code that might refer to it,
  // but internally, we'll use the 'Booking' model from models/booking.dart
  final String roomType;
  final double pricePerNight;
  final int numberOfNights;
  final double totalPrice;
  final DateTime checkInDate;
  final TimeOfDay checkInTime;
  final DateTime checkOutDate;
  final TimeOfDay checkOutTime;
  final String paymentMethod;
  final String? specialRequests;
  final String cardType;
  final String cardholderName;

  Transaction({
    required this.roomType,
    required this.pricePerNight,
    required this.numberOfNights,
    required this.totalPrice,
    required this.checkInDate,
    required this.checkInTime,
    required this.checkOutDate,
    required this.checkOutTime,
    required this.paymentMethod,
    this.specialRequests,
    required this.cardType,
    required this.cardholderName,
  });
}

// The screen displaying the list of hotel booking transactions.
class TransactionScreenContent extends StatefulWidget {
  TransactionScreenContent({Key? key}) : super(key: key);

  @override
  State<TransactionScreenContent> createState() =>
      _TransactionScreenContentState();
}

class _TransactionScreenContentState extends State<TransactionScreenContent> {
  List<Booking> _transactions = []; // Changed type to List<Booking>

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    // Listen for changes in BookingService to update transactions in real-time
    BookingService().addListener(_onBookingsChanged);
  }

  @override
  void dispose() {
    BookingService().removeListener(_onBookingsChanged);
    super.dispose();
  }

  void _loadTransactions() {
    setState(() {
      _transactions =
          BookingService().bookings; // Get bookings from BookingService
    });
  }

  void _onBookingsChanged() {
    _loadTransactions(); // Reload transactions when BookingService notifies changes
  }

  // Helper functions to format DateTime and TimeOfDay objects.
  String formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  String formatTime(TimeOfDay t) =>
      '${t.hourOfPeriod.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')} ${t.period == DayPeriod.am ? 'AM' : 'PM'}';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Define a breakpoint for mobile vs. desktop layout
    final isDesktop = screenWidth > 800; // Example breakpoint

    return Container(
      color: const Color(0xFFF0F2F5), // Lighter background for admin feel
      child: Padding(
        padding: EdgeInsets.all(
          isDesktop ? 30 : 16,
        ), // Adjust padding based on device
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Transaction Records',
                style: TextStyle(
                  fontSize: isDesktop ? 32 : 26, // Larger font for desktop
                  fontWeight: FontWeight.bold,
                  color: const Color(
                    0xFF34495E,
                  ), // Darker, more professional text color
                ),
              ),
            ),
            SizedBox(height: isDesktop ? 25 : 20), // Adjust spacing
            _transactions.isEmpty
                ? Expanded(
                    child: Center(
                      child: Text(
                        'No transactions yet. Book a room to see them here!',
                        style: TextStyle(
                          fontSize: isDesktop ? 18 : 16,
                          color: Colors.grey[600],
                        ), // Slightly darker grey
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: isDesktop
                              ? screenWidth * 0.75
                              : screenWidth *
                                    0.9, // Adjust minWidth for responsiveness
                        ),
                        child: DataTable(
                          decoration: BoxDecoration(
                            color: Colors.white, // Table background color
                            borderRadius: BorderRadius.circular(
                              8,
                            ), // Rounded corners for the table
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.15),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: const Offset(
                                  0,
                                  3,
                                ), // Subtle shadow for depth
                              ),
                            ],
                          ),
                          headingRowColor: WidgetStateColor.resolveWith(
                            (states) => const Color(
                              0xFF2C3E50,
                            ), // Dark blue-grey header
                          ),
                          headingTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15, // Consistent header font size
                          ),
                          dataRowColor: WidgetStateColor.resolveWith(
                            (states) => Colors.white,
                          ),
                          columnSpacing: isDesktop
                              ? 40
                              : 16, // More spacing for desktop columns
                          columns: const [
                            DataColumn(label: Text('Room Type')),
                            DataColumn(label: Text('Rate')),
                            DataColumn(label: Text('Nights')),
                            DataColumn(label: Text('Total')),
                            DataColumn(label: Text('Check-In')),
                            DataColumn(label: Text('Check-Out')),
                            DataColumn(label: Text('Payment')),
                            DataColumn(label: Text('Requests')),
                          ],
                          rows: _transactions.asMap().entries.map((entry) {
                            final index = entry.key;
                            final tx = entry.value; // tx is now of type Booking
                            final rowColor = index % 2 == 0
                                ? Colors.white
                                : const Color(
                                    0xFFF8F9FA,
                                  ); // Very light grey for alternate rows
                            return DataRow(
                              color: MaterialStateColor.resolveWith(
                                (states) => rowColor,
                              ),
                              cells: [
                                DataCell(
                                  Text(
                                    tx.roomType,
                                    style: TextStyle(
                                      fontSize: isDesktop ? 14 : 12,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '₱${tx.pricePerNight.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: isDesktop ? 14 : 12,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '${tx.numberOfNights}',
                                    style: TextStyle(
                                      fontSize: isDesktop ? 14 : 12,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '₱${tx.totalPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: isDesktop ? 14 : 12,
                                      fontWeight:
                                          FontWeight.bold, // Total price bold
                                      color: const Color(0xFF28A745),
                                    ),
                                  ), // Green for total price
                                ),
                                DataCell(
                                  Text(
                                    '${formatDate(tx.checkInDate)}\n${formatTime(tx.checkInTime)}',
                                    style: TextStyle(
                                      fontSize: isDesktop ? 14 : 12,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '${formatDate(tx.checkOutDate)}\n${formatTime(tx.checkOutTime)}',
                                    style: TextStyle(
                                      fontSize: isDesktop ? 14 : 12,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    tx.paymentMethod,
                                    style: TextStyle(
                                      fontSize: isDesktop ? 14 : 12,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    tx.specialRequests ?? 'None',
                                    style: TextStyle(
                                      fontSize: isDesktop ? 14 : 12,
                                      fontStyle: tx.specialRequests == null
                                          ? FontStyle.italic
                                          : FontStyle
                                                .normal, // Italicize 'None'
                                      color: tx.specialRequests == null
                                          ? Colors.grey[500]
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
