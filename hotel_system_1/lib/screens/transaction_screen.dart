import 'package:flutter/material.dart';

class Transaction {
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
  });
}

class TransactionsScreen extends StatelessWidget {
  TransactionsScreen({Key? key}) : super(key: key);

  final List<Transaction> transactions = [
    Transaction(roomType: 'Deluxe Suite', pricePerNight: 3500, numberOfNights: 2, totalPrice: 7000, checkInDate: DateTime(2025, 7, 20), checkInTime: TimeOfDay(hour: 14, minute: 0), checkOutDate: DateTime(2025, 7, 22), checkOutTime: TimeOfDay(hour: 12, minute: 0), paymentMethod: 'Credit Card', specialRequests: 'Near pool'),
    Transaction(roomType: 'Standard Room', pricePerNight: 2000, numberOfNights: 1, totalPrice: 2000, checkInDate: DateTime(2025, 7, 19), checkInTime: TimeOfDay(hour: 13, minute: 0), checkOutDate: DateTime(2025, 7, 20), checkOutTime: TimeOfDay(hour: 11, minute: 0), paymentMethod: 'Gcash', specialRequests: null),
    Transaction(roomType: 'Ocean View', pricePerNight: 5000, numberOfNights: 3, totalPrice: 15000, checkInDate: DateTime(2025, 7, 18), checkInTime: TimeOfDay(hour: 15, minute: 30), checkOutDate: DateTime(2025, 7, 21), checkOutTime: TimeOfDay(hour: 11, minute: 0), paymentMethod: 'PayPal', specialRequests: 'High floor'),
    Transaction(roomType: 'Family Room', pricePerNight: 4200, numberOfNights: 2, totalPrice: 8400, checkInDate: DateTime(2025, 7, 17), checkInTime: TimeOfDay(hour: 14, minute: 0), checkOutDate: DateTime(2025, 7, 19), checkOutTime: TimeOfDay(hour: 11, minute: 0), paymentMethod: 'Cash', specialRequests: 'Extra bed'),
    Transaction(roomType: 'Suite 101', pricePerNight: 6000, numberOfNights: 1, totalPrice: 6000, checkInDate: DateTime(2025, 7, 15), checkInTime: TimeOfDay(hour: 16, minute: 0), checkOutDate: DateTime(2025, 7, 16), checkOutTime: TimeOfDay(hour: 12, minute: 0), paymentMethod: 'Credit Card', specialRequests: 'Romantic setup'),
    Transaction(roomType: 'Budget Room', pricePerNight: 1500, numberOfNights: 2, totalPrice: 3000, checkInDate: DateTime(2025, 7, 13), checkInTime: TimeOfDay(hour: 13, minute: 0), checkOutDate: DateTime(2025, 7, 15), checkOutTime: TimeOfDay(hour: 11, minute: 0), paymentMethod: 'Gcash', specialRequests: null),
    Transaction(roomType: 'Penthouse', pricePerNight: 8000, numberOfNights: 2, totalPrice: 16000, checkInDate: DateTime(2025, 7, 10), checkInTime: TimeOfDay(hour: 14, minute: 0), checkOutDate: DateTime(2025, 7, 12), checkOutTime: TimeOfDay(hour: 12, minute: 0), paymentMethod: 'Credit Card', specialRequests: 'Birthday decoration'),
    Transaction(roomType: 'Studio Room', pricePerNight: 2500, numberOfNights: 1, totalPrice: 2500, checkInDate: DateTime(2025, 7, 9), checkInTime: TimeOfDay(hour: 14, minute: 0), checkOutDate: DateTime(2025, 7, 10), checkOutTime: TimeOfDay(hour: 11, minute: 0), paymentMethod: 'PayPal', specialRequests: 'Accessible room'),
    Transaction(roomType: 'Double Room', pricePerNight: 2800, numberOfNights: 3, totalPrice: 8400, checkInDate: DateTime(2025, 7, 6), checkInTime: TimeOfDay(hour: 15, minute: 0), checkOutDate: DateTime(2025, 7, 9), checkOutTime: TimeOfDay(hour: 12, minute: 0), paymentMethod: 'Credit Card', specialRequests: 'Late checkout'),
    Transaction(roomType: 'Presidential Suite', pricePerNight: 12000, numberOfNights: 1, totalPrice: 12000, checkInDate: DateTime(2025, 7, 5), checkInTime: TimeOfDay(hour: 14, minute: 0), checkOutDate: DateTime(2025, 7, 6), checkOutTime: TimeOfDay(hour: 12, minute: 0), paymentMethod: 'Bank Transfer', specialRequests: 'VIP access'),
  ];

  String formatDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  String formatTime(TimeOfDay t) => '${t.hourOfPeriod.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')} ${t.period == DayPeriod.am ? 'AM' : 'PM'}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Records'),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 2,
      ),
      body: Container(
        color: const Color(0xFFF5F5F5),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateColor.resolveWith((states) => const Color(0xFF2E7D32)),
            headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            dataRowColor: WidgetStateColor.resolveWith((states) => Colors.white),
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
            rows: transactions.asMap().entries.map((entry) {
              final index = entry.key;
              final tx = entry.value;
              final rowColor = index % 2 == 0 ? Colors.white : const Color(0xFFF0F0F0);
              return DataRow(
                color: MaterialStateColor.resolveWith((states) => rowColor),
                cells: [
                  DataCell(Text(tx.roomType)),
                  DataCell(Text('₱${tx.pricePerNight.toStringAsFixed(2)}')),
                  DataCell(Text('${tx.numberOfNights}')),
                  DataCell(Text('₱${tx.totalPrice.toStringAsFixed(2)}')),
                  DataCell(Text('${formatDate(tx.checkInDate)}\n${formatTime(tx.checkInTime)}')),
                  DataCell(Text('${formatDate(tx.checkOutDate)}\n${formatTime(tx.checkOutTime)}')),
                  DataCell(Text(tx.paymentMethod)),
                  DataCell(Text(tx.specialRequests ?? 'None')),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
