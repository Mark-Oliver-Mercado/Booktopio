import 'package:flutter/material.dart';

// Define the colors used in your AdminDashboard for consistency
const Color kPrimaryGreen = Color(0xFF2E7D32); // App bar green
const Color kLightGreen = Color(0xFFE8F5E9); // Light green for accents/backgrounds
const Color kDarkText = Color(0xFF333333); // Dark text color

class AddRoomScreen extends StatefulWidget {
  final VoidCallback onRoomAdded;
  // Add a list of existing room names for validation
  final List<String> existingRoomNames;

  const AddRoomScreen({
    Key? key,
    required this.onRoomAdded,
    required this.existingRoomNames, // New required parameter
  }) : super(key: key);

  @override
  _AddRoomScreenState createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _roomTypeController = TextEditingController();
  final TextEditingController _roomCapacityController = TextEditingController();

  @override
  void dispose() {
    _roomNameController.dispose();
    _roomTypeController.dispose();
    _roomCapacityController.dispose();
    super.dispose();
  }

  void _addRoom() {
    if (_formKey.currentState!.validate()) {
      final String roomName = _roomNameController.text.trim();
      final String roomType = _roomTypeController.text.trim();
      final int? roomCapacity = int.tryParse(_roomCapacityController.text.trim());

      ('Adding Room: $roomName, Type: $roomType, Capacity: $roomCapacity'); // Avoid print in production code

      // Notify the AdminDashboard that a room has been added.
      // In a real app, this would return the actual new room name from a backend.
      // For this example, we'll just indicate a room was added, and AdminDashboard
      // will generate a new dummy name for its static list.
      widget.onRoomAdded();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Room "$roomName" added successfully!'),
          backgroundColor: kPrimaryGreen,
        ),
      );

      _roomNameController.clear();
      _roomTypeController.clear();
      _roomCapacityController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Room',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kPrimaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Room Details',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: kDarkText,
                ),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _roomNameController,
                decoration: InputDecoration(
                  labelText: 'Room Name (e.g., Suite 301)',
                  hintText: 'Enter unique room name',
                  prefixIcon: Icon(Icons.meeting_room, color: kPrimaryGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a room name';
                  }
                  // Now access existing room names via widget.existingRoomNames
                  if (widget.existingRoomNames.contains(value.trim())) {
                    return 'This room name already exists.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _roomTypeController,
                decoration: InputDecoration(
                  labelText: 'Room Type (e.g., Standard, Deluxe, Suite)',
                  hintText: 'Enter room type',
                  prefixIcon: Icon(Icons.category, color: kPrimaryGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a room type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _roomCapacityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Room Capacity (Number of Guests)',
                  hintText: 'e.g., 2, 4',
                  prefixIcon: Icon(Icons.people, color: kPrimaryGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter room capacity';
                  }
                  if (int.tryParse(value.trim()) == null || int.parse(value.trim()) <= 0) {
                    return 'Please enter a valid number greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addRoom,
                  icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                  label: const Text(
                    'Add Room',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}