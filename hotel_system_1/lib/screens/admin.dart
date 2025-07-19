import 'package:flutter/material.dart';
import '../auth/signup.dart';
import '../screens/admin_settings.dart';
import '../screens/add_room_screen.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> rooms = [
    'Room 101', 'Room 111', 'Room 150', 'Room 201', 'Room A1',
    'Room A2', 'Room B1', 'Room B2', 'Room B3', 'Room B4',
    'Room C2', 'Room C3', 'Room C4', 'Room C5', 'Suite 1', 'Penthouse'
  ];

  Map<String, String> roomStatus = {}; // 'available', 'booked', 'completed', 'cleaning'

  @override
  void initState() {
    super.initState();
    _initializeRoomData();
  }

  void _initializeRoomData() {
    roomStatus.clear();
    for (var room in rooms) {
      roomStatus[room] = 'available';

      if (room == 'Room 101' || room == 'Room B2') {
        roomStatus[room] = 'booked';
      } else if (room == 'Room 150' || room == 'Room C4') {
        roomStatus[room] = 'completed';
      } else if (room == 'Room A1') {
        roomStatus[room] = 'cleaning';
      }
    }
    setState(() {});
  }

  void _onNewRoomAdded() {
    final String newRoomName = 'Room ${rooms.length + 101}';
    setState(() {
      rooms.add(newRoomName);
      roomStatus[newRoomName] = 'available';
      _initializeRoomData();
    });
    print('New room added: $newRoomName. Total rooms: ${rooms.length}');
  }

  @override
  Widget build(BuildContext context) {
    int totalBooked = roomStatus.values.where((s) => s == 'booked').length;
    int totalCompleted = roomStatus.values.where((s) => s == 'completed').length;
    int totalAvailable = roomStatus.values.where((s) => s == 'available').length;
    int totalCleaning = roomStatus.values.where((s) => s == 'cleaning').length;
    int totalRooms = rooms.length;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'BOOKTOPIA Admin',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
      ),
      drawer: _buildDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isSmallScreen = constraints.maxWidth < 600;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 20),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isSmallScreen ? 2 : 4,
                  childAspectRatio: 1.5,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildStatCard('TOTAL ROOMS', '$totalRooms', const Color(0xFF1A5276)),
                    _buildStatCard('AVAILABLE', '$totalAvailable', const Color(0xFF27AE60)),
                    _buildStatCard('BOOKED', '$totalBooked', const Color(0xFFE74C3C)),
                    _buildStatCard('COMPLETED', '$totalCompleted', const Color(0xFF2980B9)),
                    _buildStatCard('CLEANING', '$totalCleaning', const Color(0xFFF39C12)),
                  ],
                ),
                const SizedBox(height: 30),

                const Text(
                  'Room Status & Management',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1), // Using withValues as requested
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: rooms.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isSmallScreen ? 3 : 5,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      final room = rooms[index];
                      final status = roomStatus[room];

                      Color tileColor;
                      IconData icon;
                      Color iconColor = Colors.white;

                      switch (status) {
                        case 'booked':
                          tileColor = const Color(0xFFE74C3C);
                          icon = Icons.event_busy;
                          break;
                        case 'completed':
                          tileColor = const Color(0xFF2980B9);
                          icon = Icons.check_circle_outline;
                          break;
                        case 'cleaning':
                          tileColor = const Color(0xFFF39C12);
                          icon = Icons.cleaning_services;
                          break;
                        case 'available':
                        default:
                          tileColor = const Color(0xFF27AE60);
                          icon = Icons.hotel;
                          break;
                      }

                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (status == 'available') {
                              roomStatus[room] = 'booked';
                            } else if (status == 'booked') {
                              roomStatus[room] = 'completed';
                            } else if (status == 'completed') {
                              roomStatus[room] = 'cleaning';
                            } else if (status == 'cleaning') {
                              roomStatus[room] = 'available';
                            } else {
                              roomStatus[room] = 'available';
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          color: tileColor,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(icon, color: iconColor, size: isSmallScreen ? 28 : 36),
                                const SizedBox(height: 4),
                                Text(
                                  room,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isSmallScreen ? 10 : 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  status!.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: isSmallScreen ? 8 : 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Builds the navigation drawer with a more modern look.
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF2E7D32),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.hotel_outlined, color: Colors.white, size: 48),
                const SizedBox(height: 8),
                const Text(
                  'Booktopia Hotel',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Admin Panel',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14), // Using withValues as requested
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.dashboard_rounded, 'Dashboard', () {
            Navigator.pop(context);
          }),
          _buildDrawerItem(Icons.home_work_rounded, 'Add Rooms', () async {
            Navigator.pop(context);
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddRoomScreen(
                  onRoomAdded: () {
                    _onNewRoomAdded();
                  },
                  existingRoomNames: List.from(rooms),
                ),
              ),
            );
          }),
          _buildDrawerItem(Icons.settings_rounded, 'Settings', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminSettingsScreen()),
            );
          }),
          const Divider(),
          _buildDrawerItem(Icons.logout_rounded, 'Logout', () {
            Navigator.pop(context); // Close the drawer first
            _showLogoutConfirmationDialog(context); // Call the new confirmation dialog
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title, style: const TextStyle(fontSize: 16, color: Color(0xFF333333))),
      onTap: onTap,
      hoverColor: const Color(0xFFE8F5E9),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        color: color,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- New Confirmation Dialog Method ---
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE74C3C), // A red color for logout confirmation
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                // Perform the actual logout action
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  (Route<dynamic> route) => false,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('You have been logged out.')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}