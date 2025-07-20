import 'package:flutter/material.dart';

const Color kPrimaryBlue = Color(0xFF1E88E5);
const Color kWhite = Colors.white;

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Settings', style: TextStyle(color: kWhite)),
        backgroundColor: kPrimaryBlue,
        iconTheme: const IconThemeData(color: kWhite),
      ),
      body: const Center(
        child: Text('This is the Language Settings Screen content.'),
      ),
    );
  }
}
