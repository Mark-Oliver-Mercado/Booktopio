import 'package:flutter/material.dart';
import '../utils/constants.dart';


class AdminSettingsScreenContent extends StatefulWidget {
  const AdminSettingsScreenContent({Key? key}) : super(key: key);

  @override
  State<AdminSettingsScreenContent> createState() =>
      _AdminSettingsScreenContentState();
}

class _AdminSettingsScreenContentState
    extends State<AdminSettingsScreenContent> {
  bool _isAccountInfoExpanded = false;
  bool _isNotificationsExpanded = false;
  bool _isAboutAppExpanded = false;
  bool _isDarkModeEnabled = false;

  // State to control edit mode for account information
  bool _isEditingAccount = false;

  // Current values for account info (will be displayed statically)
  String _currentUsername = 'admin_user';
  String _currentEmail = 'admin@booktopia.com';

  // Controllers for editing (used only when in edit mode)
  late TextEditingController _editUsernameController;
  late TextEditingController _editEmailController;

  @override
  void initState() {
    super.initState();
    _editUsernameController = TextEditingController(text: _currentUsername);
    _editEmailController = TextEditingController(text: _currentEmail);
  }

  @override
  void dispose() {
    _editUsernameController.dispose();
    _editEmailController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditingAccount = !_isEditingAccount;
      if (_isEditingAccount) {
        // When entering edit mode, populate controllers with current values
        _editUsernameController.text = _currentUsername;
        _editEmailController.text = _currentEmail;
      }
    });
  }

  void _saveAccountInfo() {
    setState(() {
      _currentUsername = _editUsernameController.text.trim();
      _currentEmail = _editEmailController.text.trim();
      _isEditingAccount = false; // Exit edit mode
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Account information saved!')));
  }

  void _cancelEdit() {
    setState(() {
      _isEditingAccount = false; // Exit edit mode without saving
      // Reset controllers to current values
      _editUsernameController.text = _currentUsername;
      _editEmailController.text = _currentEmail;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Edit cancelled.')));
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Admin Settings',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: kDarkText,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Account Information
                    ExpansionTile(
                      leading: Icon(Icons.person, color: kPrimaryGreen),
                      title: const Text('Account Information'),
                      subtitle: const Text('Manage your profile'),
                      initiallyExpanded: _isAccountInfoExpanded,
                      onExpansionChanged: (bool expanded) {
                        setState(() {
                          _isAccountInfoExpanded = expanded;
                          // If collapsing, exit edit mode
                          if (!expanded && _isEditingAccount) {
                            _cancelEdit();
                          }
                        });
                      },
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display static text or editable text fields based on _isEditingAccount
                              _isEditingAccount
                                  ? TextFormField(
                                      controller: _editUsernameController,
                                      decoration: InputDecoration(
                                        labelText: 'Username',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        prefixIcon: Icon(Icons.account_circle),
                                      ),
                                    )
                                  : ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: Icon(
                                        Icons.account_circle,
                                        color: kPrimaryGreen,
                                      ),
                                      title: const Text('Username'),
                                      subtitle: Text(_currentUsername),
                                    ),
                              const SizedBox(height: 12),
                              _isEditingAccount
                                  ? TextFormField(
                                      controller: _editEmailController,
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        prefixIcon: Icon(Icons.email),
                                      ),
                                    )
                                  : ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: Icon(
                                        Icons.email,
                                        color: kPrimaryGreen,
                                      ),
                                      title: const Text('Email'),
                                      subtitle: Text(_currentEmail),
                                    ),
                              const SizedBox(height: 12),
                              // Edit/Save/Cancel Buttons
                              _isEditingAccount
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: _cancelEdit,
                                          child: const Text('Cancel'),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton.icon(
                                          onPressed: _saveAccountInfo,
                                          icon: const Icon(
                                            Icons.save,
                                            color: Colors.white,
                                          ),
                                          label: const Text(
                                            'Save',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: kPrimaryGreen,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: _toggleEditMode,
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                        label: const Text(
                                          'Edit Account Info',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kPrimaryGreen,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(),

                    // Notifications
                    ExpansionTile(
                      leading: Icon(Icons.notifications, color: kPrimaryGreen),
                      title: const Text('Notifications'),
                      subtitle: const Text(
                        'Configure notification preferences',
                      ),
                      initiallyExpanded: _isNotificationsExpanded,
                      onExpansionChanged: (bool expanded) {
                        setState(() {
                          _isNotificationsExpanded = expanded;
                        });
                      },
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Column(
                            children: [
                              SwitchListTile(
                                title: const Text('Booking Confirmations'),
                                value: true, // Mock data
                                onChanged: (bool value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Booking confirmations: $value',
                                      ),
                                    ),
                                  );
                                },
                                activeColor: kPrimaryGreen,
                              ),
                              SwitchListTile(
                                title: const Text('Payment Reminders'),
                                value: false, // Mock data
                                onChanged: (bool value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Payment reminders: $value',
                                      ),
                                    ),
                                  );
                                },
                                activeColor: kPrimaryGreen,
                              ),
                              SwitchListTile(
                                title: const Text('Promotional Offers'),
                                value: true, // Mock data
                                onChanged: (bool value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Promotional offers: $value',
                                      ),
                                    ),
                                  );
                                },
                                activeColor: kPrimaryGreen,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(),

                    // About App
                    ExpansionTile(
                      leading: Icon(Icons.info, color: kPrimaryGreen),
                      title: const Text('About App'),
                      subtitle: const Text(
                        'Version, licenses, and legal information',
                      ),
                      initiallyExpanded: _isAboutAppExpanded,
                      onExpansionChanged: (bool expanded) {
                        setState(() {
                          _isAboutAppExpanded = expanded;
                        });
                      },
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Booktopia Admin Dashboard',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text('Version: 1.0.0'),
                              Text('Build: 20250720.1'),
                              SizedBox(height: 12),
                              Text(
                                '© 2025 Booktopia Inc. All rights reserved.',
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Legal Information:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('• Terms of Service'),
                              Text('• Privacy Policy'),
                              Text('• Open Source Licenses'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
                      value: _isDarkModeEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _isDarkModeEnabled = value;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Dark mode is now: ${_isDarkModeEnabled ? "On" : "Off"}',
                            ),
                          ),
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
