import '../models/user.dart'; // Import your User model

class UserManager {
  static final List<User> _users = [
    // Pre-populate with a default admin user for testing
    User(fullName: 'Admin User', email: 'admin@booktopia.com', password: 'adminpassword', role: 'Owner'),
    // You can add more default users here if needed
    User(fullName: 'Guest User', email: 'guest@example.com', password: 'guestpassword', role: 'Guest'),
  ]; // In-memory storage

  // Register user (called from signup)
  static void registerUser(User user) {
    if (!emailExists(user.email)) {
      _users.add(user);
      ('User registered: ${user.email}, Role: ${user.role}'); // For debugging
    } else {
      ('Registration failed: Email ${user.email} already exists.'); // For debugging
    }
  }

  // Login user (called from login screen)
  static User? loginUser(String email, String password) {
    try {
      final user = _users.firstWhere(
        (user) => user.email == email && user.password == password,
      );
      ('Login successful for: ${user.email}, Role: ${user.role}'); // For debugging
      return user;
    } catch (e) {
      ('Login failed for email: $email. Error: $e'); // For debugging
      return null;
    }
  }

  // Optional: Check if email exists (for duplicate emails)
  static bool emailExists(String email) {
    return _users.any((user) => user.email == email);
  }

  // Method to get all users (for admin panel, if needed)
  static List<User> getAllUsers() {
    return List.from(_users); // Return a copy to prevent external modification
  }
}
