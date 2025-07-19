import 'package:flutter/material.dart';

// Define the colors used in your AdminDashboard for consistency
const Color kPrimaryGreen = Color(0xFF2E7D32); // App bar green
const Color kDarkText = Color(0xFF333333); // Dark text color

// Renamed class from SettingsScreen to AdminSettingsScreen
class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kPrimaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Settings',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: kDarkText,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.person, color: kPrimaryGreen),
                      title: const Text('Account Information'),
                      subtitle: const Text('Manage your profile and password'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Account settings to be implemented.')),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.notifications, color: kPrimaryGreen),
                      title: const Text('Notifications'),
                      subtitle: const Text('Configure notification preferences'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Notification settings to be implemented.')),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.info, color: kPrimaryGreen),
                      title: const Text('About App'),
                      subtitle: const Text('Version, licenses, and legal information'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('About page to be implemented.')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.dark_mode, color: kPrimaryGreen),
                        const SizedBox(width: 16),
                        const Text('Dark Mode', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Switch(
                      value: false,
                      onChanged: (bool value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Dark mode toggle: $value')),
                        );
                      },
                      activeColor: kPrimaryGreen,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}