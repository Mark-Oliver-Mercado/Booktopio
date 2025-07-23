import 'package:flutter/material.dart';
import '../services/booking_service.dart'; // Import BookingService
import '../models/booking.dart'; // Import the Booking model

// Represents an individual hotel booking transaction.
// This class is now named 'Booking' as per the updated model.
// (It was previously named 'Transaction' in this file's context, but 'Booking' is the consistent model name)
// No changes to this class itself, just keeping it here for reference of its fields.
class Transaction { // Keeping this as 'Transaction' for backward compatibility with existing code that might refer to it,
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
  State<TransactionScreenContent> createState() => _TransactionScreenContentState();
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
      _transactions = BookingService().bookings; // Get bookings from BookingService
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
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: const Text(
                'Transaction Records',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _transactions.isEmpty
                ? const Expanded(
                    child: Center(
                      child: Text(
                        'No transactions yet. Book a room to see them here!',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        child: DataTable(
                          headingRowColor: WidgetStateColor.resolveWith(
                            (states) => const Color(0xFF2E7D32),
                          ),
                          headingTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          dataRowColor: WidgetStateColor.resolveWith(
                            (states) => Colors.white,
                          ),
                          columnSpacing: 24,
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
                                : const Color(0xFFF0F0F0);
                            return DataRow(
                              color: MaterialStateColor.resolveWith(
                                (states) => rowColor,
                              ),
                              cells: [
                                DataCell(Text(tx.roomType)),
                                DataCell(
                                  Text('₱${tx.pricePerNight.toStringAsFixed(2)}'),
                                ),
                                DataCell(Text('${tx.numberOfNights}')),
                                DataCell(
                                  Text('₱${tx.totalPrice.toStringAsFixed(2)}'),
                                ),
                                DataCell(
                                  Text(
                                    '${formatDate(tx.checkInDate)}\n${formatTime(tx.checkInTime)}',
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '${formatDate(tx.checkOutDate)}\n${formatTime(tx.checkOutTime)}',
                                  ),
                                ),
                                DataCell(Text(tx.paymentMethod)),
                                DataCell(Text(tx.specialRequests ?? 'None')),
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
