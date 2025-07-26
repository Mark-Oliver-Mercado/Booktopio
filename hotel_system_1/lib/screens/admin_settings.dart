import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../screens/hotel_manager.dart'; // Import HotelManager
import '../models/hotel.dart'; // Import Hotel model
import '../models/amenity.dart'; // Import Amenity model

class AdminSettingsScreenContent extends StatefulWidget {
  final String? loggedInHotelName; // New parameter to receive the hotel name

  const AdminSettingsScreenContent({Key? key, this.loggedInHotelName})
    : super(key: key);

  @override
  State<AdminSettingsScreenContent> createState() =>
      _AdminSettingsScreenContentState();
}

class _AdminSettingsScreenContentState
    extends State<AdminSettingsScreenContent> {
  bool _isAccountInfoExpanded = false;
  bool _isHotelInfoExpanded = false; // New state for Hotel Info
  bool _isNotificationsExpanded = false;
  bool _isAboutAppExpanded = false;
  bool _isDarkModeEnabled = false;
  // New state for global features

  // State to control edit mode for account information
  bool _isEditingAccount = false;
  // State to control edit mode for hotel information
  bool _isEditingHotel = false;

  // Current values for account info (will be displayed statically)
  String _currentUsername = 'admin_user';
  String _currentEmail = 'admin@booktopia.com';

  // Current values for hotel info (will be displayed statically or fetched)
  Hotel? _currentHotel; // To hold the hotel data

  // Controllers for editing account info
  late TextEditingController _editUsernameController;
  late TextEditingController _editEmailController;

  // Controllers for editing hotel info
  late TextEditingController _editHotelNameController;
  late TextEditingController _editHotelAddressController;
  late TextEditingController _editContactNumberController;
  late TextEditingController _editHotelDescriptionController;
  late TextEditingController _editLicenseNumberController;
  late TextEditingController _editRoomCountController;
  late TextEditingController _editHotelImageController;
  late TextEditingController _editPriceRangeController;

  // Controllers for managing global categories and amenities
  late TextEditingController _newCategoryController;
  late TextEditingController _newAmenityLabelController;
  IconData? _selectedAmenityIcon; // To hold the selected icon for new amenity

  // Lists for interactive word pools (categories and amenities)
  List<String> _editedCategories = []; // Hotel-specific categories
  List<Amenity> _editedAmenities =
      []; // Hotel-specific amenities (Amenity objects)

  // List of all Material Icons (a subset for practical use)
  final Map<String, IconData> _allMaterialIcons = {
    'wifi': Icons.wifi, 'pool': Icons.pool, 'beach_access': Icons.beach_access,
    'spa': Icons.spa,
    'restaurant': Icons.restaurant,
    'local_parking': Icons.local_parking,
    'fitness_center': Icons.fitness_center,
    'ac_unit': Icons.ac_unit,
    'tv': Icons.tv,
    'local_bar': Icons.local_bar,
    'balcony': Icons.balcony,
    'breakfast_dining': Icons.breakfast_dining,
    'fireplace': Icons.fireplace, 'pets': Icons.pets, 'bathtub': Icons.bathtub,
    'room_service': Icons.room_service,
    'dry_cleaning': Icons.dry_cleaning,
    'airport_shuttle': Icons.airport_shuttle,
    'desk': Icons.desk,
    'kitchen': Icons.kitchen,
    'accessible_forward': Icons.accessible_forward,
    'hiking': Icons.hiking,
    'nature': Icons.nature,
    'business_center': Icons.business_center,
    'hotel': Icons.hotel,
    'meeting_room': Icons.meeting_room,
    'single_bed': Icons.single_bed,
    'family_restroom': Icons.family_restroom,
    'wine_bar': Icons.wine_bar,
    'eco': Icons.eco,
    'scuba_diving': Icons.scuba_diving,
    'wb_sunny': Icons.wb_sunny,
    'directions_boat': Icons.directions_boat,
    'lock': Icons.lock, 'palette': Icons.palette, 'brush': Icons.brush,
    'outdoor_grill': Icons.outdoor_grill,
    'deck': Icons.deck,
    'chair': Icons.chair,
    'book': Icons.book,
    'museum': Icons.museum,
    'location_city': Icons.location_city,
    'streetview': Icons.streetview,
    'local_laundry_service': Icons.local_laundry_service,
    'coffee': Icons.coffee,
    'print': Icons.print,
    'living_outlined': Icons.living_outlined,
    'wind_power': Icons.wind_power, 'self_improvement': Icons.self_improvement,
    // Add more as needed
  };

  @override
  void initState() {
    super.initState();
    _editUsernameController = TextEditingController(text: _currentUsername);
    _editEmailController = TextEditingController(text: _currentEmail);

    _newCategoryController = TextEditingController();
    _newAmenityLabelController = TextEditingController();
    _selectedAmenityIcon = Icons.help_outline; // Default icon

    // Initialize hotel controllers and data
    _loadHotelInfo();
  }

  @override
  void didUpdateWidget(covariant AdminSettingsScreenContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload hotel info if the loggedInHotelName changes (e.g., if a different admin logs in)
    if (widget.loggedInHotelName != oldWidget.loggedInHotelName) {
      _loadHotelInfo();
    }
  }

  void _loadHotelInfo() {
    // Find the specific hotel using the passed loggedInHotelName
    if (widget.loggedInHotelName != null && HotelManager().hotels.isNotEmpty) {
      _currentHotel = HotelManager().hotels.firstWhere(
        (hotel) => hotel.name == widget.loggedInHotelName,
        orElse: () => Hotel(
          // Provide a default/placeholder hotel if not found
          image: 'assets/placeholder_hotel.png',
          name: 'No Hotel Found',
          location: 'N/A',
          rating: '0.0',
          description: 'This hotel is not registered or found.',
          categories: [],
          amenities: [],
          priceRange: 'N/A',
        ),
      );
    } else {
      _currentHotel = null; // No hotel name provided or no hotels in manager
    }

    // Initialize controllers with current hotel data or empty strings
    _editHotelNameController = TextEditingController(
      text: _currentHotel?.name ?? '',
    );
    _editHotelAddressController = TextEditingController(
      text: _currentHotel?.location ?? '',
    );
    _editContactNumberController = TextEditingController(
      text: _currentHotel?.contactNumber ?? '',
    );
    _editHotelDescriptionController = TextEditingController(
      text: _currentHotel?.description ?? '',
    );
    _editLicenseNumberController = TextEditingController(
      text: _currentHotel?.licenseNumber ?? '',
    );
    _editRoomCountController = TextEditingController(
      text: _currentHotel?.roomCount?.toString() ?? '',
    );
    _editHotelImageController = TextEditingController(
      text: _currentHotel?.image ?? '',
    );
    _editPriceRangeController = TextEditingController(
      text: _currentHotel?.priceRange ?? '',
    );

    _editedCategories = List.from(_currentHotel?.categories ?? []);
    _editedAmenities = List.from(_currentHotel?.amenities ?? []);
  }

  @override
  void dispose() {
    _editUsernameController.dispose();
    _editEmailController.dispose();
    _editHotelNameController.dispose();
    _editHotelAddressController.dispose();
    _editContactNumberController.dispose();
    _editHotelDescriptionController.dispose();
    _editLicenseNumberController.dispose();
    _editRoomCountController.dispose();
    _editHotelImageController.dispose();
    _editPriceRangeController.dispose();
    _newCategoryController.dispose();
    _newAmenityLabelController.dispose();
    super.dispose();
  }

  void _toggleEditAccountMode() {
    setState(() {
      _isEditingAccount = !_isEditingAccount;
      if (_isEditingAccount) {
        // When entering edit mode, populate controllers with current values
        _editUsernameController.text = _currentUsername;
        _editEmailController.text = _currentEmail;
      }
    });
  }

  void _saveAccountInfo() {
    setState(() {
      _currentUsername = _editUsernameController.text.trim();
      _currentEmail = _editEmailController.text.trim();
      _isEditingAccount = false; // Exit edit mode
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Account information saved!')));
  }

  void _cancelEditAccount() {
    setState(() {
      _isEditingAccount = false; // Exit edit mode without saving
      // Reset controllers to current values
      _editUsernameController.text = _currentUsername;
      _editEmailController.text = _currentEmail;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Account edit cancelled.')));
  }

  void _toggleEditHotelMode() {
    setState(() {
      _isEditingHotel = !_isEditingHotel;
      if (_isEditingHotel) {
        // When entering edit mode, populate controllers with current hotel values
        _editHotelNameController.text = _currentHotel?.name ?? '';
        _editHotelAddressController.text = _currentHotel?.location ?? '';
        _editContactNumberController.text = _currentHotel?.contactNumber ?? '';
        _editHotelDescriptionController.text = _currentHotel?.description ?? '';
        _editLicenseNumberController.text = _currentHotel?.licenseNumber ?? '';
        _editRoomCountController.text =
            _currentHotel?.roomCount?.toString() ?? '';
        _editHotelImageController.text = _currentHotel?.image ?? '';
        _editPriceRangeController.text = _currentHotel?.priceRange ?? '';
        _editedCategories = List.from(_currentHotel?.categories ?? []);
        _editedAmenities = List.from(_currentHotel?.amenities ?? []);
      }
    });
  }

  void _saveHotelInfo() {
    setState(() {
      if (_currentHotel != null) {
        // Update the existing hotel object in HotelManager
        HotelManager().updateHotel(
          _currentHotel!,
          name: _editHotelNameController.text.trim(),
          location: _editHotelAddressController.text.trim(),
          contactNumber: _editContactNumberController.text.trim(),
          description: _editHotelDescriptionController.text.trim(),
          licenseNumber: _editLicenseNumberController.text.trim(),
          roomCount: int.tryParse(_editRoomCountController.text.trim()) ?? 0,
          image: _editHotelImageController.text.trim(),
          priceRange: _editPriceRangeController.text.trim(),
          categories: _editedCategories,
          amenities: _editedAmenities,
        );
        // Refresh the local _currentHotel to reflect changes
        // We need to find the updated hotel in the manager's list again
        _currentHotel = HotelManager().hotels.firstWhere(
          (h) => h.name == _currentHotel!.name, // Find by name or a unique ID
          orElse: () =>
              _currentHotel!, // Fallback to old if not found (shouldn't happen if update was successful)
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No hotel found to update. Please register as an owner first.',
            ),
          ),
        );
      }
      _isEditingHotel = false; // Exit edit mode
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Hotel information saved!')));
  }

  void _cancelEditHotel() {
    setState(() {
      _isEditingHotel = false; // Exit edit mode without saving
      // Reset controllers to current values
      _loadHotelInfo(); // Reload from HotelManager to revert changes
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Hotel edit cancelled.')));
  }

  // Helper method to build interactive word pool input fields for categories
  Widget _buildCategoryChipInput({
    required String labelText,
    required TextEditingController controller,
    required List<String> currentList,
    required IconData icon, // This icon is for the TextFormField prefix
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: Icon(
              icon,
              color: kDarkBlue,
            ), // Use the icon parameter here
            suffixIcon: IconButton(
              icon: const Icon(Icons.add_circle_outline, color: kPrimaryBlue),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    final newItem = controller.text.trim();
                    if (!currentList.contains(newItem)) {
                      // Avoid duplicates
                      currentList.add(newItem);
                    }
                    controller.clear(); // Clear input field after adding
                  });
                }
              },
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: validator,
          onFieldSubmitted: (value) {
            // Allows adding by pressing enter
            if (controller.text.isNotEmpty) {
              setState(() {
                final newItem = controller.text.trim();
                if (!currentList.contains(newItem)) {
                  currentList.add(newItem);
                }
                controller.clear();
              });
            }
          },
        ),
        const SizedBox(height: 10),
        // Display current items as chips
        Wrap(
          spacing: 8.0, // horizontal spacing
          runSpacing: 4.0, // vertical spacing
          children: currentList.map((item) {
            return Chip(
              label: Text(item),
              onDeleted: () {
                setState(() {
                  currentList.remove(item);
                });
              },
              deleteIcon: const Icon(Icons.cancel),
              backgroundColor: kLightBlue,
              labelStyle: const TextStyle(color: kDarkBlue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: kPrimaryBlue),
              ),
            );
          }).toList(),
        ),
        // Add a small space below the chips, useful if no validator message
        if (currentList.isEmpty &&
            _isEditingHotel) // Show validator hint only when editing and list is empty
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Please add at least one item.',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  // Helper method to build interactive word pool input fields for amenities with icon picker
  Widget _buildAmenityChipInput({
    required String labelText,
    required TextEditingController controller,
    required List<Amenity> currentList, // Now takes List<Amenity>
    required IconData icon, // This icon is for the TextFormField prefix
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: Icon(
              icon,
              color: kDarkBlue,
            ), // Use the icon parameter here
            suffixIcon: IconButton(
              icon: const Icon(Icons.add_circle_outline, color: kPrimaryBlue),
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  // Show icon picker dialog
                  final selectedIcon = await _showIconPickerDialog(context);
                  if (selectedIcon != null) {
                    setState(() {
                      final newAmenity = Amenity(
                        label: controller.text.trim(),
                        icon: selectedIcon,
                      );
                      if (!currentList.any(
                        (a) => a.label == newAmenity.label,
                      )) {
                        // Avoid duplicates by label
                        currentList.add(newAmenity);
                      }
                      controller.clear(); // Clear input field after adding
                      _selectedAmenityIcon =
                          Icons.help_outline; // Reset selected icon
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select an icon for the amenity.'),
                      ),
                    );
                  }
                }
              },
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: validator,
          onFieldSubmitted: (value) async {
            // Allows adding by pressing enter
            if (controller.text.isNotEmpty) {
              final selectedIcon = await _showIconPickerDialog(context);
              if (selectedIcon != null) {
                setState(() {
                  final newAmenity = Amenity(
                    label: controller.text.trim(),
                    icon: selectedIcon,
                  );
                  if (!currentList.any((a) => a.label == newAmenity.label)) {
                    currentList.add(newAmenity);
                  }
                  controller.clear();
                  _selectedAmenityIcon = Icons.help_outline;
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select an icon for the amenity.'),
                  ),
                );
              }
            }
          },
        ),
        const SizedBox(height: 10),
        // Display current items as chips
        Wrap(
          spacing: 8.0, // horizontal spacing
          runSpacing: 4.0, // vertical spacing
          children: currentList.map((amenity) {
            return Chip(
              avatar: Icon(amenity.icon, color: kPrimaryBlue, size: 18),
              label: Text(amenity.label),
              onDeleted: () {
                setState(() {
                  currentList.remove(amenity);
                });
              },
              deleteIcon: const Icon(Icons.cancel),
              backgroundColor: kLightBlue,
              labelStyle: const TextStyle(color: kDarkBlue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: kPrimaryBlue),
              ),
            );
          }).toList(),
        ),
        // Add a small space below the chips, useful if no validator message
        if (currentList.isEmpty &&
            _isEditingHotel) // Show validator hint only when editing and list is empty
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Please add at least one item.',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  // Dialog to pick an icon
  Future<IconData?> _showIconPickerDialog(BuildContext context) async {
    IconData? tempSelectedIcon =
        _selectedAmenityIcon; // Use a temporary variable for selection

    return showDialog<IconData?>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Select an Icon'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(dialogContext).size.width * 0.8,
              height: MediaQuery.of(dialogContext).size.height * 0.6,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6, // Adjust as needed
                  childAspectRatio: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _allMaterialIcons.length,
                itemBuilder: (context, index) {
                  final iconName = _allMaterialIcons.keys.elementAt(index);
                  final iconData = _allMaterialIcons.values.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        tempSelectedIcon =
                            iconData; // Update the temporary selected icon
                      });
                      Navigator.of(
                        dialogContext,
                      ).pop(iconData); // Pass the selected icon back
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          iconData,
                          size: 30,
                          color: tempSelectedIcon == iconData
                              ? kPrimaryBlue
                              : Colors.grey,
                        ),
                        Text(
                          iconName.replaceAll(
                            '_',
                            '\n',
                          ), // Display name, break long words
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 8,
                            color: tempSelectedIcon == iconData
                                ? kPrimaryBlue
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(null); // Return null if cancelled
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: kPrimaryBlue.withOpacity(
                      0.15,
                    ), // Changed to kPrimaryBlue
                    child: Icon(
                      Icons.admin_panel_settings,
                      size: 40,
                      color: kPrimaryBlue,
                    ), // Changed to kPrimaryBlue
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Admin Settings',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: kDarkText,
                    ),
                  ),
                  Text(
                    _currentEmail,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 4.0,
                ),
                child: Column(
                  children: [
                    // Account Information
                    Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        splashColor: kPrimaryBlue.withOpacity(
                          0.1,
                        ), // Changed to kPrimaryBlue
                        highlightColor: kPrimaryBlue.withOpacity(
                          0.05,
                        ), // Changed to kPrimaryBlue
                        cardColor: Colors.white,
                      ),
                      child: ExpansionTile(
                        leading: Icon(
                          Icons.person,
                          color: kPrimaryBlue,
                        ), // Changed to kPrimaryBlue
                        title: const Text(
                          'Account Information',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text('Manage your profile'),
                        initiallyExpanded: _isAccountInfoExpanded,
                        backgroundColor: kLightBlue.withOpacity(0.08),
                        collapsedBackgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onExpansionChanged: (bool expanded) {
                          setState(() {
                            _isAccountInfoExpanded = expanded;
                            if (!expanded && _isEditingAccount) {
                              _cancelEditAccount();
                            }
                          });
                        },
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _isEditingAccount
                                    ? TextFormField(
                                        controller: _editUsernameController,
                                        decoration: InputDecoration(
                                          labelText: 'Username',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.account_circle,
                                            color: kPrimaryBlue,
                                          ), // Changed to kPrimaryBlue
                                        ),
                                      )
                                    : ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: Icon(
                                          Icons.account_circle,
                                          color: kPrimaryBlue,
                                        ), // Changed to kPrimaryBlue
                                        title: const Text('Username'),
                                        subtitle: Text(_currentUsername),
                                      ),
                                const SizedBox(height: 12),
                                _isEditingAccount
                                    ? TextFormField(
                                        controller: _editEmailController,
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.email,
                                            color: kPrimaryBlue,
                                          ), // Changed to kPrimaryBlue
                                        ),
                                      )
                                    : ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: Icon(
                                          Icons.email,
                                          color: kPrimaryBlue,
                                        ), // Changed to kPrimaryBlue
                                        title: const Text('Email'),
                                        subtitle: Text(_currentEmail),
                                      ),
                                const SizedBox(height: 12),
                                _isEditingAccount
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: _cancelEditAccount,
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: kPrimaryBlue,
                                              ),
                                            ), // Changed to kPrimaryBlue
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton.icon(
                                            onPressed: _saveAccountInfo,
                                            icon: const Icon(
                                              Icons.save,
                                              color: Colors.white,
                                            ),
                                            label: const Text(
                                              'Save',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  kPrimaryBlue, // Changed to kPrimaryBlue
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          onPressed: _toggleEditAccountMode,
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                          label: const Text(
                                            'Edit Account Info',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                kPrimaryBlue, // Changed to kPrimaryBlue
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    // Hotel Information
                    Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        splashColor: kPrimaryBlue.withOpacity(0.1),
                        highlightColor: kPrimaryBlue.withOpacity(0.05),
                        cardColor: Colors.white,
                      ),
                      child: ExpansionTile(
                        leading: Icon(
                          Icons.hotel,
                          color: kPrimaryBlue,
                        ), // Changed to kPrimaryBlue
                        title: const Text(
                          'Hotel Information',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          _currentHotel?.name ?? 'No Hotel Registered',
                        ),
                        initiallyExpanded: _isHotelInfoExpanded,
                        backgroundColor: kLightBlue.withOpacity(0.08),
                        collapsedBackgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onExpansionChanged: (bool expanded) {
                          setState(() {
                            _isHotelInfoExpanded = expanded;
                            if (!expanded && _isEditingHotel) {
                              _cancelEditHotel();
                            }
                          });
                        },
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: _currentHotel == null
                                ? Column(
                                    children: [
                                      const Text(
                                        'No hotel information found. Please register as a Hotel Owner first.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            '/signup',
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.add_business,
                                          color: Colors.white,
                                        ),
                                        label: const Text(
                                          'Register Your Hotel',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kPrimaryBlue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Hotel Name
                                      _isEditingHotel
                                          ? TextFormField(
                                              controller:
                                                  _editHotelNameController,
                                              decoration: InputDecoration(
                                                labelText: 'Hotel Name',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                prefixIcon: Icon(
                                                  Icons.hotel,
                                                  color: kPrimaryBlue,
                                                ), // Changed to kPrimaryBlue
                                              ),
                                            )
                                          : ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              leading: Icon(
                                                Icons.hotel,
                                                color: kPrimaryBlue,
                                              ), // Changed to kPrimaryBlue
                                              title: const Text('Hotel Name'),
                                              subtitle: Text(
                                                _currentHotel?.name ?? 'N/A',
                                              ),
                                            ),
                                      const SizedBox(height: 12),

                                      // Hotel Address
                                      _isEditingHotel
                                          ? TextFormField(
                                              controller:
                                                  _editHotelAddressController,
                                              decoration: InputDecoration(
                                                labelText: 'Address',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                prefixIcon: Icon(
                                                  Icons.location_on,
                                                  color: kPrimaryBlue,
                                                ), // Changed to kPrimaryBlue
                                              ),
                                            )
                                          : ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              leading: Icon(
                                                Icons.location_on,
                                                color: kPrimaryBlue,
                                              ), // Changed to kPrimaryBlue
                                              title: const Text('Address'),
                                              subtitle: Text(
                                                _currentHotel?.location ??
                                                    'N/A',
                                              ),
                                            ),
                                      const SizedBox(height: 12),

                                      // Contact Number
                                      _isEditingHotel
                                          ? TextFormField(
                                              controller:
                                                  _editContactNumberController,
                                              decoration: InputDecoration(
                                                labelText: 'Contact Number',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                prefixIcon: Icon(
                                                  Icons.phone,
                                                  color: kPrimaryBlue,
                                                ), // Changed to kPrimaryBlue
                                              ),
                                              keyboardType: TextInputType.phone,
                                            )
                                          : ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              leading: Icon(
                                                Icons.phone,
                                                color: kPrimaryBlue,
                                              ), // Changed to kPrimaryBlue
                                              title: const Text(
                                                'Contact Number',
                                              ),
                                              subtitle: Text(
                                                _currentHotel?.contactNumber ??
                                                    'N/A',
                                              ),
                                            ),
                                      const SizedBox(height: 12),

                                      // Hotel Description
                                      _isEditingHotel
                                          ? TextFormField(
                                              controller:
                                                  _editHotelDescriptionController,
                                              decoration: InputDecoration(
                                                labelText: 'Description',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                prefixIcon: Icon(
                                                  Icons.description,
                                                  color: kPrimaryBlue,
                                                ), // Changed to kPrimaryBlue
                                              ),
                                              maxLines: 3,
                                              keyboardType:
                                                  TextInputType.multiline,
                                            )
                                          : ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              leading: Icon(
                                                Icons.description,
                                                color: kPrimaryBlue,
                                              ), // Changed to kPrimaryBlue
                                              title: const Text('Description'),
                                              subtitle: Text(
                                                _currentHotel?.description ??
                                                    'N/A',
                                              ),
                                            ),
                                      const SizedBox(height: 12),

                                      // License Number
                                      _isEditingHotel
                                          ? TextFormField(
                                              controller:
                                                  _editLicenseNumberController,
                                              decoration: InputDecoration(
                                                labelText: 'License Number',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                prefixIcon: Icon(
                                                  Icons.article,
                                                  color: kPrimaryBlue,
                                                ), // Changed to kPrimaryBlue
                                              ),
                                            )
                                          : ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              leading: Icon(
                                                Icons.article,
                                                color: kPrimaryBlue,
                                              ), // Changed to kPrimaryBlue
                                              title: const Text(
                                                'License Number',
                                              ),
                                              subtitle: Text(
                                                _currentHotel?.licenseNumber ??
                                                    'N/A',
                                              ),
                                            ),
                                      const SizedBox(height: 12),

                                      // Room Count
                                      _isEditingHotel
                                          ? TextFormField(
                                              controller:
                                                  _editRoomCountController,
                                              decoration: InputDecoration(
                                                labelText: 'Number of Rooms',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                prefixIcon: Icon(
                                                  Icons.room_service,
                                                  color: kPrimaryBlue,
                                                ), // Changed to kPrimaryBlue
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                            )
                                          : ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              leading: Icon(
                                                Icons.room_service,
                                                color: kPrimaryBlue,
                                              ), // Changed to kPrimaryBlue
                                              title: const Text(
                                                'Number of Rooms',
                                              ),
                                              subtitle: Text(
                                                _currentHotel?.roomCount
                                                        ?.toString() ??
                                                    'N/A',
                                              ),
                                            ),
                                      const SizedBox(height: 12),

                                      // Hotel Image URL
                                      _isEditingHotel
                                          ? TextFormField(
                                              controller:
                                                  _editHotelImageController,
                                              decoration: InputDecoration(
                                                labelText: 'Hotel Image URL',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                prefixIcon: Icon(
                                                  Icons.image,
                                                  color: kPrimaryBlue,
                                                ), // Changed to kPrimaryBlue
                                              ),
                                              keyboardType: TextInputType.url,
                                            )
                                          : ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              leading: Icon(
                                                Icons.image,
                                                color: kPrimaryBlue,
                                              ), // Changed to kPrimaryBlue
                                              title: const Text(
                                                'Hotel Image URL',
                                              ),
                                              subtitle: Text(
                                                _currentHotel?.image ?? 'N/A',
                                              ),
                                            ),
                                      const SizedBox(height: 12),

                                      // Price Range
                                      _isEditingHotel
                                          ? TextFormField(
                                              controller:
                                                  _editPriceRangeController,
                                              decoration: InputDecoration(
                                                labelText:
                                                    'Price Range (e.g., \$100 - \$200)',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                prefixIcon: Icon(
                                                  Icons.attach_money,
                                                  color: kPrimaryBlue,
                                                ), // Changed to kPrimaryBlue
                                              ),
                                            )
                                          : ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              leading: Icon(
                                                Icons.attach_money,
                                                color: kPrimaryBlue,
                                              ), // Changed to kPrimaryBlue
                                              title: const Text('Price Range'),
                                              subtitle: Text(
                                                _currentHotel?.priceRange ??
                                                    'N/A',
                                              ),
                                            ),
                                      const SizedBox(height: 12),

                                      // Categories (interactive word pool)
                                      if (_isEditingHotel) ...[
                                        _buildCategoryChipInput(
                                          labelText: 'Add Categories',
                                          controller: _newCategoryController,
                                          currentList: _editedCategories,
                                          icon: Icons.category,
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                      if (!_isEditingHotel &&
                                          _currentHotel != null &&
                                          _currentHotel!
                                              .categories
                                              .isNotEmpty) ...[
                                        ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          leading: Icon(
                                            Icons.category,
                                            color: kPrimaryBlue,
                                          ), // Changed to kPrimaryBlue
                                          title: const Text('Categories'),
                                          subtitle: Wrap(
                                            spacing: 8.0,
                                            runSpacing: 4.0,
                                            children: _currentHotel!.categories
                                                .map((category) {
                                                  return Chip(
                                                    label: Text(category),
                                                    backgroundColor: kLightBlue,
                                                    labelStyle: const TextStyle(
                                                      color: kDarkBlue,
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      side: const BorderSide(
                                                        color: kPrimaryBlue,
                                                      ),
                                                    ),
                                                  );
                                                })
                                                .toList(),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                      ],

                                      // Amenities (interactive word pool with icons)
                                      if (_isEditingHotel) ...[
                                        _buildAmenityChipInput(
                                          labelText: 'Add Amenities',
                                          controller:
                                              _newAmenityLabelController,
                                          currentList: _editedAmenities,
                                          icon: Icons.local_activity,
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                      if (!_isEditingHotel &&
                                          _currentHotel != null &&
                                          _currentHotel!
                                              .amenities
                                              .isNotEmpty) ...[
                                        ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          leading: Icon(
                                            Icons.local_activity,
                                            color: kPrimaryBlue,
                                          ), // Changed to kPrimaryBlue
                                          title: const Text('Amenities'),
                                          subtitle: Wrap(
                                            spacing: 8.0,
                                            runSpacing: 4.0,
                                            children: _currentHotel!.amenities.map(
                                              (amenity) {
                                                return Chip(
                                                  avatar: Icon(
                                                    amenity.icon,
                                                    color: kPrimaryBlue,
                                                    size: 18,
                                                  ), // Changed to kPrimaryBlue
                                                  label: Text(amenity.label),
                                                  backgroundColor: kLightBlue,
                                                  labelStyle: const TextStyle(
                                                    color: kDarkBlue,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    side: const BorderSide(
                                                      color: kPrimaryBlue,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                      ],

                                      // Save/Cancel Buttons for Hotel Info
                                      _isEditingHotel
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: _cancelEditHotel,
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      color: kPrimaryBlue,
                                                    ),
                                                  ), // Changed to kPrimaryBlue
                                                ),
                                                const SizedBox(width: 8),
                                                ElevatedButton.icon(
                                                  onPressed: _saveHotelInfo,
                                                  icon: const Icon(
                                                    Icons.save,
                                                    color: Colors.white,
                                                  ),
                                                  label: const Text(
                                                    'Save',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        kPrimaryBlue, // Changed to kPrimaryBlue
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton.icon(
                                                onPressed: _toggleEditHotelMode,
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                ),
                                                label: const Text(
                                                  'Edit Hotel Info',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      kPrimaryBlue, // Changed to kPrimaryBlue
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                      ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    // Notifications Settings
                    Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        splashColor: kPrimaryBlue.withOpacity(0.1),
                        highlightColor: kPrimaryBlue.withOpacity(0.05),
                        cardColor: Colors.white,
                      ),
                      child: ExpansionTile(
                        leading: Icon(
                          Icons.notifications,
                          color: kPrimaryBlue,
                        ), // Changed to kPrimaryBlue
                        title: const Text(
                          'Notifications',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text('Manage notification preferences'),
                        initiallyExpanded: _isNotificationsExpanded,
                        backgroundColor: kLightBlue.withOpacity(0.08),
                        collapsedBackgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onExpansionChanged: (bool expanded) {
                          setState(() {
                            _isNotificationsExpanded = expanded;
                          });
                        },
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Column(
                              children: [
                                SwitchListTile(
                                  title: const Text('Enable All Notifications'),
                                  value: true, // Placeholder for actual state
                                  onChanged: (bool value) {
                                    // Handle state change
                                  },
                                  activeColor:
                                      kPrimaryBlue, // Changed to kPrimaryBlue
                                  secondary: Icon(
                                    Icons.toggle_on,
                                    color: kPrimaryBlue,
                                  ), // Changed to kPrimaryBlue
                                ),
                                SwitchListTile(
                                  title: const Text('Email Notifications'),
                                  value: false, // Placeholder for actual state
                                  onChanged: (bool value) {
                                    // Handle state change
                                  },
                                  activeColor:
                                      kPrimaryBlue, // Changed to kPrimaryBlue
                                  secondary: Icon(
                                    Icons.email,
                                    color: kPrimaryBlue,
                                  ), // Changed to kPrimaryBlue
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    // App Theme and Display Settings
                    Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        splashColor: kPrimaryBlue.withOpacity(0.1),
                        highlightColor: kPrimaryBlue.withOpacity(0.05),
                        cardColor: Colors.white,
                      ),
                      child: ExpansionTile(
                        leading: Icon(
                          Icons.palette,
                          color: kPrimaryBlue,
                        ), // Changed to kPrimaryBlue
                        title: const Text(
                          'App Theme & Display',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text(
                          'Customize your app\'s appearance',
                        ),
                        initiallyExpanded:
                            _isAboutAppExpanded, // This seems mislabeled, should be for theme/display
                        backgroundColor: kLightBlue.withOpacity(0.08),
                        collapsedBackgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onExpansionChanged: (bool expanded) {
                          setState(() {
                            _isAboutAppExpanded =
                                expanded; // Mislabeled, consider renaming
                          });
                        },
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Column(
                              children: [
                                SwitchListTile(
                                  title: const Text('Dark Mode'),
                                  value: _isDarkModeEnabled,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _isDarkModeEnabled = value;
                                      // Implement theme change logic here
                                    });
                                  },
                                  activeColor:
                                      kPrimaryBlue, // Changed to kPrimaryBlue
                                  secondary: Icon(
                                    Icons.dark_mode,
                                    color: kPrimaryBlue,
                                  ), // Changed to kPrimaryBlue
                                ),
                              ],
                            ),
                          ),
                        ],
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
