import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // Import for TapGestureRecognizer
import '../screens/terms_conditions_screen.dart'; // Assuming this screen exists for navigation
import '../screens/admin.dart'; // Import your admin screen

// Define the new blue and white color scheme constants
const Color kPrimaryBlue = Color(0xFF0065FF); // A vibrant blue for primary elements
const Color kDarkBlue = Color(0xFF003C99); // A darker blue for text/icons
const Color kLightBlue = Color(0xFFE6F2FF); // A very light blue for backgrounds
const Color kAccentBlue = Color(0xFF007BFF); // An accent blue for highlights

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
  final TextEditingController _hotelWebsiteController = TextEditingController();

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
    super.dispose();
  }

  void _submitForm() {
    // This method is called when the final submission button is pressed.
    // At this point, all relevant step validations should have passed.
    if (_selectedRole == 'Owner') {
      // For owner, ensure terms are agreed before final submission
      if (_agreedToTerms) {
        // Navigate to the admin screen for hotel owners
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminDashboard(),
          ),
        );
      } else {
        // This case should ideally be caught by the stepper's validation,
        // but kept as a fallback.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please agree to the Terms and Conditions to proceed.')),
        );
      }
    } else {
      // For guest, navigate to the home screen after signup
      // Assuming '/' is the home route defined in main.dart
      Navigator.pushReplacementNamed(context, '/');
    }
  }

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
              // Logo - Increased height for better visibility and consistency
              Image.asset('assets/logo.png', height: 150),
              const SizedBox(height: 24), // Adjusted spacing
              Text(
                'Create Account',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: kDarkBlue), // Changed to dark blue
              ),
              const SizedBox(height: 10),

              // Dropdown for Account Type selection
              Container(
                padding: const EdgeInsets.all(8.0), // Padding around the dropdown
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Account Type',
                    prefixIcon: Icon(Icons.account_circle, color: kDarkBlue), // Changed to dark blue
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder( // Ensure border is visible when not focused
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder( // Highlight when focused
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: kAccentBlue, width: 2), // Changed to accent blue
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Guest', child: Text('Guest')),
                    DropdownMenuItem(value: 'Owner', child: Text('Hotel Owner')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                      _currentStep = 0; // Reset step when role changes to restart the process
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Conditional rendering based on selected role (Guest or Owner)
              _selectedRole == 'Guest'
                  ? Container( // Box for Guest registration form
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Form( // Form for Guest registration
                        key: _guestFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _fullNameController,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                prefixIcon: Icon(Icons.person, color: kDarkBlue), // Changed to dark blue
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
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
                                prefixIcon: Icon(Icons.email, color: kDarkBlue), // Changed to dark blue
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
                              obscureText: !_isPasswordVisible, // Toggles visibility
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock, color: kDarkBlue), // Changed to dark blue
                                suffixIcon: IconButton( // Password visibility toggle
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: kDarkBlue, // Changed to dark blue
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
                              obscureText: !_isConfirmPasswordVisible, // Toggles visibility
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                prefixIcon: Icon(Icons.lock, color: kDarkBlue), // Changed to dark blue
                                suffixIcon: IconButton( // Confirm password visibility toggle
                                  icon: Icon(
                                    _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: kDarkBlue, // Changed to dark blue
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
                                if (_guestFormKey.currentState!.validate()) { // Validate only the guest form
                                  _submitForm();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryBlue, // Changed to primary blue
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
                                  backgroundColor: kPrimaryBlue, // Changed to primary blue
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                ),
                                // Changed button text to 'Sign Up' for the final step
                                child: Text(_currentStep == 2 ? 'Sign Up' : 'Next', style: const TextStyle(color: Colors.white, fontSize: 16)),
                              ),
                              const SizedBox(width: 10),
                              if (_currentStep > 0)
                                TextButton(
                                  onPressed: details.onStepCancel,
                                  child: Text('Back', style: TextStyle(color: kDarkBlue, fontSize: 16)), // Changed to dark blue
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
                          content: Container( // Box for Owner Step 1 form fields
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.2),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Form( // Form for Owner Step 1
                              key: _ownerStep1FormKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _fullNameController,
                                    decoration: InputDecoration(
                                      labelText: 'Full Name',
                                      prefixIcon: Icon(Icons.person, color: kDarkBlue), // Changed to dark blue
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your full name';
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
                                      prefixIcon: Icon(Icons.email, color: kDarkBlue), // Changed to dark blue
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
                                    obscureText: !_isPasswordVisible, // Toggles visibility
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      prefixIcon: Icon(Icons.lock, color: kDarkBlue), // Changed to dark blue
                                      suffixIcon: IconButton( // Password visibility toggle
                                        icon: Icon(
                                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                          color: kDarkBlue, // Changed to dark blue
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
                                    obscureText: !_isConfirmPasswordVisible, // Toggles visibility
                                    decoration: InputDecoration(
                                      labelText: 'Confirm Password',
                                      prefixIcon: Icon(Icons.lock, color: kDarkBlue), // Changed to dark blue
                                      suffixIcon: IconButton( // Confirm password visibility toggle
                                        icon: Icon(
                                          _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                          color: kDarkBlue, // Changed to dark blue
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
                          content: Container( // Box for Owner Step 2 form fields
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.2),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Form( // Form for Owner Step 2
                              key: _ownerStep2FormKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _hotelNameController,
                                    decoration: InputDecoration(
                                      labelText: 'Hotel Name',
                                      prefixIcon: Icon(Icons.business, color: kDarkBlue), // Changed to dark blue
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
                                      prefixIcon: Icon(Icons.location_on, color: kDarkBlue), // Changed to dark blue
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
                                      prefixIcon: Icon(Icons.phone, color: kDarkBlue), // Changed to dark blue
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (_selectedRole == 'Owner' && (value == null || value.isEmpty)) {
                                        return 'Please enter contact number';
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
                                      prefixIcon: Icon(Icons.description, color: kDarkBlue), // Changed to dark blue
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
                                      prefixIcon: Icon(Icons.confirmation_number, color: kDarkBlue), // Changed to dark blue
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
                                      prefixIcon: Icon(Icons.hotel, color: kDarkBlue), // Changed to dark blue
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
                                    controller: _hotelWebsiteController,
                                    decoration: InputDecoration(
                                      labelText: 'Hotel Website (Optional)',
                                      prefixIcon: Icon(Icons.link, color: kDarkBlue), // Changed to dark blue
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Step(
                          title: const Text('Agreement'),
                          isActive: _currentStep >= 2,
                          state: _currentStep > 2 ? StepState.complete : StepState.indexed,
                          content: Container( // Box for Agreement section
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.2),
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
                                  activeColor: kPrimaryBlue, // Changed to primary blue
                                  onChanged: (value) {
                                    setState(() {
                                      _agreedToTerms = value!;
                                    });
                                  },
                                  title: RichText( // Using RichText to make part of the text clickable
                                    // Removed maxLines and overflow to allow for multi-line display
                                    text: TextSpan(
                                      text: 'By signing in or registering, you are deemed to have agreed to the ', // Added introductory phrase
                                      style: Theme.of(context).textTheme.bodyMedium, // Inherit default text style
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Terms and Conditions',
                                          style: TextStyle(
                                            color: kPrimaryBlue, // Make link text blue
                                            decoration: TextDecoration.underline, // Underline the link
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              // Navigate to the TermsConditionsScreen
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
                    child: Text('Login', style: TextStyle(color: kPrimaryBlue, fontSize: 16)), // Changed to primary blue
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