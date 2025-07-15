import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _selectedRole = 'Guest';
  int _currentStep = 0;

  final _formKey = GlobalKey<FormState>();

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedRole == 'Owner') {
        Navigator.pushReplacementNamed(context, '/owner');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBE9E7),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                Image.asset('assets/logo.png', height: 80),
                const SizedBox(height: 12),
                const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF5D4037)),
                ),
                const SizedBox(height: 10),

                // Dropdown for Account Type
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Account Type',
                    prefixIcon: const Icon(Icons.account_circle, color: Color(0xFF795548)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Guest', child: Text('Guest')),
                    DropdownMenuItem(value: 'Owner', child: Text('Hotel Owner')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                      _currentStep = 0;
                    });
                  },
                ),
                const SizedBox(height: 20),

                _selectedRole == 'Guest'
                    ? Column(
                        children: [
                          TextFormField(
                            controller: _fullNameController,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              prefixIcon: const Icon(Icons.person, color: Color(0xFF795548)),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              prefixIcon: const Icon(Icons.email, color: Color(0xFF795548)),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock, color: Color(0xFF795548)),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              prefixIcon: const Icon(Icons.lock, color: Color(0xFF795548)),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00796B),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              minimumSize: const Size.fromHeight(50),
                            ),
                            child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      )
                    : Stepper(
                        currentStep: _currentStep,
                        onStepContinue: () {
                          if (_currentStep < 2) {
                            setState(() {
                              _currentStep += 1;
                            });
                          } else {
                            _submitForm();
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
                          return Row(
                            children: [
                              ElevatedButton(
                                onPressed: details.onStepContinue,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00796B),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                child: Text(_currentStep == 2 ? 'Submit' : 'Next'),
                              ),
                              const SizedBox(width: 10),
                              if (_currentStep > 0)
                                TextButton(
                                  onPressed: details.onStepCancel,
                                  child: const Text('Back'),
                                ),
                            ],
                          );
                        },
                        steps: [
                          Step(
                            title: const Text('Account Info'),
                            isActive: _currentStep >= 0,
                            content: Column(
                              children: [
                                TextFormField(
                                  controller: _fullNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Full Name',
                                    prefixIcon: const Icon(Icons.person, color: Color(0xFF795548)),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email Address',
                                    prefixIcon: const Icon(Icons.email, color: Color(0xFF795548)),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: const Icon(Icons.lock, color: Color(0xFF795548)),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Confirm Password',
                                    prefixIcon: const Icon(Icons.lock, color: Color(0xFF795548)),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Step(
                            title: const Text('Hotel Info'),
                            isActive: _currentStep >= 1,
                            content: Column(
                              children: [
                                TextFormField(
                                  controller: _hotelNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Hotel Name',
                                    prefixIcon: const Icon(Icons.business, color: Color(0xFF795548)),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _hotelAddressController,
                                  decoration: InputDecoration(
                                    labelText: 'Hotel Address',
                                    prefixIcon: const Icon(Icons.location_on, color: Color(0xFF795548)),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _contactNumberController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    labelText: 'Contact Number',
                                    prefixIcon: const Icon(Icons.phone, color: Color(0xFF795548)),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _hotelDescriptionController,
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                    labelText: 'Hotel Description',
                                    prefixIcon: const Icon(Icons.description, color: Color(0xFF795548)),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _licenseNumberController,
                                  decoration: InputDecoration(
                                    labelText: 'Hotel License Number',
                                    prefixIcon: const Icon(Icons.confirmation_number, color: Color(0xFF795548)),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _roomCountController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Number of Rooms',
                                    prefixIcon: const Icon(Icons.hotel, color: Color(0xFF795548)),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _hotelWebsiteController,
                                  decoration: InputDecoration(
                                    labelText: 'Hotel Website (Optional)',
                                    prefixIcon: const Icon(Icons.link, color: Color(0xFF795548)),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Step(
                            title: const Text('Agreement'),
                            isActive: _currentStep >= 2,
                            content: Column(
                              children: [
                                CheckboxListTile(
                                  value: _agreedToTerms,
                                  activeColor: const Color(0xFF00796B),
                                  onChanged: (value) {
                                    setState(() {
                                      _agreedToTerms = value!;
                                    });
                                  },
                                  title: const Text(
                                    'I agree to the Terms and Conditions',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  controlAffinity: ListTileControlAffinity.leading,
                                ),
                                if (!_agreedToTerms)
                                  const Text(
                                    '*You must agree before submitting.',
                                    style: TextStyle(color: Colors.red, fontSize: 12),
                                  ),
                              ],
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
                      child: const Text('Login', style: TextStyle(color: Color(0xFF00796B))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
