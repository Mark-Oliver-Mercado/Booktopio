import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Controllers
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _street1 = TextEditingController();
  final _street2 = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _zip = TextEditingController();
  final _adults = TextEditingController();
  final _kids = TextEditingController();
  final _requests = TextEditingController();
  final _cardNumber = TextEditingController();
  final _cardExpiry = TextEditingController();
  final _cardCVV = TextEditingController();

  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  TimeOfDay? _checkInTime = TimeOfDay.now();
  TimeOfDay? _checkOutTime = TimeOfDay.now();

  String _paymentMethod = 'Paypal';

  // Helper functions
  Future<void> _pickDate(bool isCheckIn) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
        } else {
          _checkOutDate = picked;
        }
      });
    }
  }

  Future<void> _pickTime(bool isCheckIn) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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

  InputDecoration _inputBox(String label) => InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      );

  Widget _buildTextField(TextEditingController controller, String label, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        validator: (v) => v == null || v.isEmpty ? 'Please enter $label' : null,
        decoration: _inputBox(label),
      ),
    );
  }

  Widget _buildDateTimeField(String label, DateTime? date, TimeOfDay? time,
      VoidCallback onDateTap, VoidCallback onTimeTap) {
    final dateStr = date != null ? DateFormat('yyyy-MM-dd').format(date) : 'Select Date';
    final timeStr = time != null ? time.format(context) : 'Select Time';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onDateTap,
                child: InputDecorator(decoration: _inputBox('Date'), child: Text(dateStr)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: InkWell(
                onTap: onTimeTap,
                child: InputDecorator(decoration: _inputBox('Time'), child: Text(timeStr)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _checkInDate != null &&
        _checkOutDate != null &&
        _checkInTime != null &&
        _checkOutTime != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Booking Confirmed'),
          content: Text(
            'Thanks, ${_firstName.text} ${_lastName.text}!\n'
            'Check-in: ${DateFormat('yMMMd').format(_checkInDate!)} at ${_checkInTime!.format(context)}\n'
            'Check-out: ${DateFormat('yMMMd').format(_checkOutDate!)} at ${_checkOutTime!.format(context)}\n'
            'Adults: ${_adults.text}, Kids: ${_kids.text}\nPayment: $_paymentMethod',
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields.')),
      );
    }
  }

  List<Step> _buildSteps() {
    return [
      Step(
        title: const Text('Personal Info'),
        content: Column(
          children: [
            _buildTextField(_firstName, 'First Name', TextInputType.name),
            _buildTextField(_lastName, 'Last Name', TextInputType.name),
            _buildTextField(_email, 'Email', TextInputType.emailAddress),
            _buildTextField(_phone, 'Phone Number', TextInputType.phone),
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: const Text('Address'),
        content: Column(
          children: [
            _buildTextField(_street1, 'Street Address', TextInputType.streetAddress),
            _buildTextField(_street2, 'Street Address Line 2', TextInputType.streetAddress),
            _buildTextField(_city, 'City', TextInputType.text),
            _buildTextField(_state, 'State / Province', TextInputType.text),
            _buildTextField(_zip, 'Postal / Zip Code', TextInputType.text),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: const Text('Booking Info'),
        content: Column(
          children: [
            _buildDateTimeField('Arrival', _checkInDate, _checkInTime,
                () => _pickDate(true), () => _pickTime(true)),
            _buildDateTimeField('Departure', _checkOutDate, _checkOutTime,
                () => _pickDate(false), () => _pickTime(false)),
            _buildTextField(_adults, 'Number of Adults', TextInputType.number),
            _buildTextField(_kids, 'Number of Kids', TextInputType.number),
          ],
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: const Text('Payment & Notes'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Payment Method:', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Radio<String>(
                  value: 'Paypal',
                  groupValue: _paymentMethod,
                  onChanged: (value) => setState(() => _paymentMethod = value!),
                ),
                const Text('Paypal'),
                Radio<String>(
                  value: 'Credit Card',
                  groupValue: _paymentMethod,
                  onChanged: (value) => setState(() => _paymentMethod = value!),
                ),
                const Text('Credit Card'),
              ],
            ),
            if (_paymentMethod == 'Credit Card') ...[
              _buildTextField(_cardNumber, 'Card Number', TextInputType.number),
              _buildTextField(_cardExpiry, 'Expiry Date (MM/YY)', TextInputType.datetime),
              _buildTextField(_cardCVV, 'CVV', TextInputType.number),
            ],
            const SizedBox(height: 10),
            TextFormField(
              controller: _requests,
              maxLines: 3,
              decoration: _inputBox('Special Requests'),
            ),
          ],
        ),
        isActive: _currentStep >= 3,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Form', style: TextStyle(color: Color(0xFF5D4037))),
        iconTheme: const IconThemeData(color: Color(0xFF5D4037)),
        backgroundColor: const Color(0xFFFFCCBC),
      ),
      backgroundColor: const Color(0xFFFBE9E7),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (widget.roomImagePath.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(widget.roomImagePath,
                      height: 180, width: double.infinity, fit: BoxFit.cover),
                ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(widget.roomDescription,
                    style: TextStyle(color: Colors.grey[700], fontSize: 14)),
              ),
              const SizedBox(height: 10),
              if (widget.amenities.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Amenities',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 12,
                        runSpacing: 10,
                        children: widget.amenities
                            .map((a) => _AmenityDisplayIcon(amenity: a))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              Text(
  'Room Price: ₱${widget.price} / night',
  style: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFF4E342E),
  ),
),

const SizedBox(height: 10),
              Stepper(
                type: StepperType.vertical,
                currentStep: _currentStep,
                onStepContinue: () {
                  if (_currentStep < _buildSteps().length - 1) {
                    setState(() => _currentStep += 1);
                  } else {
                    _submitForm();
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() => _currentStep -= 1);
                  }
                },
                steps: _buildSteps(),
                controlsBuilder: (context, details) {
                  return Row(
                    children: [
                      ElevatedButton(
                        onPressed: details.onStepContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                        ),
                        child: Text(
                          _currentStep == _buildSteps().length - 1 ? 'Submit' : 'Next',
                        ),
                      ),
                      if (_currentStep > 0)
                        TextButton(
                          onPressed: details.onStepCancel,
                          child: const Text('Back'),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
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
        Icon(amenity.icon, size: 28, color: Colors.teal),
        const SizedBox(height: 4),
        Text(amenity.label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
