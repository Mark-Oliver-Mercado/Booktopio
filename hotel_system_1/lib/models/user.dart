class User {
  final String fullName;
  final String email;
  final String password;
  final String role;  // 'Guest' or 'Owner'

  User({
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
  });
}