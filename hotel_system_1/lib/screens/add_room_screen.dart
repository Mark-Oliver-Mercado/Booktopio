import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/room.dart'; // Import the new Room model
import '../screens/room_manager.dart'; // Import the RoomManager
import '../models/amenity.dart'; // Import the canonical Amenity model
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/hotel_manager.dart'; // Import HotelManager for debug print

class AddRoomScreenContent extends StatefulWidget {
  final String? hotelName; // New parameter to receive the current hotel name

  const AddRoomScreenContent({
    Key? key,
    this.hotelName, // Make it optional for now, but ideally required
  }) : super(key: key);

  @override
  _AddRoomScreenContentState createState() => _AddRoomScreenContentState();
}

class _AddRoomScreenContentState extends State<AddRoomScreenContent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _roomTypeController = TextEditingController();
  final TextEditingController _roomCapacityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _roomImagePathController = TextEditingController();

  List<Amenity> _selectedAmenities = [];

  final List<Amenity> _amenities = [
    const Amenity(icon: Icons.wifi, label: 'Wi-Fi'),
    const Amenity(icon: Icons.ac_unit, label: 'Air Conditioning'),
    const Amenity(icon: Icons.tv, label: 'TV'),
    const Amenity(icon: Icons.local_bar, label: 'Mini Bar'),
    const Amenity(icon: Icons.balcony, label: 'Balcony'),
    const Amenity(icon: Icons.breakfast_dining, label: 'Breakfast Included'),
  ];

  @override
  void dispose() {
    _roomNameController.dispose();
    _roomTypeController.dispose();
    _roomCapacityController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _roomImagePathController.dispose();
    super.dispose();
  }

  void _addRoom() async {
    if (_formKey.currentState!.validate()) {
      final String roomName = _roomNameController.text.trim();
      String currentHotelName = widget.hotelName ?? '';
      if (currentHotelName.isEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        currentHotelName = prefs.getString('loggedInHotelName') ?? 'Default Hotel';
      }

      // Check for duplicate room names within the context of the current hotel
      if (RoomManager().rooms.any((room) =>
          room.hotelName == currentHotelName &&
          room.name.toLowerCase() == roomName.toLowerCase())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Room "$roomName" already exists for $currentHotelName. Please choose a different name.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final newRoom = Room(
        hotelName: currentHotelName, // Use the dynamically passed hotelName
        name: roomName,
        type: _roomTypeController.text.trim(),
        capacity: int.parse(_roomCapacityController.text.trim()),
        pricePerNight: double.parse(_priceController.text.trim()),
        description: _descriptionController.text.trim(),
        imagePath: _roomImagePathController.text.trim().isNotEmpty
            ? _roomImagePathController.text.trim()
            : null,
        features: 'Added by Admin', // Placeholder for features
        amenities: List<Amenity>.from(_selectedAmenities),
        status: 'Available',
      );

      RoomManager().addRoom(newRoom);
      // Debug print: show which hotel and its rooms
      print('Added room to hotel: ' + currentHotelName);
      final hotels = HotelManager().hotels.where((h) => h.name == currentHotelName);
      if (hotels.isNotEmpty) {
        print('Current rooms for hotel $currentHotelName: ' + hotels.first.rooms.map((r) => r.name).toList().toString());
      } else {
        print('Hotel $currentHotelName not found in HotelManager');
      }

      _roomNameController.clear();
      _roomTypeController.clear();
      _roomCapacityController.clear();
      _priceController.clear();
      _descriptionController.clear();
      _roomImagePathController.clear();
      setState(() {
        _selectedAmenities = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Room "$roomName" added successfully to $currentHotelName!'),
          backgroundColor: kPrimaryGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                        final String currentHotelName = widget.hotelName ?? 'Default Hotel';
                        if (RoomManager().rooms.any((room) =>
                            room.hotelName == currentHotelName &&
                            room.name.toLowerCase() == value.trim().toLowerCase())) {
                          return 'This room name already exists for $currentHotelName.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
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
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price per Night',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 8),
                          child: Text('₱', style: TextStyle(fontSize: 20, color: kPrimaryGreen, fontWeight: FontWeight.bold)),
                        ),
                        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
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
                    TextFormField(
                      controller: _roomImagePathController,
                      decoration: InputDecoration(
                        labelText: 'Room Image URL (Optional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.image, color: kPrimaryGreen),
                      ),
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 8),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Amenities',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kDarkText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: _amenities.map((amenity) {
                        final isSelected = _selectedAmenities.contains(amenity);
                        return FilterChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(amenity.icon, size: 18, color: isSelected ? kPrimaryGreen : Colors.grey),
                              const SizedBox(width: 4),
                              Text(amenity.label),
                            ],
                          ),
                          selected: isSelected,
                          selectedColor: kPrimaryGreen.withOpacity(0.15),
                          checkmarkColor: kPrimaryGreen,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedAmenities.add(amenity);
                              } else {
                                _selectedAmenities.remove(amenity);
                              }
                            });
                          },
                          backgroundColor: Colors.grey[100],
                          labelStyle: TextStyle(color: isSelected ? kPrimaryGreen : kDarkText),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: isSelected ? kPrimaryGreen : Colors.grey.shade300),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
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
        ],
      ),
    );
  }
}
