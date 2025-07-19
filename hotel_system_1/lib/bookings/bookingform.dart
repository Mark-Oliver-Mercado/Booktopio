import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking.dart'; // Import your Booking model
import '../services/booking_service.dart'; // Import the BookingService
import '../services/notification_service.dart'; // Import NotificationService
import '../models/app_notification.dart'; // Import AppNotification model
// Removed import for home.dart as we no longer need to explicitly navigate to it as a new root

// Define the main blue and white colors for consistency
const Color kPrimaryBlue = Color(0xFF0065FF); // A vibrant blue for primary elements
const Color kDarkBlue = Color(0xFF003C99); // A darker blue for text/icons
const Color kLightBlue = Color(0xFFE6F2FF); // A very light blue for backgrounds
const Color kAppBarTitleBlue = Color(0xFF1565C0); // A darker blue for high contrast titles
const Color kButtonBlue = Color(0xFF90CAF9); // A mid-light blue for buttons
const Color kWhite = Colors.white; // Pure white for elements

class Amenity {
  final IconData icon;
  final String label;
  const Amenity({required this.icon, required this.label});
}

class BookingFormScreen extends StatefulWidget {
  final String hotelName;
  final String roomType;
  final int price;
  final String roomImagePath;
  final String roomDescription;
  final List<Amenity> amenities;

  const BookingFormScreen({
    super.key,
    required this.hotelName,
    required this.roomType,
    required this.price,
    required this.roomImagePath,
    required this.roomDescription,
    required this.amenities,
  });

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  // Global key for the overall form (used for final submission validation)
  final _formKey = GlobalKey<FormState>();

  // Separate GlobalKeys for each step's content to allow step-by-step validation
  final _personalInfoFormKey = GlobalKey<FormState>();
  final _bookingInfoFormKey = GlobalKey<FormState>();
  final _paymentNotesFormKey = GlobalKey<FormState>();

  int _currentStep = 0;

  // Controllers
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _requests = TextEditingController();
  final _cardNumber = TextEditingController();
  final _cardExpiry = TextEditingController();
  final _cardCVV = TextEditingController();
  final _cardholderName = TextEditingController(); // New controller for cardholder name

  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  TimeOfDay? _checkInTime = TimeOfDay.now();
  TimeOfDay? _checkOutTime = TimeOfDay.now();

  final String _paymentMethod = 'Credit Card'; // Default payment method changed to Credit Card

  String _selectedCardType = 'Visa'; // New state for selected card type

  int _numberOfNights = 0; // State to store the calculated number of nights
  int _totalPrice = 0; // State to store the calculated total price

  @override
  void initState() {
    super.initState();
    _calculateNightsAndTotal(); // Calculate initial nights and total
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _requests.dispose();
    _cardNumber.dispose();
    _cardExpiry.dispose();
    _cardCVV.dispose();
    _cardholderName.dispose();
    super.dispose();
  }

  // Helper function to calculate number of nights and total price
  void _calculateNightsAndTotal() {
    if (_checkInDate != null && _checkOutDate != null) {
      final Duration difference = _checkOutDate!.difference(_checkInDate!);
      setState(() {
        _numberOfNights = difference.inDays;
        _totalPrice = _numberOfNights * widget.price;
      });
    } else {
      setState(() {
        _numberOfNights = 0;
        _totalPrice = 0;
      });
    }
  }

  // Helper functions
  Future<void> _pickDate(bool isCheckIn) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: kPrimaryBlue, // Header background color
              onPrimary: kWhite, // Header text color
              onSurface: kDarkBlue, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: kPrimaryBlue, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
        } else {
          _checkOutDate = picked;
        }
        _calculateNightsAndTotal(); // Recalculate nights and total after date change
      });
    }
  }

  Future<void> _pickTime(bool isCheckIn) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: kPrimaryBlue, // Header background color
              onPrimary: kWhite, // Header text color
              onSurface: kDarkBlue, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: kPrimaryBlue, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInTime = picked;
        } else {
          _checkOutTime = picked;
        }
      });
    }
  }

  InputDecoration _inputBox(String label, {String? hintText}) => InputDecoration(
        labelText: label,
        hintText: hintText, // Added hintText
        // Changed from BorderSide.none to a visible border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14), // Increased border radius for rounded look
          borderSide: const BorderSide(color: Colors.grey, width: 1.0), // Added a subtle grey border
        ),
        enabledBorder: OutlineInputBorder( // Define enabled border for consistency
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0), // Lighter grey for enabled state
        ),
        focusedBorder: OutlineInputBorder( // Define focused border for consistency
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kPrimaryBlue, width: 2.0), // Primary blue for focused state
        ),
        filled: true,
        fillColor: kWhite, // White background for input fields
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      );

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    TextInputType type, {
    String? Function(String?)? validator,
    int maxLines = 1,
    String? exampleText, // New parameter for specific example text
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        validator: validator ?? (v) => v == null || v.isEmpty ? 'Please enter $label' : null,
        decoration: _inputBox(label, hintText: exampleText ?? 'Enter $label'.toLowerCase()), // Use exampleText if provided
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildDateTimeField(
    String label,
    DateTime? date,
    TimeOfDay? time,
    VoidCallback onDateTap,
    VoidCallback onTimeTap,
  ) {
    final dateStr = date != null
        ? DateFormat('yyyy-MM-dd').format(date)
        : 'Select Date';
    final timeStr = time != null ? time.format(context) : 'Select Time';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: kDarkBlue)),
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onDateTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300, width: 1.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Use min to prevent excessive width
                    children: [
                      const Icon(Icons.calendar_today, color: kPrimaryBlue, size: 20),
                      const SizedBox(width: 8),
                      Flexible( // Use Flexible to prevent overflow
                        child: Text(
                          dateStr,
                          style: TextStyle(color: date != null ? Colors.black87 : Colors.grey[600]),
                          overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: InkWell(
                onTap: onTimeTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300, width: 1.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Use min to prevent excessive width
                    children: [
                      const Icon(Icons.access_time, color: kPrimaryBlue, size: 20),
                      const SizedBox(width: 8),
                      Flexible( // Use Flexible to prevent overflow
                        child: Text(
                          timeStr,
                          style: TextStyle(color: time != null ? Colors.black87 : Colors.grey[600]),
                          overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _submitForm() {
    // 1. Create the Booking object
    final newBooking = Booking(
      hotelName: widget.hotelName,
      roomType: widget.roomType,
      pricePerNight: widget.price,
      numberOfNights: _numberOfNights,
      totalPrice: _totalPrice,
      checkInDate: _checkInDate!, // Assumed non-null due to validation
      checkInTime: _checkInTime!,
      checkOutDate: _checkOutDate!,
      checkOutTime: _checkOutTime!,
      paymentMethod: _paymentMethod,
      cardType: _selectedCardType,
      cardholderName: _cardholderName.text,
      specialRequests: _requests.text.isNotEmpty ? _requests.text : null,
    );

    // 2. Add the new booking to the BookingService singleton
    BookingService().addBooking(newBooking);

    // 3. Add a notification about the successful booking
    NotificationService().addNotification(
      AppNotification(
        title: 'Booking Confirmed!',
        message: 'Your reservation at ${widget.hotelName} for ${newBooking.numberOfNights} nights has been successfully confirmed.',
        timestamp: DateTime.now(),
        type: 'booking',
      ),
    );

    // 4. Show the confirmation dialog
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Booking Confirmed',
            style: TextStyle(color: kDarkBlue, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Thanks, ${_firstName.text} ${_lastName.text}!',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 15),
              _buildConfirmationRow('Hotel:', widget.hotelName),
              _buildConfirmationRow('Room Type:', widget.roomType),
              _buildConfirmationRow('Price per night:', '₱${widget.price}'),
              _buildConfirmationRow('Number of nights:', '$_numberOfNights'),
              _buildConfirmationRow('Total Price:', '₱$_totalPrice',
                  isBold: true, color: kPrimaryBlue),
              const SizedBox(height: 15),
              _buildConfirmationRow(
                  'Check-in:',
                  '${DateFormat('yMMMd').format(_checkInDate!)} at ${_checkInTime!.format(context)}'),
              _buildConfirmationRow(
                  'Check-out:',
                  '${DateFormat('yMMMd').format(_checkOutDate!)} at ${_checkOutTime!.format(context)}'),
              _buildConfirmationRow('Payment Method:', _paymentMethod),
              _buildConfirmationRow('Card Type:', _selectedCardType),
              _buildConfirmationRow('Cardholder Name:', _cardholderName.text),
              if (_requests.text.isNotEmpty)
                _buildConfirmationRow('Special Requests:', _requests.text),
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.center, // Center the actions
        actions: [
          SizedBox(
            // Use SizedBox to control the width
            width: MediaQuery.of(context).size.width * 0.7, // Adjust 0.7 as needed for desired width
            child: ElevatedButton(
              onPressed: () {
                // Dismiss the dialog
                Navigator.pop(context);
                // FIX: Simply pop the BookingFormScreen off the stack.
                // This will return to the previous screen (e.g., RoomListScreen).
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryBlue, // Use your primary blue color
                foregroundColor: kWhite, // Text color for the button
                padding: const EdgeInsets.symmetric(vertical: 15), // Adjust padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                elevation: 5, // Add a subtle shadow
              ),
              child: const Text(
                'Book Now', // Changed button text
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for confirmation dialog rows
  Widget _buildConfirmationRow(String label, String value,
      {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? kDarkBlue, // Use provided color or default to kDarkBlue
              fontSize: isBold ? 18 : 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color ?? Colors.black87,
                fontSize: isBold ? 18 : 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Step> _buildSteps() {
    return [
      Step(
        title: const Text('Personal Info', style: TextStyle(color: kDarkBlue)),
        content: Container(
          // Wrap content in a Container for styling
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(51, 0, 0, 0), // Replaced Colors.black.withOpacity(0.2)
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            // Form for Personal Info step
            key: _personalInfoFormKey,
            child: Column(
              children: [
                _buildTextField(_firstName, 'First Name', TextInputType.name,
                    exampleText: 'e.g., John'),
                _buildTextField(_lastName, 'Last Name', TextInputType.name,
                    exampleText: 'e.g., Doe'),
                _buildTextField(_email, 'Email', TextInputType.emailAddress,
                    validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Please enter email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                    return 'Enter a valid email';
                  }
                  return null;
                }, exampleText: 'e.g., john.doe@example.com'),
                _buildTextField(_phone, 'Phone Number', TextInputType.phone,
                    validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Please enter phone number';
                  }
                  if (!RegExp(r'^[0-9]{10,15}$').hasMatch(v)) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                }, exampleText: 'e.g., 09123456789'),
              ],
            ),
          ),
        ),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Booking Info', style: TextStyle(color: kDarkBlue)),
        content: Container(
          // Wrap content in a Container for styling
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(51, 0, 0, 0), // Replaced Colors.black.withOpacity(0.2)
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            // Form for Booking Info step
            key: _bookingInfoFormKey,
            child: Column(
              children: [
                _buildDateTimeField(
                  'Arrival',
                  _checkInDate,
                  _checkInTime,
                  () => _pickDate(true),
                  () => _pickTime(true),
                ),
                _buildDateTimeField(
                  'Departure',
                  _checkOutDate,
                  _checkOutTime, // Corrected from _checkOutDate to _checkOutTime
                  () => _pickDate(false),
                  () => _pickTime(false),
                ),
                // Display number of nights and total price here
                if (_numberOfNights > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nights: $_numberOfNights',
                            style: const TextStyle(fontSize: 16, color: kDarkBlue)),
                        Text('Total Price: ₱$_totalPrice',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryBlue)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Payment & Notes', style: TextStyle(color: kDarkBlue)),
        content: Container(
          // Wrap content in a Container for styling
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(51, 0, 0, 0), // Replaced Colors.black.withOpacity(0.2)
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            // Form for Payment & Notes step
            key: _paymentNotesFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Payment Method:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: kDarkBlue),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  // Changed to DropdownButtonFormField
                  value: _selectedCardType,
                  isExpanded: true,
                  decoration: _inputBox('Card Type').copyWith(
                    prefixIcon: const Icon(Icons.credit_card, color: kDarkBlue),
                  ),
                  items: <String>[
                    'Visa',
                    'Mastercard',
                    'AMEX',
                    'Discover',
                    'Paypal'
                  ] // Added Paypal here
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCardType = newValue!;
                      // If Paypal is selected, no need for card details
                      if (_selectedCardType == 'Paypal') {
                        _cardNumber.clear();
                        _cardExpiry.clear();
                        _cardCVV.clear();
                        _cardholderName.clear();
                      }
                    });
                  },
                  dropdownColor: kLightBlue,
                  style: const TextStyle(color: kDarkBlue),
                ),
                if (_selectedCardType != 'Paypal') ...[
                  // Conditionally show card fields
                  const SizedBox(height: 10),
                  _buildTextField(_cardNumber, 'Card Number', TextInputType.number,
                      validator: (v) {
                    if (v == null || v.isEmpty) return 'Please enter card number';
                    if (!RegExp(r'^[0-9]{16}$').hasMatch(v)) {
                      return 'Enter a valid 16-digit card number';
                    }
                    return null;
                  }, exampleText: 'e.g., XXXX XXXX XXXX XXXX'), // Updated example
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                            _cardExpiry,
                            'Expiry Date', // Changed label
                            TextInputType.datetime, validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Please enter expiry date';
                          }
                          if (!RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$')
                              .hasMatch(v)) {
                            return 'Enter a valid MM/YY format';
                          }
                          return null;
                        }, exampleText: 'MM/YY'), // Updated example
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildTextField(_cardCVV, 'CVV', TextInputType.number,
                            validator: (v) {
                          if (v == null || v.isEmpty) return 'Please enter CVV';
                          if (!RegExp(r'^[0-9]{3,4}$').hasMatch(v)) {
                            return 'Enter a valid 3 or 4 digit CVV';
                          }
                          return null;
                        }, exampleText: 'XXX'), // Updated example
                      ),
                    ],
                  ),
                  _buildTextField(
                      _cardholderName, 'Cardholder Name', TextInputType.name,
                      validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Please enter cardholder name';
                    }
                    return null;
                  }, exampleText: 'e.g., John Doe'), // New field and example
                ],
                const SizedBox(height: 10),
                _buildTextField(_requests, 'Special Requests (Optional)',
                    TextInputType.multiline,
                    maxLines: 3,
                    validator: (v) => null,
                    exampleText: 'e.g., Early check-in, extra towels'),
              ],
            ),
          ),
        ),
        isActive: _currentStep >= 2,
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booking Form', // Changed to static title
          style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: kWhite),
        backgroundColor: kPrimaryBlue, // Changed to kPrimaryBlue
        elevation: 0, // Removed shadow
      ),
      backgroundColor: kLightBlue, // Changed to kLightBlue
      body: Form(
        key: _formKey, // Keep the main form key for overall form context if needed, but step validation will use specific keys
        child: Column(
          // Use Column instead of SingleChildScrollView directly for better control
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0), // Added padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Room Image
if (widget.roomImagePath.isNotEmpty)
  Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12), // Rounded corners for the image container
      boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(51, 0, 0, 0), // Shadow for depth
          spreadRadius: 2,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: ClipRRect( // Clips the image to the rounded corners
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        widget.roomImagePath,
        height: 200, // Fixed height for the image
        width: double.infinity, // Image takes full width
        fit: BoxFit.cover, // Ensures image covers the area, cropping if necessary
        // ... errorBuilder for missing image
      ),
    ),
  ),
const SizedBox(height: 20), // Spacing below the image

// Room Type and Price
Text(
  widget.roomType, // Displays "Heritage Deluxe Room"
  style: const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: kDarkBlue,
  ),
),
const SizedBox(height: 8), // Spacing between room type and price
Text(
  '₱${widget.price} / night', // Displays "₱2800 / night"
  style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: kPrimaryBlue,
  ),
),
const SizedBox(height: 15), // Spacing below the price

// Room Description
Text(
  widget.roomDescription, // Displays the room description
  style: TextStyle(color: Colors.grey[700], fontSize: 15),
),
const SizedBox(height: 20), // Spacing below the description

                    // Amenities
if (widget.amenities.isNotEmpty) // Only show if amenities exist
  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Amenities', // "Amenities" title
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kDarkBlue),
      ),
      const SizedBox(height: 10), // Spacing below the title
      Wrap( // Arranges amenity items with wrapping behavior
        spacing: 15, // Horizontal spacing between items
        runSpacing: 15, // Vertical spacing between lines of items
        children: widget.amenities
            .map((a) => _AmenityDisplayIcon(amenity: a)) // Maps each amenity to a custom widget
            .toList(),
      ),
    ],
  ),
const SizedBox(height: 20), // Spacing below amenities

                    // Stepper for Booking Form
                    Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                              primary: kPrimaryBlue, // Active step color
                              onSurface: Colors.grey
                                  .shade600, // Inactive step content color (adjusted for lighter grey)
                            ),
                        canvasColor:
                            Colors.transparent, // Transparent background for stepper
                        shadowColor: Colors.transparent, // Remove shadow from stepper
                      ),
                      child: Stepper(
                        type: StepperType.vertical,
                        currentStep: _currentStep,
                        onStepContinue: () {
                          bool isCurrentStepValid = false;
                          // Validate the current step's form based on _currentStep
                          if (_currentStep == 0) {
                            if (_personalInfoFormKey.currentState!.validate()) {
                              isCurrentStepValid = true;
                            }
                          } else if (_currentStep == 1) {
                            if (_bookingInfoFormKey.currentState!.validate()) {
                              if (_checkInDate == null || _checkOutDate == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please select both check-in and check-out dates.')),
                                );
                                isCurrentStepValid = false;
                              } else if (_checkOutDate!.isBefore(_checkInDate!)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Check-out date cannot be before check-in date.')),
                                );
                                isCurrentStepValid = false;
                              } else {
                                isCurrentStepValid = true;
                              }
                            }
                          } else if (_currentStep == 2) {
                            if (_paymentNotesFormKey.currentState!.validate()) {
                              isCurrentStepValid = true;
                            }
                          }

                          if (isCurrentStepValid) {
                            if (_currentStep < _buildSteps().length - 1) {
                              setState(() {
                                _currentStep += 1;
                              });
                            } else {
                              // Last step, submit the form
                              _submitForm();
                            }
                          }
                        },
                        onStepCancel: () {
                          if (_currentStep > 0) {
                            setState(() {
                              _currentStep -= 1;
                            });
                          }
                        },
                        steps: _buildSteps(),
                        controlsBuilder: (context, details) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: details.onStepContinue,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kPrimaryBlue,
                                      foregroundColor: kWhite,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(_currentStep == _buildSteps().length - 1
                                        ? 'Confirm Booking'
                                        : 'Next'),
                                  ),
                                ),
                                if (_currentStep > 0)
                                  const SizedBox(width: 10),
                                if (_currentStep > 0)
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: details.onStepCancel,
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: kPrimaryBlue,
                                        side: const BorderSide(color: kPrimaryBlue),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text('Back'),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmenityDisplayIcon extends StatelessWidget {
  final Amenity amenity;

  const _AmenityDisplayIcon({required this.amenity});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kLightBlue, // Light blue background for amenity icons
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(amenity.icon, color: kPrimaryBlue, size: 28),
        ),
        const SizedBox(height: 5),
        Text(
          amenity.label,
          style: const TextStyle(fontSize: 12, color: kDarkBlue),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}