// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import '../screens/profile.dart'; // Ensure correct path for ProfileScreen
import '../screens/change_password_screen.dart'; // New import
import '../screens/language_screen.dart'; // New import
import 'notification.dart'; // New import

// Updated color definitions based on the provided image palette
const Color kPrimaryBlue = Color(
  0xFF1E88E5,
); // A distinct blue for app bars and accents (from image)
const Color kDarkBlue = Color(
  0xFF1565C0,
); // A darker shade for text/icons (from image)
const Color kLightBlue = Color(
  0xFFE3F2FD,
); // A very light blue for backgrounds (from image)
const Color kWhite = Colors.white; // Pure white for elements
const Color kGreyText = Color(
  0xFF757575,
); // A medium grey for secondary text (from image/common practice)

// Change StatelessWidget to StatefulWidget
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Add state variable for dark mode
  bool _darkModeEnabled = false; // Initialize with default theme preference

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: kWhite), // Set title text to white
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: kWhite, // Set back arrow icon to white
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: kPrimaryBlue, // Set app bar background to kPrimaryBlue
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),

          _buildSectionHeader('Account'),
          _buildSettingTile(
            icon: Icons.person,
            title: 'Edit Profile',
            onTap: () {
              // Navigate to edit profile screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ), // Navigate to ProfileScreen
              );
            },
          ),
          _buildSettingTile(
            icon: Icons.lock,
            title: 'Change Password',
            onTap: () {
              // Navigate to change password screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ), // Navigate to ChangePasswordScreen
              );
            },
          ),

          const Divider(color: kLightBlue), // Changed divider color

          _buildSectionHeader('Preferences'),
          _buildSettingTile(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'English',
            onTap: () {
              // Navigate to language settings
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LanguageScreen(),
                ), // Navigate to LanguageScreen
              );
            },
          ),
          _buildSettingTile(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () {
              // Navigate to notification settings
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ), // Navigate to NotificationSettingsScreen
              );
            },
          ),
          _buildSettingTile(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            trailing: Switch(
              value: _darkModeEnabled, // Bind switch value to state variable
              onChanged: (value) {
                setState(() {
                  _darkModeEnabled = value; // Update state on change
                });
                // Handle dark mode toggle
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Dark Mode toggled: $value')),
                );
                // In a real app, you would notify a global theme provider here.
                // Example: Provider.of<ThemeProvider>(context, listen: false).toggleTheme(value);
              },
              activeColor:
                  kPrimaryBlue, // Set switch active color to kPrimaryBlue
            ),
            // The onTap for a tile with a trailing switch usually handles
            // navigating to a detailed screen if there are more dark mode options.
            // If it's just a toggle, you might make onTap do nothing or
            // trigger the switch's functionality (though the switch already handles it).
            onTap: () {
              // Optionally, you can toggle the switch programmatically here
              // setState(() {
              //   _darkModeEnabled = !_darkModeEnabled;
              // });
            },
          ),

          const Divider(color: kLightBlue), // Changed divider color

          _buildSectionHeader('Legal'),
          _buildSettingTile(
            icon: Icons.description,
            title: 'Terms & Conditions',
            onTap: () {
              // This is already working, no change
              Navigator.pushNamed(context, '/terms_conditions');
            },
          ),
          _buildSettingTile(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            onTap: () {
              Navigator.pushNamed(context, '/privacy_policy');
            },
          ),

          const Divider(color: kLightBlue), // Changed divider color

          _buildSectionHeader('Support'),
          _buildSettingTile(
            icon: Icons.support_agent,
            title: 'Customer Support',
            onTap: () {
              // This is already working, no change
              Navigator.pushNamed(context, '/support');
            },
          ),
          _buildSettingTile(
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            onTap: () {
              // This is already working, no change
              Navigator.pushNamed(context, '/feedback');
            },
          ),

          const Divider(color: kLightBlue), // Changed divider color

          _buildSettingTile(
            icon: Icons.logout,
            title: 'Logout',
            textColor: Colors.red, // Keep logout red for emphasis
            iconColor: Colors.red, // Keep logout icon red
            onTap: () {
              // This is already working, no change
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                    'Confirm Logout',
                    style: TextStyle(color: kDarkBlue),
                  ), // Changed title color
                  content: const Text(
                    'Are you sure you want to logout?',
                    style: TextStyle(color: kGreyText),
                  ), // Changed content color
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: kDarkBlue,
                      ), // Changed button text color
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ), // Keep logout button red
                      child: const Text('Logout'),
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    Color iconColor = kDarkBlue, // Default icon color changed to kDarkBlue
    Color textColor = Colors.black, // Default text color remains black
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor)),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(color: kGreyText))
          : null, // Subtitle color
      trailing:
          trailing ??
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: kDarkBlue, // Changed trailing icon color to kDarkBlue
          ),
      onTap: onTap,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: kDarkBlue, // Section header text color changed to kDarkBlue
          fontSize: 13,
        ),
      ),
    );
  }
}
