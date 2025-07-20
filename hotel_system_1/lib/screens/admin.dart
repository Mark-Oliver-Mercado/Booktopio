import 'package:flutter/material.dart';
import '../auth/signup.dart';
import '../screens/admin_settings.dart'; // Make sure this provides a content widget, not a full Scaffold
import '../screens/add_room_screen.dart'; // Make sure this provides a content widget, not a full Scaffold
import '../screens/transaction_screen.dart'; // Import the new content widget

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<String> rooms = [
    'Room 101',
    'Room 111',
    'Room 150',
    'Room 201',
    'Room A1',
    'Room A2',
    'Room B1',
    'Room B2',
    'Room B3',
    'Room B4',
    'Room C2',
    'Room C3',
    'Room C4',
    'Room C5',
    'Suite 1',
    'Penthouse',
  ];

  Map<String, String> roomStatus = {};
  int _selectedDrawerIndex = 0; // New state variable for selected index

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

  // Helper to get the content widget based on the selected drawer index
  Widget _getScreenWidget(int index) {
    switch (index) {
      case 0:
        return _buildDashboardContent(); // The existing dashboard content
      case 1:
        return AddRoomScreenContent(
          // Use the content widget
          onRoomAdded: (String newRoomName) {
            setState(() {
              rooms.add(newRoomName);
              roomStatus[newRoomName] = 'available';
            });
          },
          existingRoomNames: List.from(rooms),
        );
      case 2:
        return const AdminSettingsScreenContent(); // Use the content widget
      case 3:
        return TransactionScreenContent(); // Use the content widget
      default:
        return _buildDashboardContent();
    }
  }

  // Extract your dashboard content into a separate widget for clarity
  Widget _buildDashboardContent() {
    int totalBooked = roomStatus.values.where((s) => s == 'booked').length;
    int totalCompleted = roomStatus.values
        .where((s) => s == 'completed')
        .length;
    int totalAvailable = roomStatus.values
        .where((s) => s == 'available')
        .length;
    int totalCleaning = roomStatus.values.where((s) => s == 'cleaning').length;
    int totalRooms = rooms.length;
    final bool isSmallScreen = MediaQuery.of(context).size.width < 800;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard Overview',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isSmallScreen ? 2 : 4,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1.7,
            children: [
              _buildStatCard(
                'TOTAL ROOMS',
                '$totalRooms',
                const Color(0xFF1A5276),
              ),
              _buildStatCard(
                'AVAILABLE',
                '$totalAvailable',
                const Color(0xFF27AE60),
              ),
              _buildStatCard('BOOKED', '$totalBooked', const Color(0xFFE74C3C)),
              _buildStatCard(
                'COMPLETED',
                '$totalCompleted',
                const Color(0xFF2980B9),
              ),
              _buildStatCard(
                'CLEANING',
                '$totalCleaning',
                const Color(0xFFF39C12),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            'Manage Room Status',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rooms.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isSmallScreen ? 3 : 5,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final room = rooms[index];
              final status = roomStatus[room];
              Color tileColor;
              IconData icon;
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
                    } else {
                      roomStatus[room] = 'available';
                    }
                  });
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    color: tileColor,
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          color: Colors.white,
                          size: isSmallScreen ? 26 : 32,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          room,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          status!.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      // Remove the appBar property entirely
      // appBar: isSmallScreen
      //     ? AppBar(
      //         title: const Text(
      //           '',
      //         ),
      //         backgroundColor: Colors.transparent,
      //         elevation: 0,
      //         iconTheme: const IconThemeData(color: Colors.black),
      //       )
      //     : AppBar(
      //         title: const Text(
      //           '',
      //         ),
      //         backgroundColor: Colors.transparent,
      //         elevation: 0,
      //         automaticallyImplyLeading: false,
      //       ),
      drawer: isSmallScreen ? _buildDrawer() : null,
      body: Row(
        children: [
          // Persistent sidebar for larger screens
          if (!isSmallScreen)
            Container(
              width: 250,
              color: const Color(
                0xFF2E7D32,
              ), // Green color for the persistent sidebar
              child: _buildWebSidebar(),
            ),
          Expanded(
            // Display the selected screen content here
            child: _getScreenWidget(_selectedDrawerIndex),
          ),
        ],
      ),
    );
  }

  Widget _buildWebSidebar() {
    return ListView(
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Color(0xFF2E7D32),
          ), // Green color for DrawerHeader
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.hotel_outlined, color: Colors.white, size: 40),
              SizedBox(height: 10),
              Text(
                'Booktopia Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        _buildDrawerItem(Icons.dashboard, 'Dashboard', 0), // Pass index
        _buildDrawerItem(Icons.home_work, 'Add Rooms', 1), // Pass index
        _buildDrawerItem(Icons.settings, 'Settings', 2), // Pass index
        _buildDrawerItem(Icons.receipt_long, 'Transactions', 3), // Pass index

        const Divider(color: Colors.white38),
        _buildDrawerItem(
          Icons.logout,
          'Logout',
          4,
        ), // Pass index (or handle logout separately)
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(child: _buildWebSidebar());
  }

  // MODIFIED: onTap now takes an index
  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
      selected: _selectedDrawerIndex == index, // Highlight selected item
      selectedTileColor: Colors.white12, // Color for selected item
      onTap: () {
        setState(() {
          _selectedDrawerIndex = index;
        });
        // Close drawer only for small screens
        if (MediaQuery.of(context).size.width < 800) {
          Navigator.pop(context);
        }

        // Handle logout specifically as it doesn't change content, but navigates away
        if (title == 'Logout') {
          _showLogoutConfirmationDialog(context);
        }
      },
      hoverColor: Colors.white24,
    );
  }

  // ✅ FIXED HERE using FittedBox to prevent overflow
  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        color: color,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE74C3C),
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop();
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
