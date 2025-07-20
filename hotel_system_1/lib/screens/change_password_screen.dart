import 'package:flutter/material.dart';

// Ensure all color constants are defined or imported here
const Color kPrimaryBlue = Color(0xFF1E88E5);
const Color kDarkBlue = Color(0xFF1565C0); // A darker shade for text/icons
const Color kLightBlue = Color(0xFFE3F2FD); // A very light blue for backgrounds
const Color kWhite = Colors.white; // Pure white for elements
const Color kGreyText = Color(0xFF757575); // A medium grey for secondary text

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  // State to toggle password visibility
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmNewPasswordVisible = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      // In a real application, you would send these passwords to your backend
      // for verification of current password and update of new password.
      // For this example, we'll just simulate success.

      // Simulate a network call or backend interaction
      Future.delayed(const Duration(seconds: 1), () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        // Optionally clear fields or navigate back after success
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmNewPasswordController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBlue, // Set background color to kLightBlue
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kPrimaryBlue, // AppBar background to kPrimaryBlue
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: kWhite, // Back icon color to white
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Center(
        // Keeps the whole content block centered
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Current Password Field
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: !_isCurrentPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    labelStyle: const TextStyle(color: kGreyText),
                    hintText: 'Enter your current password',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: kDarkBlue,
                    ), // Icon color
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isCurrentPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: kGreyText, // Visibility icon color
                      ),
                      onPressed: () {
                        setState(() {
                          _isCurrentPasswordVisible =
                              !_isCurrentPasswordVisible;
                        });
                      },
                    ),
                    // Use a more subtle border similar to the SupportScreen's search bar
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ), // Subtle grey border
                    ),
                    enabledBorder: OutlineInputBorder(
                      // Define enabled border for consistency
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: kPrimaryBlue,
                        width: 2.0,
                      ), // Focused border uses kPrimaryBlue
                    ),
                    filled: true,
                    fillColor: kWhite, // White fill color
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // New Password Field
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: !_isNewPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle: const TextStyle(color: kGreyText),
                    hintText: 'Enter your new password',
                    prefixIcon: const Icon(
                      Icons.lock_open_outlined,
                      color: kDarkBlue,
                    ), // Icon color
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isNewPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: kGreyText, // Visibility icon color
                      ),
                      onPressed: () {
                        setState(() {
                          _isNewPasswordVisible = !_isNewPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: kPrimaryBlue,
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    fillColor: kWhite,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    if (_currentPasswordController.text == value) {
                      return 'New password cannot be the same as current password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Confirm New Password Field
                TextFormField(
                  controller: _confirmNewPasswordController,
                  obscureText: !_isConfirmNewPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    labelStyle: const TextStyle(color: kGreyText),
                    hintText: 'Re-enter your new password',
                    prefixIcon: const Icon(
                      Icons.lock_reset,
                      color: kDarkBlue,
                    ), // Icon color
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmNewPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: kGreyText, // Visibility icon color
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmNewPasswordVisible =
                              !_isConfirmNewPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: kPrimaryBlue,
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    fillColor: kWhite,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your new password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Save Button
                SizedBox(
                  width: double.infinity, // Make button full width
                  child: ElevatedButton(
                    onPressed: _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryBlue, // Button background color
                      foregroundColor: kWhite, // Text and icon color
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Save New Password',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
