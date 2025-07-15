// profile.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Color(0xFFFFCCBC),
        iconTheme: IconThemeData(color: Color(0xFF5D4037)),
      ),
      backgroundColor: const Color(0xFFFBE9E7),
      body: const Center(
        child: Text(
          'User profile details go here.',
          style: TextStyle(fontSize: 18, color: Colors.brown),
        ),
      ),
    );
  }
}
