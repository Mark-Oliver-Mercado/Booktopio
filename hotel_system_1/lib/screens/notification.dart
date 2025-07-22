import 'package:flutter/material.dart';
import '../utils/constants.dart';


// 1. NotificationScreen: Now a StatefulWidget to manage its own internal state.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Local state variables for notification settings
  bool _areNotificationsEnabled = true;
  bool _isSoundEnabled = true;
  bool _isVibrationEnabled = true;

  /// Toggles the overall notification setting.
  void _toggleNotifications(bool newValue) {
    setState(() {
      _areNotificationsEnabled = newValue;
      // If notifications are disabled, also disable sound and vibration
      if (!newValue) {
        _isSoundEnabled = false;
        _isVibrationEnabled = false;
      }
    });
  }

  /// Toggles the sound setting.
  void _toggleSound(bool newValue) {
    setState(() {
      _isSoundEnabled = newValue;
    });
  }

  /// Toggles the vibration setting.
  void _toggleVibration(bool newValue) {
    setState(() {
      _isVibrationEnabled = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBlue,
      appBar: AppBar(
        title: const Text(
          'Notification Settings',
          style: TextStyle(color: kWhite),
        ),
        backgroundColor: kPrimaryBlue,
        iconTheme: const IconThemeData(color: kWhite),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General Notifications',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: kDarkBlue,
              ),
            ),
            const SizedBox(height: 8.0),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Enable Notifications',
                      style: TextStyle(fontSize: 16.0, color: kDarkBlue),
                    ),
                    Switch(
                      value: _areNotificationsEnabled, // Use local state
                      onChanged: (newValue) {
                        _toggleNotifications(
                          newValue,
                        ); // Call local toggle method
                      },
                      activeColor: kPrimaryBlue,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              'Notification Preferences',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: kDarkBlue,
              ),
            ),
            const SizedBox(height: 8.0),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text('Sound', style: TextStyle(color: kDarkBlue)),
                    trailing: Switch(
                      value: _isSoundEnabled, // Use local state
                      onChanged:
                          _areNotificationsEnabled // Check local state for enabling/disabling
                          ? (newValue) {
                              _toggleSound(
                                newValue,
                              ); // Call local toggle method
                            }
                          : null,
                      activeColor: kPrimaryBlue,
                    ),
                  ),
                  const Divider(height: 1.0, indent: 16.0, endIndent: 16.0),
                  ListTile(
                    title: Text(
                      'Vibration',
                      style: TextStyle(color: kDarkBlue),
                    ),
                    trailing: Switch(
                      value: _isVibrationEnabled, // Use local state
                      onChanged:
                          _areNotificationsEnabled // Check local state for enabling/disabling
                          ? (newValue) {
                              _toggleVibration(
                                newValue,
                              ); // Call local toggle method
                            }
                          : null,
                      activeColor: kPrimaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// The main.dart example is no longer necessary as Provider is removed.
// You would simply run your app with NotificationScreen as the home widget.
/*
void main() {
  runApp(
    MaterialApp(
      title: 'Notification Settings App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const NotificationScreen(),
    ),
  );
}
*/
