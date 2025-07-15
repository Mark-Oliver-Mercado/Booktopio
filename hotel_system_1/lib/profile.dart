// profile.dart
import 'package:flutter/material.dart';
// Ensure notifications_screen.dart is imported if it's not already
// import 'notifications_screen.dart'; // Only needed if you were navigating directly, but using named routes is better

// Define the main green color and its variations for consistency based on home.dart
const Color kPrimaryGreen = Color(0xFF73C088); // A refreshing mid-green
const Color kDarkGreen = Color(0xFF235D3A); // A darker shade for text/icons
const Color kLightGreen = Color(
  0xFFC8EAD1,
); // A very light green for backgrounds
const Color kAppBarTitleGreen = Color(
  0xFF397D54,
); // A darker green for high contrast titles
const Color kButtonGreen = Color(0xFFA8E0B7); // A mid-light green for buttons

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGreen, // Set Scaffold background to kLightGreen
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white, // Changed to white
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:
            kPrimaryGreen, // New refreshing green for app bar background
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // Removed the Container with color, as Scaffold backgroundColor handles it now
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    // Using a placeholder image that aligns with the new color scheme
                    backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150/${kPrimaryGreen.value.toRadixString(16).substring(2, 8).toUpperCase()}/FFFFFF?text=JP',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'John P. Doe',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color:
                          kDarkGreen, // A dark shade of the new green for text
                    ),
                  ),
                  const Text(
                    'john.doe@example.com',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildProfileOption(context, 'Edit Profile', Icons.edit, () {
              // Navigate to Edit Profile screen (if you create one)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edit Profile Screen (Not yet implemented)'),
                ),
              );
            }),
            _buildProfileOption(context, 'Change Password', Icons.lock, () {
              // Navigate to Change Password screen (if you create one)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Change Password Screen (Not yet implemented)'),
                ),
              );
            }),
            _buildProfileOption(
              context,
              'Notifications',
              Icons.notifications,
              () {
                Navigator.pushNamed(
                  context,
                  '/notifications',
                ); // This line is now active
              },
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Implement logout logic
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kDarkGreen, // A darker green for the button
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: kDarkGreen,
          ), // Icon color matching the dark green
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: kDarkGreen,
            ), // Text color matching the profile name
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
          onTap: onTap,
        ),
        const Divider(height: 1.0),
      ],
    );
  }
}
