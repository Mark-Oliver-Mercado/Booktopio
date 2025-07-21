import 'package:flutter/material.dart';

// Define the colors used in your AdminDashboard for consistency
const Color kPrimaryGreen = Color(0xFF2E7D32); // App bar green
const Color kLightGreen = Color(
  0xFFE8F5E9,
); // Light green for accents/backgrounds
const Color kDarkText = Color(0xFF333333); // Dark text color

// Renamed from AddRoomScreen to AddRoomScreenContent
// MODIFIED: This is now just the content, not a full Scaffold
class AddRoomScreenContent extends StatefulWidget {
  final ValueChanged<String> onRoomAdded;
  final List<String> existingRoomNames;

  const AddRoomScreenContent({
    Key? key,
    required this.onRoomAdded,
    required this.existingRoomNames,
  }) : super(key: key);

  @override
  _AddRoomScreenContentState createState() => _AddRoomScreenContentState(); // State class name changed
}

class _AddRoomScreenContentState extends State<AddRoomScreenContent> {
  // State class name changed
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _roomTypeController = TextEditingController();
  final TextEditingController _roomCapacityController = TextEditingController();
  final TextEditingController _priceController =
      TextEditingController(); // Added price controller
  final TextEditingController _descriptionController =
      TextEditingController(); // Added description controller
  String? _selectedAmenity; // Added for radio buttons

  final List<String> _amenities = [
    'Wi-Fi',
    'Air Conditioning',
    'TV',
    'Mini Bar',
    'Balcony',
    'Breakfast Included',
  ]; // Example amenities

  @override
  void dispose() {
    _roomNameController.dispose();
    _roomTypeController.dispose();
    _roomCapacityController.dispose();
    _priceController.dispose(); // Dispose price controller
    _descriptionController.dispose(); // Dispose description controller
    super.dispose();
  }

  void _addRoom() {
    if (_formKey.currentState!.validate()) {
      final String roomName = _roomNameController.text.trim();

      // Check for duplicate room names
      if (widget.existingRoomNames.contains(roomName)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Room "$roomName" already exists. Please choose a different name.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // You can access the new fields here:
      // String imageUrl = _imageController.text; // If you add an image URL field
      // double price = double.parse(_priceController.text);
      // String description = _descriptionController.text;
      // String? selectedAmenity = _selectedAmenity;

      widget.onRoomAdded(roomName); // Call the callback
      _roomNameController.clear();
      _roomTypeController.clear();
      _roomCapacityController.clear();
      _priceController.clear(); // Clear price
      _descriptionController.clear(); // Clear description
      setState(() {
        _selectedAmenity = null; // Clear selected amenity
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Room "$roomName" added successfully!'),
          backgroundColor: kPrimaryGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Changed from Scaffold to SingleChildScrollView
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add New Room',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: kDarkText,
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Room Name
                    TextFormField(
                      controller: _roomNameController,
                      decoration: InputDecoration(
                        labelText: 'Room Name (e.g., Room 101, Suite A)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.label, color: kPrimaryGreen),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a room name';
                        }
                        if (widget.existingRoomNames.contains(value.trim())) {
                          return 'This room name already exists.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Room Type
                    TextFormField(
                      controller: _roomTypeController,
                      decoration: InputDecoration(
                        labelText: 'Room Type (e.g., Standard, Deluxe, Suite)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.category, color: kPrimaryGreen),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a room type';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Capacity
                    TextFormField(
                      controller: _roomCapacityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Capacity (Number of Guests)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.people, color: kPrimaryGreen),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter room capacity';
                        }
                        if (int.tryParse(value) == null ||
                            int.parse(value) <= 0) {
                          return 'Please enter a valid number greater than 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Price
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price per Night',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(
                          Icons.attach_money,
                          color: kPrimaryGreen,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the price';
                        }
                        if (double.tryParse(value) == null ||
                            double.parse(value) <= 0) {
                          return 'Please enter a valid price greater than 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Room Description',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(
                          Icons.description,
                          color: kPrimaryGreen,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a room description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Image Upload (Placeholder - actual implementation would be more complex)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Room Image',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kDarkText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // This is a placeholder for image upload.
                        // In a real app, you'd use image_picker or similar.
                        Container(
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: kLightGreen,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: kPrimaryGreen),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_upload,
                                  size: 40,
                                  color: kPrimaryGreen,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap to upload image',
                                  style: TextStyle(color: kPrimaryGreen),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Amenities (Radio Buttons)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amenities',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kDarkText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._amenities.map((amenity) {
                          return RadioListTile<String>(
                            title: Text(amenity),
                            value: amenity,
                            groupValue: _selectedAmenity,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedAmenity = value;
                              });
                            },
                            activeColor: kPrimaryGreen,
                          );
                        }).toList(),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Add Room Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _addRoom,
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'Add Room',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // You might add a list of recently added rooms here or a confirmation message
        ],
      ),
    );
  }
}
