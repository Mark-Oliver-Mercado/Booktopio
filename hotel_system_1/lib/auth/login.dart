import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/user_manager.dart'; // Import UserManager
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:video_player/video_player.dart'; // Import video_player

// Custom AnimatedDotLoadingIndicator widget (remains the same)
class AnimatedDotLoadingIndicator extends StatefulWidget {
  const AnimatedDotLoadingIndicator({super.key});

  @override
  State<AnimatedDotLoadingIndicator> createState() =>
      _AnimatedDotLoadingIndicatorState();
}

class _AnimatedDotLoadingIndicatorState
    extends State<AnimatedDotLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Animation<double>> _dotAnimations =
      []; // Use a list for animations

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(
            milliseconds: 1000,
          ), // Duration for one full bounce cycle (up and down)
        )..repeat(
          reverse: true,
        ); // Repeat with reverse to create a ping-pong (bounce) effect

    // Create a staggered animation for each of the four dots
    for (int i = 0; i < 4; i++) {
      _dotAnimations.add(
        Tween<double>(begin: 0.0, end: -15.0).animate(
          // Animate vertical movement from 0 to -15 (upwards)
          CurvedAnimation(
            parent: _controller,
            curve: Interval(
              (i *
                  0.2), // Staggered start point for each dot's animation (e.g., 0.0, 0.2, 0.4, 0.6)
              (i * 0.2) +
                  0.4, // End point for each dot's active animation phase
              curve: Curves
                  .easeOutSine, // Provides a smooth, natural bounce effect
            ),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Helper method to build an individual animated dot
  Widget _buildDot(Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            animation.value,
          ), // Apply the calculated vertical translation
          child: Container(
            width: 12, // Slightly increased size for better visibility
            height: 12,
            margin: const EdgeInsets.symmetric(
              horizontal: 4,
            ), // Spacing between dots
            decoration: const BoxDecoration(
              color: Colors
                  .white, // Changed to white for better contrast against the overlay
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center the row of dots
      children: [
        _buildDot(_dotAnimations[0]),
        _buildDot(_dotAnimations[1]),
        _buildDot(_dotAnimations[2]),
        _buildDot(_dotAnimations[3]),
      ],
    );
  }
}

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

  // State variable to control loading indicator visibility
  bool _isLoading = false;

  // Global key for form validation
  final _formKey = GlobalKey<FormState>();

  // VideoPlayerController for the background video
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    // Initialize the video player with your asset video
    // Ensure 'assets/second_bg.mp4' exists and is declared in pubspec.yaml
    _videoPlayerController =
        VideoPlayerController.asset(
            'assets/second_bg.mp4',
          ) // Corrected video asset name
          ..initialize().then((_) {
            _videoPlayerController.play();
            _videoPlayerController.setLooping(true); // Loop the video
            _videoPlayerController.setVolume(0.0); // Mute the video
            setState(() {}); // Rebuild to show the video
          });
  }

  @override
  void dispose() {
    // Dispose of the controllers and the video player when the widget is removed
    _emailController.dispose();
    _passwordController.dispose();
    _videoPlayerController.dispose(); // Dispose video controller
    super.dispose();
  }

  // Function to handle login form submission
  void _submitLogin() async {
    // Validate the form before proceeding
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      try {
        // Artificial delay for demonstration purposes (remove in production)
        await Future.delayed(const Duration(seconds: 2));

        // Attempt to log in the user
        final user = await UserManager.loginUser(
          _emailController.text,
          _passwordController.text,
        );

        if (user != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('loggedInUserRole', user.role);
          await prefs.setString('loggedInUserEmail', user.email);
          if (user.role == 'Owner') {
            String? hotelName = prefs.getString('hotel_for_${user.email}');
            if (hotelName != null) {
              await prefs.setString('loggedInHotelName', hotelName);
            }
          }

          if (user.role == 'Owner') {
            Navigator.pushReplacementNamed(context, '/admin');
          } else {
            Navigator.pushReplacementNamed(context, '/home');
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid email or password')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          kLightBlue, // This color will now be mostly hidden by the video
      body: Stack(
        children: [
          // Background video fills the entire screen, always visible
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit
                  .cover, // Ensures the video covers the entire available space
              child: SizedBox(
                width: _videoPlayerController.value.isInitialized
                    ? _videoPlayerController.value.size.width
                    : 0,
                height: _videoPlayerController.value.isInitialized
                    ? _videoPlayerController.value.size.height
                    : 0,
                child: VideoPlayer(_videoPlayerController),
              ),
            ),
          ),
          // Semi-transparent overlay to make form elements more readable over the video
          Container(
            color: Colors.black.withOpacity(
              0.5,
            ), // Adjust opacity as needed for readability
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset('assets/logo.png', height: 150),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    'Lima Hotel',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(
                        0xFFD4AF37,
                      ), // Changed to a golden color (hex code for gold)
                      fontFamily: 'Georgia',
                    ),
                  ),

                  const SizedBox(height: 10),
                  Text(
                    'Welcome back! Book your stay with comfort.',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),

                  const SizedBox(height: 30),

                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent, // Changed to transparent
                      borderRadius: BorderRadius.circular(16),
                      // Removed boxShadow to ensure full transparency
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: kDarkBlue,
                              ),
                              labelText: 'Email Address',
                              labelStyle: TextStyle(color: kDarkBlue),
                              hintText: 'Enter your email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              filled: true,
                              fillColor: Colors
                                  .white, // Fill color for the text field itself
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: kAccentBlue,
                                  width: 2,
                                ),
                              ),
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

                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: kDarkBlue,
                              ),
                              labelText: 'Password',
                              labelStyle: TextStyle(color: kDarkBlue),
                              hintText: 'Enter your password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: kDarkBlue,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              filled: true,
                              fillColor: Colors
                                  .white, // Fill color for the text field itself
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: kAccentBlue,
                                  width: 2,
                                ),
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
                                Navigator.pushNamed(
                                  context,
                                  '/forgot_password_screen',
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: kPrimaryBlue,
                                ), // Kept primary blue for emphasis
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submitLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryBlue,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 5,
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
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
                      const Expanded(
                        child: Divider(color: Colors.grey),
                      ), // Dividers remain grey
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Or sign in with',
                          style: TextStyle(
                            color: Colors.white,
                          ), // Changed to white
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: Colors.grey),
                      ), // Dividers remain grey
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Social Logins (colors are handled by images)
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
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.white),
                      ), // Changed to white
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: kPrimaryBlue,
                            fontSize: 16,
                          ), // Kept primary blue for emphasis
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading) // The loading overlay is still conditional
            Container(
              color: Colors.black.withOpacity(
                0.7,
              ), // Semi-transparent black background for loading
              child: const Center(child: AnimatedDotLoadingIndicator()),
            ),
        ],
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
              color: Colors.black12.withOpacity(0.1),
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
