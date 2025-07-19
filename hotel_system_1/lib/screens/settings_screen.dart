// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';

// Updated color definitions based on the provided image palette
const Color kPrimaryBlue = Color(0xFF1E88E5); // A distinct blue for app bars and accents (from image)
const Color kDarkBlue = Color(0xFF1565C0); // A darker shade for text/icons (from image)
const Color kLightBlue = Color(0xFFE3F2FD); // A very light blue for backgrounds (from image)
const Color kWhite = Colors.white; // Pure white for elements
const Color kGreyText = Color(0xFF757575); // A medium grey for secondary text (from image/common practice)

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
              // Consider using Navigator.push to a dedicated EditProfileScreen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit Profile tapped!')),
              );
            },
          ),
          _buildSettingTile(
            icon: Icons.lock,
            title: 'Change Password',
            onTap: () {
              // Navigate to change password screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Change Password tapped!')),
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Language settings tapped!')),
              );
            },
          ),
          _buildSettingTile(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () {
              // Navigate to notification settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification settings tapped!')),
              );
            },
          ),
          _buildSettingTile(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            trailing: Switch(
              value: false, // Replace with real theme toggle state
              onChanged: (value) {
                // Handle dark mode toggle
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Dark Mode toggled: $value')),
                );
              },
              activeColor: kPrimaryBlue, // Set switch active color to kPrimaryBlue
            ),
            onTap: () {}, // Placeholder to satisfy required parameter for ListTile
          ),

          const Divider(color: kLightBlue), // Changed divider color

          _buildSectionHeader('Legal'),
          _buildSettingTile(
            icon: Icons.description,
            title: 'Terms & Conditions',
            onTap: () {
              Navigator.pushNamed(context, '/terms_conditions');
            },
          ),
          _buildSettingTile(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            onTap: () {
              // Navigate to privacy policy screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy Policy tapped!')),
              );
            },
          ),

          const Divider(color: kLightBlue), // Changed divider color

          _buildSectionHeader('Support'),
          _buildSettingTile(
            icon: Icons.support_agent,
            title: 'Customer Support',
            onTap: () {
              Navigator.pushNamed(context, '/support');
            },
          ),
          _buildSettingTile(
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            onTap: () {
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
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Logout', style: TextStyle(color: kDarkBlue)), // Changed title color
                  content: const Text('Are you sure you want to logout?', style: TextStyle(color: kGreyText)), // Changed content color
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: kDarkBlue), // Changed button text color
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.red), // Keep logout button red
                      child: const Text('Logout'),
                      onPressed: () {
                        Navigator.pop(context);
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
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: kGreyText)) : null, // Subtitle color
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