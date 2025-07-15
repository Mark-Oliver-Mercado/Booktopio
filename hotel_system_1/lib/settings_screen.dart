import 'package:flutter/material.dart';

// Define the main green color and its variations for consistency
// These should ideally be in a shared constants file, but for this example,
// we'll define them here to match the home.dart file.
const Color kPrimaryGreen = Color(0xFF73C088); // A refreshing mid-green
const Color kDarkGreen = Color(0xFF235D3A); // A darker shade for text/icons

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white), // Set title text to white
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white, // Set back arrow icon to white
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor:
            kPrimaryGreen, // Set app bar background to kPrimaryGreen
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
            },
          ),
          _buildSettingTile(
            icon: Icons.lock,
            title: 'Change Password',
            onTap: () {
              // Navigate to change password screen
            },
          ),

          const Divider(),

          _buildSectionHeader('Preferences'),
          _buildSettingTile(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'English',
            onTap: () {
              // Navigate to language settings
            },
          ),
          _buildSettingTile(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () {
              // Navigate to notification settings
            },
          ),
          _buildSettingTile(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            trailing: Switch(
              value: false, // Replace with real theme toggle state
              onChanged: (value) {
                // Handle dark mode toggle
              },
            ),
            onTap: () {}, // Placeholder to satisfy required parameter
          ),

          const Divider(),

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
            },
          ),

          const Divider(),

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

          const Divider(),

          _buildSettingTile(
            icon: Icons.logout,
            title: 'Logout',
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
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
    Color iconColor =
        kPrimaryGreen, // Default icon color changed to kPrimaryGreen
    Color textColor = Colors.black, // Default text color remains black
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing:
          trailing ??
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: kPrimaryGreen,
          ), // Changed trailing icon color
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
          color: kDarkGreen, // Section header text color changed to kDarkGreen
          fontSize: 13,
        ),
      ),
    );
  }
}
