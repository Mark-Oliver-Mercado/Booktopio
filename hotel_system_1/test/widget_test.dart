// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_system_1/main.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Needed for MyApp constructor

void main() {
  // Ensure Flutter bindings are initialized for tests, especially for SharedPreferences
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App starts at Login Screen and displays login elements', (WidgetTester tester) async {
    // Mock SharedPreferences for testing initial app state.
    // This ensures 'isLoggedIn' is false at the start of the test,
    // directing the app to the LoginScreen as intended by your main.dart logic.
    SharedPreferences.setMockInitialValues({});

    // Build our app. Pass the required arguments to MyApp's constructor.
    // We set isLoggedIn to false to simulate a fresh start where no user is logged in.
    await tester.pumpWidget(
      MyApp(
        isLoggedIn: false,
        initialUserRole: null, // No specific role as user isn't logged in yet
      ),
    );

    // Allow time for any initial animations or route pushes to complete.
    // If your LoginScreen has an initial animation or a FutureBuilder, this helps.
    await tester.pumpAndSettle();

    // Verify that elements from the LoginScreen are displayed.
    // These checks should match the actual text/widgets on your LoginScreen.
    expect(find.text('Email Address'), findsOneWidget); // Assuming your LoginScreen has this label
    expect(find.text('Password'), findsOneWidget);     // Assuming your LoginScreen has this label
    expect(find.byType(ElevatedButton), findsOneWidget); // Find the main login button (by type)
    expect(find.text('Login'), findsOneWidget);         // Assuming the login button has 'Login' text
    expect(find.text("Don't have an account?"), findsOneWidget); // Find the signup prompt
    expect(find.text('Forgot Password?'), findsOneWidget); // Assuming your LoginScreen has this link
  });

  // You can add more specific tests later for different scenarios:
  // - testWidgets('Guest login successful', ...)
  // - testWidgets('Owner login successful and navigates to admin dashboard', ...)
  // - testWidgets('Signup screen displays correctly', ...)
}