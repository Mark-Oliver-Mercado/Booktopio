import 'package:flutter/material.dart';

// Define the new blue and white color scheme constants
const Color kPrimaryBlue = Color(0xFF0065FF); // A vibrant blue for primary elements
const Color kDarkBlue = Color(0xFF003C99); // A darker blue for text/icons
const Color kLightBlue = Color(0xFFE6F2FF); // A very light blue for backgrounds
const Color kAccentBlue = Color(0xFF007BFF); // An accent blue for highlights

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for text input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State variable for password visibility
  bool _isPasswordVisible = false;

  // Global key for form validation
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Function to handle login form submission
  void _submitLogin() {
    // Validate the form before proceeding
    if (_formKey.currentState!.validate()) {
      // If the form is valid, proceed with login logic
      // For demonstration, we'll navigate to the home page
      // In a real app, you would integrate with an authentication service here
      Navigator.pushReplacementNamed(context, '/'); // Navigate to the home screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBlue, // Changed to light blue background color
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column( // Removed the top-level Form widget to wrap specific sections
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Image.asset('assets/logo.png', height: 150), // Increased height for prominence
              const SizedBox(height: 24), // Adjusted spacing

              // Title
              Text(
                'Lima Hotel',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: kDarkBlue, // Changed to dark blue
                  fontFamily: 'Georgia', // Custom font for branding
                ),
              ),

              const SizedBox(height: 10),
              Text(
                'Welcome back! Book your stay with comfort.',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade700), // Adjusted grey text for subtitle
              ),

              const SizedBox(height: 30),

              Container( // Box for login form fields
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2), // Using withValues for alpha
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form( // Use Form widget for validation
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress, // Set keyboard type for email
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: kDarkBlue, // Changed to dark blue
                          ),
                          labelText: 'Email Address',
                          labelStyle: TextStyle(color: kDarkBlue), // Changed to dark blue
                          hintText: 'Enter your email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14), // Rounded corners
                          ),
                          filled: true, // Make the field filled
                          fillColor: Colors.white, // White fill color
                          enabledBorder: OutlineInputBorder( // Ensure border is visible when not focused
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder( // Highlight when focused
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: kAccentBlue, width: 2), // Changed to accent blue
                          ),
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

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible, // Toggles visibility
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: kDarkBlue, // Changed to dark blue
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: kDarkBlue), // Changed to dark blue
                          hintText: 'Enter your password',
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14), // Rounded corners
                          ),
                          filled: true, // Make the field filled
                          fillColor: Colors.white, // White fill color
                          enabledBorder: OutlineInputBorder( // Ensure border is visible when not focused
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder( // Highlight when focused
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: kAccentBlue, width: 2), // Changed to accent blue
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // Forgot Password Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Logic for forgot password. Could navigate to a new screen.
                            // Example: 
                            Navigator.pushNamed(context, '/forgot_password_screen');
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: kPrimaryBlue), // Changed to primary blue
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Login Button
                      SizedBox(
                        width: double.infinity, // Button takes full width
                        child: ElevatedButton(
                          onPressed: _submitLogin, // Call the submit function
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryBlue, // Changed to primary blue
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14), // Rounded corners
                            ),
                            elevation: 5, // Add shadow for depth
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              const SizedBox(height: 25),

              // OR Divider
              Row(
                children: [
                  const Expanded(child: Divider(color: Colors.grey)), // Grey divider lines
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Or sign in with',
                      style: TextStyle(color: Colors.grey.shade700), // Adjusted grey text
                    ),
                  ),
                  const Expanded(child: Divider(color: Colors.grey)),
                ],
              ),

              const SizedBox(height: 20),

              // Social Logins
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSocialButton('assets/google.png'),
                  _buildSocialButton('assets/apple.png'),
                  _buildSocialButton('assets/facebook.png'),
                ],
              ),

              const SizedBox(height: 30),

              // Sign Up Button at Bottom
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      // Navigate to the signup screen
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: kPrimaryBlue, fontSize: 16), // Changed to primary blue
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build social login buttons
  static Widget _buildSocialButton(String assetPath) {
    return InkWell(
      onTap: () {
        // Add social login logic here (e.g., Google, Apple, Facebook sign-in)
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withValues(alpha: 0.1), // Using withValues for alpha
              blurRadius: 3,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Image.asset(assetPath, width: 22, height: 22),
      ),
    );
  }
}
