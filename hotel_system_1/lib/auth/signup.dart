import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart'; // Import video_player

import '../screens/terms_conditions_screen.dart';
import '../screens/admin.dart';
import '../utils/constants.dart';
import '../screens/hotel_manager.dart';
import '../utils/user_manager.dart';
import 'package:hotel_system_1/models/hotel.dart';
import 'package:hotel_system_1/models/user.dart';

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
  // Video Player Controllers
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  String _selectedRole = 'Guest';
  int _currentStep = 0;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final _guestFormKey = GlobalKey<FormState>();
  final _ownerStep1FormKey = GlobalKey<FormState>();
  final _ownerStep2FormKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _hotelNameController = TextEditingController();
  final TextEditingController _hotelAddressController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _hotelDescriptionController =
      TextEditingController();
  final TextEditingController _licenseNumberController =
      TextEditingController();
  final TextEditingController _roomCountController = TextEditingController();
  final TextEditingController _hotelWebsiteController = TextEditingController();
  final TextEditingController _hotelImageController = TextEditingController();
  final TextEditingController _priceRangeController = TextEditingController();

  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    // Initialize the video controller
    _controller = VideoPlayerController.asset('assets/second_bg.mp4')
      ..setLooping(true) // Loop the video
      ..setVolume(0.0); // Mute the video

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      // Ensure the first frame is shown and then play the video
      setState(() {});
      _controller.play();
    });
  }

  @override
  void dispose() {
    // Dispose of all controllers
    _controller.dispose(); // Dispose the video controller
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
    super.dispose();
  }

  void _submitForm() async {
    if (_selectedRole == 'Guest' && _guestFormKey.currentState!.validate()) {
      final newUser = User(
        fullName: _fullNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: 'Guest',
      );
      UserManager.registerUser(newUser);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('loggedInUserRole', newUser.role);

      Navigator.pushReplacementNamed(context, '/home');
    } else if (_selectedRole == 'Owner' && _agreedToTerms) {
      if (!_ownerStep2FormKey.currentState!.validate()) {
        setState(() {
          _currentStep = 1;
        });
        return;
      }

      final newUser = User(
        fullName: _fullNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: 'Owner',
      );
      UserManager.registerUser(newUser);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('loggedInUserRole', newUser.role);
      await prefs.setString('loggedInUserEmail', newUser.email);
      await prefs.setString('loggedInHotelName', _hotelNameController.text);
      await prefs.setString(
        'hotel_for_${newUser.email}',
        _hotelNameController.text,
      );

      HotelManager().addHotel(
        Hotel(
          image: _hotelImageController.text.isNotEmpty
              ? _hotelImageController.text
              : 'assets/placeholder_hotel.png',
          name: _hotelNameController.text,
          location: _hotelAddressController.text,
          rating: 'New',
          description: _hotelDescriptionController.text,
          amenities: [],
          categories: [],
          priceRange: _priceRangeController.text,
          isFavorite: false,
          contactNumber: _contactNumberController.text,
          licenseNumber: _licenseNumberController.text,
          roomCount: int.tryParse(_roomCountController.text) ?? 0,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AdminDashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No need for backgroundColor here as the video will cover it
      body: Stack(
        children: <Widget>[
          // Video Background Layer
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          // Overlay with a slight tint for readability (optional)
          Container(
            color: Colors.black.withOpacity(0.3), // Adjust opacity as needed
          ),
          // Your existing content layer
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Image.asset('assets/logo.png', height: 150),
                  const SizedBox(height: 24),
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Changed here
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Dropdown for Account Type selection
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(
                        0.85,
                      ), // Semi-transparent background
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
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
                        prefixIcon: Icon(
                          Icons.account_circle,
                          color: kDarkBlue,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        filled: true,
                        fillColor: Colors
                            .white, // Still use white for the field itself
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: kAccentBlue,
                            width: 2,
                          ),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Guest', child: Text('Guest')),
                        DropdownMenuItem(
                          value: 'Owner',
                          child: Text('Hotel Owner'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value!;
                          _currentStep = 0;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Conditional rendering based on selected role (Guest or Owner)
                  _selectedRole == 'Guest'
                      ? Form(
                          // Removed Container, directly using Form
                          key: _guestFormKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _fullNameController,
                                decoration: InputDecoration(
                                  labelText: 'Full Name',
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: kDarkBlue,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
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
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: kDarkBlue,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email address';
                                  }
                                  if (!RegExp(
                                    r'^[^@]+@[^@]+\.[^@]+',
                                  ).hasMatch(value)) {
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
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: kDarkBlue,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: kDarkBlue,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
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
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: kDarkBlue,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isConfirmPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: kDarkBlue,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isConfirmPasswordVisible =
                                            !_isConfirmPasswordVisible;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  minimumSize: const Size.fromHeight(50),
                                ),
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Stepper(
                          currentStep: _currentStep,
                          onStepContinue: () {
                            bool isCurrentStepValid = false;

                            if (_currentStep == 0) {
                              isCurrentStepValid = _ownerStep1FormKey
                                  .currentState!
                                  .validate();
                            } else if (_currentStep == 1) {
                              isCurrentStepValid = _ownerStep2FormKey
                                  .currentState!
                                  .validate();
                            } else if (_currentStep == 2) {
                              isCurrentStepValid = _agreedToTerms;
                              if (!isCurrentStepValid) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please agree to the Terms and Conditions to proceed.',
                                    ),
                                  ),
                                );
                              }
                            }

                            if (isCurrentStepValid) {
                              if (_currentStep < 2) {
                                setState(() {
                                  _currentStep += 1;
                                });
                              } else {
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
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                    ),
                                    child: Text(
                                      _currentStep == 2 ? 'Sign Up' : 'Next',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  if (details.onStepCancel != null)
                                    TextButton(
                                      onPressed: details.onStepCancel,
                                      child: Text(
                                        'Back',
                                        style: TextStyle(
                                          color:
                                              kDarkBlue, // This button is on top of the dark overlay, so keeping kDarkBlue for contrast against white background of Stepper content.
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                          steps: [
                            Step(
                              title: Text(
                                'Account Info',
                                style: TextStyle(color: Colors.white),
                              ), // Changed here
                              isActive: _currentStep >= 0,
                              state: _currentStep > 0
                                  ? StepState.complete
                                  : StepState.indexed,
                              content: Form(
                                // Removed Container, directly using Form
                                key: _ownerStep1FormKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _fullNameController,
                                      decoration: InputDecoration(
                                        labelText: 'Full Name',
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: kDarkBlue,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your full name';
                                        }
                                        if (value.trim().split(' ').length <
                                            2) {
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
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: kDarkBlue,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email address';
                                        }
                                        if (!RegExp(
                                          r'^[^@]+@[^@]+\.[^@]+',
                                        ).hasMatch(value)) {
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
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: kDarkBlue,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _isPasswordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: kDarkBlue,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isPasswordVisible =
                                                  !_isPasswordVisible;
                                            });
                                          },
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
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
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: kDarkBlue,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _isConfirmPasswordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: kDarkBlue,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isConfirmPasswordVisible =
                                                  !_isConfirmPasswordVisible;
                                            });
                                          },
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
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
                            Step(
                              title: const Text(
                                'Hotel Info',
                                style: TextStyle(color: Colors.white),
                              ), // Changed here
                              isActive: _currentStep >= 1,
                              state: _currentStep > 1
                                  ? StepState.complete
                                  : StepState.indexed,
                              content: Form(
                                // Removed Container, directly using Form
                                key: _ownerStep2FormKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _hotelNameController,
                                      decoration: InputDecoration(
                                        labelText: 'Hotel Name',
                                        prefixIcon: Icon(
                                          Icons.hotel,
                                          color: kDarkBlue,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
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
                                        prefixIcon: Icon(
                                          Icons.location_on,
                                          color: kDarkBlue,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
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
                                        prefixIcon: Icon(
                                          Icons.phone,
                                          color: kDarkBlue,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter contact number';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      controller: _hotelDescriptionController,
                                      decoration: InputDecoration(
                                        labelText: 'Hotel Description',
                                        prefixIcon: Icon(
                                          Icons.description,
                                          color: kDarkBlue,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      maxLines: 3,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter hotel description';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      controller: _licenseNumberController,
                                      decoration: InputDecoration(
                                        labelText: 'License Number',
                                        prefixIcon: Icon(
                                          Icons.article,
                                          color: kDarkBlue,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
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
                                        prefixIcon: Icon(
                                          Icons.room,
                                          color: kDarkBlue,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter number of rooms';
                                        }
                                        if (int.tryParse(value) == null) {
                                          return 'Please enter a valid number';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      controller: _hotelWebsiteController,
                                      decoration: InputDecoration(
                                        labelText: 'Hotel Website (Optional)',
                                        prefixIcon: Icon(
                                          Icons.web,
                                          color: kDarkBlue,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      keyboardType: TextInputType.url,
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      controller: _hotelImageController,
                                      decoration: InputDecoration(
                                        labelText: 'Hotel Image URL (Optional)',
                                        prefixIcon: Icon(
                                          Icons.image,
                                          color: kDarkBlue,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      controller: _priceRangeController,
                                      decoration: InputDecoration(
                                        labelText:
                                            'Price Range (e.g., \$ - \$\$\$\$) (Optional)',
                                        prefixIcon: Icon(
                                          Icons.attach_money,
                                          color: kDarkBlue,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Step(
                              title: const Text(
                                'Terms & Conditions',
                                style: TextStyle(color: Colors.white),
                              ), // Changed here
                              isActive: _currentStep >= 2,
                              state: _currentStep == 2
                                  ? StepState.indexed
                                  : StepState.complete,
                              content: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.85),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Please read and agree to our Terms and Conditions.',
                                          style: TextStyle(
                                            color: kDarkBlue,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Checkbox(
                                              value: _agreedToTerms,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  _agreedToTerms = newValue!;
                                                });
                                              },
                                              activeColor: kPrimaryBlue,
                                            ),
                                            Expanded(
                                              child: RichText(
                                                text: TextSpan(
                                                  text: 'I agree to the ',
                                                  style: TextStyle(
                                                    color: kDarkBlue,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          'Terms and Conditions',
                                                      style: TextStyle(
                                                        color: kAccentBlue,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (
                                                                        context,
                                                                      ) =>
                                                                          const TermsConditionsScreen(),
                                                                ),
                                                              );
                                                            },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.white), // Changed here
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: kAccentBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
