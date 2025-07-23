import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // Import for TapGestureRecognizer
import 'package:shared_preferences/shared_preferences.dart'; // Import for SharedPreferences
import '../screens/terms_conditions_screen.dart'; // Assuming this screen exists for navigation
import '../screens/admin.dart'; // Import your admin screen
import '../utils/constants.dart';
import '../screens/hotel_manager.dart';
import '../utils/user_manager.dart'; // Import UserManager
import 'package:hotel_system_1/models/hotel.dart';
import 'package:hotel_system_1/models/user.dart'; // Make sure this line exists

// Add this extension at the top (after imports) if not already present
extension ColorWithValues on Color {
  Color withValues({double? alpha}) {
    if (alpha != null) {
      return withAlpha((255 * alpha).round());
    }
    return this;
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _selectedRole = 'Guest';
  int _currentStep = 0;
    
  // State variables for password visibility
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Separate GlobalKeys for each form section to allow step-by-step validation
  final _guestFormKey = GlobalKey<FormState>();
  final _ownerStep1FormKey = GlobalKey<FormState>(); // For Account Info in Owner flow
  final _ownerStep2FormKey = GlobalKey<FormState>(); // For Hotel Info in Owner flow

  // Common Controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Hotel Owner Controllers
  final TextEditingController _hotelNameController = TextEditingController();
  final TextEditingController _hotelAddressController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _hotelDescriptionController = TextEditingController();
  final TextEditingController _licenseNumberController = TextEditingController();
  final TextEditingController _roomCountController = TextEditingController();
  final TextEditingController _hotelWebsiteController = TextEditingController(); // This was used for image previously
  final TextEditingController _hotelImageController = TextEditingController(); // New controller for image URL
  final TextEditingController _priceRangeController = TextEditingController(); // New controller for price range

  // Removed: Controllers for the new word pool input fields
  // final TextEditingController _categoryInputController = TextEditingController();
  // final TextEditingController _amenityInputController = TextEditingController();

  // Removed: Lists to hold selected categories and amenities (word pool style)
  // List<String> _selectedCategories = [];
  // List<String> _selectedAmenities = [];


  bool _agreedToTerms = false;
  
  @override
  void dispose() {
    // Dispose of all controllers to free up resources
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _hotelNameController.dispose();
    _hotelAddressController.dispose();
    _contactNumberController.dispose();
    _hotelDescriptionController.dispose();
    _licenseNumberController.dispose();
    _roomCountController.dispose();
    _hotelWebsiteController.dispose();
    _hotelImageController.dispose();
    _priceRangeController.dispose();
    // Removed: _categoryInputController.dispose();
    // Removed: _amenityInputController.dispose();
    super.dispose();
  }

  void _submitForm() async { // Made async for SharedPreferences
    if (_selectedRole == 'Guest' && _guestFormKey.currentState!.validate()) {
      // Create a User object for Guest
      final newUser = User(
        fullName: _fullNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: 'Guest',
      );
      UserManager.registerUser(newUser); // Pass the User object

      // Save login status for Guest
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('loggedInUserRole', newUser.role);

      // Navigate to Home Screen for Guest
      Navigator.pushReplacementNamed(context, '/home');
    } else if (_selectedRole == 'Owner' && _agreedToTerms) {
      // Validate Hotel Info form before proceeding to submission
      if (!_ownerStep2FormKey.currentState!.validate()) {
        setState(() {
          _currentStep = 1; // Go back to Hotel Info step if invalid
        });
        return; // Stop submission if validation fails
      }
      // Removed: Additional validation for categories and amenities lists
      // if (_selectedCategories.isEmpty || _selectedAmenities.isEmpty) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Please add at least one category and one amenity.')),
      //   );
      //   setState(() {
      //     _currentStep = 1; // Go back to Hotel Info step if invalid
      //   });
      //   return;
      // }

      // Create a User object for Owner
      final newUser = User(
        fullName: _fullNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: 'Owner',
      );
      UserManager.registerUser(newUser); // Pass the User object

      // Save login status for Owner
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Clear previous session data
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('loggedInUserRole', newUser.role);
      await prefs.setString('loggedInUserEmail', newUser.email);
      await prefs.setString('loggedInHotelName', _hotelNameController.text); // Set to new hotel name
      await prefs.setString('hotel_for_${newUser.email}', _hotelNameController.text); // Map email to hotel

      // Add hotel information
      HotelManager().addHotel(Hotel(
        image: _hotelImageController.text.isNotEmpty ? _hotelImageController.text : 'assets/placeholder_hotel.png', // Use provided image or a placeholder
        name: _hotelNameController.text,
        location: _hotelAddressController.text,
        rating: 'New', // Default rating for new hotels
        description: _hotelDescriptionController.text,
        amenities: [], // Empty list for amenities, managed in admin settings
        categories: [], // Empty list for categories, managed in admin settings
        priceRange: _priceRangeController.text, // Use provided price range
        isFavorite: false, // Default to not favorite
        contactNumber: _contactNumberController.text, // Add contact number
        licenseNumber: _licenseNumberController.text, // Add license number
        roomCount: int.tryParse(_roomCountController.text) ?? 0, // Add room count
      ));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AdminDashboard()), // Or your admin screen
      );
    }
  }

  // Removed: Helper method to build interactive word pool input fields
  // Widget _buildChipInput({ ... })


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBlue, // Changed to light blue background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/logo.png', height: 150),
              const SizedBox(height: 24),
              Text(
                'Create Account',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: kDarkBlue),
              ),
              const SizedBox(height: 10),

              // Dropdown for Account Type selection
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2), // Use opacity instead of withValues
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Account Type',
                    prefixIcon: Icon(Icons.account_circle, color: kDarkBlue),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: kAccentBlue, width: 2),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Guest', child: Text('Guest')),
                    DropdownMenuItem(value: 'Owner', child: Text('Hotel Owner')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                      _currentStep = 0; // Reset step when role changes
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Conditional rendering based on selected role (Guest or Owner)
              _selectedRole == 'Guest'
                  ? Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2), // Use opacity
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _guestFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _fullNameController,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                prefixIcon: Icon(Icons.person, color: kDarkBlue),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                if (value.trim().split(' ').length < 2) {
                                  return 'Please enter your first and last name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email Address',
                                prefixIcon: Icon(Icons.email, color: kDarkBlue),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email address';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock, color: kDarkBlue),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: kDarkBlue,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: !_isConfirmPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                prefixIcon: Icon(Icons.lock, color: kDarkBlue),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: kDarkBlue,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () {
                                if (_guestFormKey.currentState!.validate()) {
                                  _submitForm();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryBlue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                minimumSize: const Size.fromHeight(50),
                              ),
                              child: const Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 16)),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Stepper(
                      currentStep: _currentStep,
                      onStepContinue: () {
                        bool isCurrentStepValid = false;

                        // Validate the current step's form based on _currentStep
                        if (_currentStep == 0) {
                          isCurrentStepValid = _ownerStep1FormKey.currentState!.validate();
                        } else if (_currentStep == 1) {
                          isCurrentStepValid = _ownerStep2FormKey.currentState!.validate();
                          // Removed: Additional validation for categories and amenities lists
                        } else if (_currentStep == 2) {
                          // For the agreement step, validation is simply checking the checkbox
                          isCurrentStepValid = _agreedToTerms;
                          if (!isCurrentStepValid) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please agree to the Terms and Conditions to proceed.')),
                            );
                          }
                        }

                        if (isCurrentStepValid) {
                          if (_currentStep < 2) {
                            setState(() {
                              _currentStep += 1;
                            });
                          } else {
                            // If all steps are valid and terms agreed, submit the form
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
                      controlsBuilder: (context, details) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: details.onStepContinue,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryBlue,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                ),
                                child: Text(_currentStep == 2 ? 'Sign Up' : 'Next', style: const TextStyle(color: Colors.white, fontSize: 16)),
                              ),
                              const SizedBox(width: 10),
                              if (details.onStepCancel != null) // Check if onStepCancel is not null
                                TextButton(
                                  onPressed: details.onStepCancel,
                                  child: Text('Back', style: TextStyle(color: kDarkBlue, fontSize: 16)),
                                ),
                            ],
                          ),
                        );
                      },
                      steps: [
                        Step(
                          title: const Text('Account Info'),
                          isActive: _currentStep >= 0,
                          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                          content: Container(
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.2), // Use opacity
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _ownerStep1FormKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _fullNameController,
                                    decoration: InputDecoration(
                                      labelText: 'Full Name',
                                      prefixIcon: Icon(Icons.person, color: kDarkBlue),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your full name';
                                      }
                                      if (value.trim().split(' ').length < 2) {
                                        return 'Please enter your first and last name';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: 'Email Address',
                                      prefixIcon: Icon(Icons.email, color: kDarkBlue),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email address';
                                      }
                                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                        return 'Please enter a valid email address';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: !_isPasswordVisible,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      prefixIcon: Icon(Icons.lock, color: kDarkBlue),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                          color: kDarkBlue,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordVisible = !_isPasswordVisible;
                                          });
                                        },
                                      ),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a password';
                                      }
                                      if (value.length < 6) {
                                        return 'Password must be at least 6 characters long';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: !_isConfirmPasswordVisible,
                                    decoration: InputDecoration(
                                      labelText: 'Confirm Password',
                                      prefixIcon: Icon(Icons.lock, color: kDarkBlue),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                          color: kDarkBlue,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                          });
                                        },
                                      ),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password';
                                      }
                                      if (value != _passwordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Step(
                          title: const Text('Hotel Info'),
                          isActive: _currentStep >= 1,
                          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                          content: Container(
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.2), // Use opacity
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _ownerStep2FormKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _hotelNameController,
                                    decoration: InputDecoration(
                                      labelText: 'Hotel Name',
                                      prefixIcon: Icon(Icons.business, color: kDarkBlue),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (_selectedRole == 'Owner' && (value == null || value.isEmpty)) {
                                        return 'Please enter hotel name';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _hotelAddressController,
                                    decoration: InputDecoration(
                                      labelText: 'Hotel Address',
                                      prefixIcon: Icon(Icons.location_on, color: kDarkBlue),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (_selectedRole == 'Owner' && (value == null || value.isEmpty)) {
                                        return 'Please enter hotel address';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _contactNumberController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      labelText: 'Contact Number',
                                      prefixIcon: Icon(Icons.phone, color: kDarkBlue),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (_selectedRole == 'Owner' && (value == null || value.isEmpty)) {
                                        return 'Please enter contact number';
                                      }
                                      final pattern = r'^(09\d{9}|\+639\d{9})$';
                                      if (_selectedRole == 'Owner' && !RegExp(pattern).hasMatch(value!)) {
                                        return 'Enter a valid PH number (09XXXXXXXXX or +639XXXXXXXXX)';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _hotelDescriptionController,
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                      labelText: 'Hotel Description',
                                      prefixIcon: Icon(Icons.description, color: kDarkBlue),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (_selectedRole == 'Owner' && (value == null || value.isEmpty)) {
                                        return 'Please enter hotel description';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _licenseNumberController,
                                    decoration: InputDecoration(
                                      labelText: 'Hotel License Number',
                                      prefixIcon: Icon(Icons.confirmation_number, color: kDarkBlue),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (_selectedRole == 'Owner' && (value == null || value.isEmpty)) {
                                        return 'Please enter license number';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _roomCountController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Number of Rooms',
                                      prefixIcon: Icon(Icons.hotel, color: kDarkBlue),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (_selectedRole == 'Owner' && (value == null || value.isEmpty || int.tryParse(value) == null)) {
                                        return 'Please enter a valid number of rooms';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _hotelImageController, // Use new controller for image
                                    decoration: InputDecoration(
                                      labelText: 'Hotel Image URL (Optional)',
                                      prefixIcon: Icon(Icons.image, color: kDarkBlue),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _priceRangeController, // Use new controller for price range
                                    decoration: InputDecoration(
                                      labelText: 'Price Range (e.g., ₱1,000 - ₱5,000)',
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(left: 12, right: 8),
                                        child: Text('₱', style: TextStyle(fontSize: 20, color: kDarkBlue, fontWeight: FontWeight.bold)),
                                      ),
                                      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (_selectedRole == 'Owner' && (value == null || value.isEmpty)) {
                                        return 'Please enter price range';
                                      }
                                      return null;
                                    },
                                  ),
                                  // Removed: Categories and Amenities input fields
                                ],
                              ),
                            ),
                          ),
                        ),
                        Step(
                          title: const Text('Agreement'),
                          isActive: _currentStep >= 2,
                          state: _currentStep > 2 ? StepState.complete : StepState.indexed,
                          content: Container(
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.2), // Use opacity
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                CheckboxListTile(
                                  value: _agreedToTerms,
                                  activeColor: kPrimaryBlue,
                                  onChanged: (value) {
                                    setState(() {
                                      _agreedToTerms = value!;
                                    });
                                  },
                                  title: RichText(
                                    text: TextSpan(
                                      text: 'By signing in or registering, you are deemed to have agreed to the ',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Terms and Conditions',
                                          style: TextStyle(
                                            color: kPrimaryBlue,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => TermsConditionsScreen(),
                                                ),
                                              );
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                  controlAffinity: ListTileControlAffinity.leading,
                                ),
                                if (!_agreedToTerms && _currentStep == 2)
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 16.0),
                                      child: Text(
                                        '*You must agree before submitting.',
                                        style: TextStyle(color: Colors.red, fontSize: 12),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account?'),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: Text('Login', style: TextStyle(color: kPrimaryBlue, fontSize: 16)),
              ),
            ],
          ),
        ],
      ),
    ),
  ),
);
  }
}
