// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controllers for editable fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Initial values (you'd load these from a user model or database)
  String _memberName = 'John Doe';
  String _memberEmail = 'johndoe@example.com';
  String _memberPhone = '+63 912 345 6789';
  String _memberAddress = '123 Main St, Malvar, Batangas';
  final String _memberSince = 'January 2023'; // This likely won't be editable

  bool _isEditing = false; // To toggle between view and edit mode

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current profile data
    _nameController.text = _memberName;
    _emailController.text = _memberEmail;
    _phoneController.text = _memberPhone;
    _addressController.text = _memberAddress;
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() {
    setState(() {
      _memberName = _nameController.text;
      _memberEmail = _emailController.text;
      _memberPhone = _phoneController.text;
      _memberAddress = _addressController.text;
      _isEditing = false; // Exit edit mode after saving

      // In a real application, you would send this data to a backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, // Show a back button
        title: const Text(
          'My Profile',
          style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kPrimaryBlue,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit, color: kWhite),
            onPressed: () {
              if (_isEditing) {
                _saveProfile();
              } else {
                _toggleEdit();
              }
            },
          ),
        ],
      ),
      body: Container(
        color: kLightBlue,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .center, // Keep this for overall column centering
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/profile_placeholder.png'),
                  backgroundColor: kWhite,
                ),
                const SizedBox(height: 20),
                _isEditing
                    ? SizedBox(
                        // Wrap TextField in SizedBox to control width
                        width:
                            MediaQuery.of(context).size.width *
                            0.7, // Adjust width as needed
                        child: TextField(
                          controller: _nameController,
                          textAlign: TextAlign
                              .center, // Center the text within the TextField
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: kDarkBlue,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Enter Name',
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    : Text(
                        _memberName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: kDarkBlue,
                        ),
                      ),
                const SizedBox(height: 8),
                _isEditing
                    ? SizedBox(
                        // Wrap TextField in SizedBox to control width
                        width:
                            MediaQuery.of(context).size.width *
                            0.7, // Adjust width as needed
                        child: TextField(
                          controller: _emailController,
                          textAlign: TextAlign
                              .center, // Center the text within the TextField
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            fontSize: 16,
                            color: kGreyText,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Enter Email',
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    : Text(
                        _memberEmail,
                        style: const TextStyle(fontSize: 16, color: kGreyText),
                      ),
                const SizedBox(height: 30),
                // All rows now use the same _buildProfileInfoRow for consistent alignment
                _buildProfileInfoRow(
                  Icons.phone,
                  'Phone',
                  _memberPhone,
                  isEditable: _isEditing,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                _buildProfileInfoRow(
                  Icons.location_on,
                  'Address',
                  _memberAddress,
                  isEditable: _isEditing,
                  controller: _addressController,
                ),
                _buildProfileInfoRow(
                  Icons.calendar_month,
                  'Member Since',
                  _memberSince,
                  isEditable: false, // This one is never editable
                ),
                const SizedBox(height: 30),
                if (!_isEditing)
                  ElevatedButton(
                    onPressed: _toggleEdit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryBlue,
                      foregroundColor: kWhite,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                if (_isEditing)
                  ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryBlue,
                      foregroundColor: kWhite,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Save Profile',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Unified Helper for all profile information rows
  Widget _buildProfileInfoRow(
    IconData icon,
    String label,
    String value, {
    bool isEditable = true,
    TextEditingController? controller, // Make controller nullable
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the whole row
        children: [
          Icon(icon, color: kDarkBlue, size: 20),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: kDarkBlue,
            ),
          ),
          // Use Flexible instead of Expanded here for better content wrapping
          Flexible(
            child: isEditable && _isEditing && controller != null
                ? TextField(
                    controller: controller,
                    textAlign: TextAlign
                        .center, // NOW CENTERED HERE for full row centering
                    keyboardType: keyboardType,
                    style: const TextStyle(color: kGreyText),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                  )
                : Text(
                    value,
                    textAlign: TextAlign
                        .center, // NOW CENTERED HERE for full row centering
                    style: const TextStyle(color: kGreyText),
                  ),
          ),
        ],
      ),
    );
  }
}
