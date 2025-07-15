import 'package:flutter/material.dart';
import 'singup.dart'; // ✅ Make sure the file name is correct
import 'roomlist.dart';
import 'login.dart';
import 'home.dart'; // ✅ Add this if you want to go to the home screen after login/signup

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotelio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/signup', // 👈 Start from SignUp
      routes: {
        '/signup': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomePage(),
        '/roomlist': (context) => const RoomListScreen(hotelName: 'Hotel Name'),
      },
    );
  }
}
