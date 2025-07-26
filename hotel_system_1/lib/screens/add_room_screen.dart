import 'package:flutter/material.dart';
import '../utils/constants.dart'; // This might contain kPrimaryGreen, kDarkText. We'll replace them.
import '../models/room.dart'; // Import the new Room model
import '../screens/room_manager.dart'; // Import the RoomManager
import '../models/amenity.dart'; // Import the canonical Amenity model
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/hotel_manager.dart'; // Import HotelManager for debug print

// Re-defining AppColors here for clarity within this file,
// or ensure it's accessible from a common constants file if preferred.
// Assuming AppColors is defined in admin_dashboard.dart, you might
// want to move it to a shared file (e.g., app_colors.dart) and import it.
// For now, I'll include it here for a self-contained solution.
class AppColors {
  static const Color sapphire = Color(0xFF3C5070);
  static const Color royalBlue = Color(0xFF112250);
  static const Color quicksand = Color(0xFFE0C58F);
  static const Color swanWing = Color(0xFFF5F0E9);
  static const Color shellstone = Color(0xFFD9CBC2);
}

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
  final TextEditingController _roomImagePathController =
      TextEditingController();

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
        currentHotelName =
            prefs.getString('loggedInHotelName') ?? 'Default Hotel';
      }

      // Check for duplicate room names within the context of the current hotel
      if (RoomManager().rooms.any(
        (room) =>
            room.hotelName == currentHotelName &&
            room.name.toLowerCase() == roomName.toLowerCase(),
      )) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Room "$roomName" already exists for $currentHotelName. Please choose a different name.',
              style: const TextStyle(
                color: AppColors.swanWing,
              ), // Use Swan Wing for text
            ),
            backgroundColor:
                AppColors.royalBlue, // Use Royal Blue for background
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
      final hotels = HotelManager().hotels.where(
        (h) => h.name == currentHotelName,
      );
      if (hotels.isNotEmpty) {
        print(
          'Current rooms for hotel $currentHotelName: ' +
              hotels.first.rooms.map((r) => r.name).toList().toString(),
        );
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
          content: Text(
            'Room "$roomName" added successfully to $currentHotelName!',
            style: const TextStyle(color: AppColors.swanWing),
          ), // Use Swan Wing for text
          backgroundColor: AppColors.sapphire, // Use Sapphire for background
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
              color: AppColors.royalBlue, // Use Royal Blue for heading
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: AppColors.swanWing, // Card background color
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextFormField(
                      controller: _roomNameController,
                      labelText: 'Room Name (e.g., Room 101, Suite A)',
                      icon: Icons.label,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a room name';
                        }
                        final String currentHotelName =
                            widget.hotelName ?? 'Default Hotel';
                        if (RoomManager().rooms.any(
                          (room) =>
                              room.hotelName == currentHotelName &&
                              room.name.toLowerCase() ==
                                  value.trim().toLowerCase(),
                        )) {
                          return 'This room name already exists for $currentHotelName.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _roomTypeController,
                      labelText: 'Room Type (e.g., Standard, Deluxe, Suite)',
                      icon: Icons.category,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a room type';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _roomCapacityController,
                      labelText: 'Capacity (Number of Guests)',
                      icon: Icons.people,
                      keyboardType: TextInputType.number,
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
                    _buildTextFormField(
                      controller: _priceController,
                      labelText: 'Price per Night',
                      keyboardType: TextInputType.number,
                      prefixText: '₱',
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
                    _buildTextFormField(
                      controller: _descriptionController,
                      labelText: 'Room Description',
                      icon: Icons.description,
                      maxLines: 3,
                      alignLabelWithHint: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a room description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _roomImagePathController,
                      labelText: 'Room Image URL (Optional)',
                      icon: Icons.image,
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Amenities',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors
                              .royalBlue, // Use Royal Blue for amenities heading
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
                              Icon(
                                amenity.icon,
                                size: 18,
                                color: isSelected
                                    ? AppColors.royalBlue
                                    : AppColors.sapphire,
                              ), // Royal Blue for selected icon, Sapphire for unselected
                              const SizedBox(width: 4),
                              Text(
                                amenity.label,
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.royalBlue
                                      : AppColors.sapphire,
                                ),
                              ), // Royal Blue for selected label, Sapphire for unselected
                            ],
                          ),
                          selected: isSelected,
                          selectedColor: AppColors.quicksand.withOpacity(
                            0.4,
                          ), // Quicksand with opacity when selected
                          checkmarkColor:
                              AppColors.royalBlue, // Royal Blue for checkmark
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedAmenities.add(amenity);
                              } else {
                                _selectedAmenities.remove(amenity);
                              }
                            });
                          },
                          backgroundColor: AppColors.shellstone.withOpacity(
                            0.5,
                          ), // Shellstone with opacity for background
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppColors.royalBlue
                                : AppColors.sapphire,
                          ), // Consistent with icon and label
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.royalBlue
                                : AppColors
                                      .shellstone, // Border color based on selection
                            width: 1,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _addRoom,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors
                              .royalBlue, // Royal Blue for button background
                          foregroundColor: AppColors
                              .swanWing, // Swan Wing for button text/icon
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.add),
                        label: const Text(
                          'Add Room',
                          style: TextStyle(fontSize: 18),
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

  // Helper widget for consistent TextFormField styling
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool alignLabelWithHint = false,
    String? Function(String?)? validator,
    String? prefixText,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: AppColors.sapphire,
        ), // Sapphire for label text
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.shellstone,
          ), // Shellstone for border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.shellstone,
          ), // Shellstone for enabled border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.royalBlue,
            width: 2,
          ), // Royal Blue for focused border
        ),
        prefixIcon: icon != null
            ? Icon(
                icon,
                color: AppColors.royalBlue,
              ) // Royal Blue for prefix icons
            : (prefixText != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: Text(
                        prefixText,
                        style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.royalBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // Royal Blue for prefix text
                    )
                  : null),
        prefixIconConstraints: icon != null
            ? null
            : const BoxConstraints(minWidth: 0, minHeight: 0),
        alignLabelWithHint: alignLabelWithHint,
        filled: true,
        fillColor: AppColors.swanWing.withOpacity(0.7), // Subtle Swan Wing fill
      ),
      style: const TextStyle(
        color: AppColors.royalBlue,
      ), // Royal Blue for input text
      cursorColor: AppColors.royalBlue, // Royal Blue for cursor
      validator: validator,
    );
  }
}
