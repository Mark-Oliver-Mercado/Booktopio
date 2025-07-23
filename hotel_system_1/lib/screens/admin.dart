import 'package:flutter/material.dart';
import '../auth/signup.dart';
import '../screens/admin_settings.dart';
import '../screens/add_room_screen.dart';
import '../screens/transaction_screen.dart';
import '../screens/room_manager.dart'; // Import RoomManager
import '../models/room.dart'; // Import Room model
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

// Add this extension at the top (after imports) if not already present
extension ColorWithValues on Color {
  Color withValues({double? alpha}) {
    if (alpha != null) {
      return withAlpha((255 * alpha).round());
    }
    return this;
  }
}

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // Remove static rooms list and roomStatus map
  // List<String> rooms = [...];
  // Map<String, String> roomStatus = {};

  int _selectedDrawerIndex = 0;
  String? _loggedInHotelName;

  @override
  void initState() {
    super.initState();
    // No need to initialize static room data anymore
    _loadLoggedInHotelName();
  }

  void _loadLoggedInHotelName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _loggedInHotelName = prefs.getString('loggedInHotelName');
      print('AdminDashboard loaded hotel: ' + (_loggedInHotelName ?? 'null'));
    });
  }

  // Helper to get the content widget based on the selected drawer index
  Widget _getScreenWidget(int index) {
    switch (index) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return AddRoomScreenContent(hotelName: _loggedInHotelName); // Pass hotel name
      case 2:
        return AdminSettingsScreenContent(
          loggedInHotelName: _loggedInHotelName,
        );
      case 3:
        return TransactionScreenContent();
      default:
        return _buildDashboardContent();
    }
  }

  // Extract your dashboard content into a separate widget for clarity
  Widget _buildDashboardContent() {
    // Get rooms dynamically from RoomManager
    final List<Room> currentRooms = RoomManager().rooms;

    int totalBooked = currentRooms.where((r) => r.status == 'booked').length;
    int totalCompleted = currentRooms.where((r) => r.status == 'completed').length;
    int totalAvailable = currentRooms.where((r) => r.status == 'available').length;
    int totalCleaning = currentRooms.where((r) => r.status == 'cleaning').length;
    int totalRooms = currentRooms.length;
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
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isSmallScreen = constraints.maxWidth < 800;
              final double cardMinWidth = isSmallScreen ? 120 : 140;
              final double cardMinHeight = isSmallScreen ? 90 : 110;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isSmallScreen ? 2 : 4,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1.7,
                children: [
                  SizedBox(
                    width: cardMinWidth,
                    height: cardMinHeight,
                    child: _buildStatCard(
                      'TOTAL ROOMS',
                      '$totalRooms',
                      const Color(0xFF1A5276),
                    ),
                  ),
                  SizedBox(
                    width: cardMinWidth,
                    height: cardMinHeight,
                    child: _buildStatCard(
                      'AVAILABLE',
                      '$totalAvailable',
                      const Color(0xFF27AE60),
                    ),
                  ),
                  SizedBox(
                    width: cardMinWidth,
                    height: cardMinHeight,
                    child: _buildStatCard('BOOKED', '$totalBooked', const Color(0xFFE74C3C)),
                  ),
                  SizedBox(
                    width: cardMinWidth,
                    height: cardMinHeight,
                    child: _buildStatCard(
                      'COMPLETED',
                      '$totalCompleted',
                      const Color(0xFF2980B9),
                    ),
                  ),
                  SizedBox(
                    width: cardMinWidth,
                    height: cardMinHeight,
                    child: _buildStatCard(
                      'CLEANING',
                      '$totalCleaning',
                      const Color(0xFFF39C12),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 30),
          const Text(
            'Manage Room Status',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Display dynamic rooms
          currentRooms.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'No rooms added yet. Go to "Add Rooms" to get started!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: currentRooms.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isSmallScreen ? 3 : 5,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (context, index) {
                    final room = currentRooms[index];
                    Color tileColor;
                    IconData icon;
                    switch (room.status) {
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
                      default: // 'available'
                        tileColor = const Color(0xFF27AE60);
                        icon = Icons.hotel;
                        break;
                    }
                    return InkWell(
                      onTap: () {
                        setState(() {
                          // Update room status via RoomManager
                          if (room.status == 'available') {
                            RoomManager().updateRoomStatus(room.name, 'booked');
                          } else if (room.status == 'booked') {
                            RoomManager().updateRoomStatus(room.name, 'completed');
                          } else if (room.status == 'completed') {
                            RoomManager().updateRoomStatus(room.name, 'cleaning');
                          } else { // 'cleaning'
                            RoomManager().updateRoomStatus(room.name, 'available');
                          }
                          // Refresh the displayed rooms list to reflect changes
                          // (This is important because RoomManager updates the original objects)
                          _selectedDrawerIndex = 0; // Stay on dashboard to see updates
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
                                room.name, // Use room.name
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                room.status.toUpperCase(), // Use room.status
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
      appBar: isSmallScreen
          ? AppBar(
              title: const Text(
                'Admin Dashboard',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color(0xFF2E7D32),
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            )
          : null,
      drawer: isSmallScreen ? _buildDrawer() : null,
      body: Row(
        children: [
          if (!isSmallScreen)
            Container(
              width: 250,
              color: const Color(0xFF2E7D32),
              child: _buildWebSidebar(),
            ),
          Expanded(
            child: _getScreenWidget(_selectedDrawerIndex),
          ),
        ],
      ),
    );
  }

  Widget _buildWebSidebar() {
    return Container(
      color: const Color(0xFFF7F7F7), // Light gray background for menu area
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF2E7D32),
            ),
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
          const Divider(height: 1, thickness: 1, color: Colors.black12),
          const SizedBox(height: 8),
          _buildDrawerItem(Icons.dashboard, 'Dashboard', 0),
          const SizedBox(height: 4),
          _buildDrawerItem(Icons.home_work, 'Add Rooms', 1),
          const SizedBox(height: 4),
          _buildDrawerItem(Icons.settings, 'Settings', 2),
          const SizedBox(height: 4),
          _buildDrawerItem(Icons.receipt_long, 'Transactions', 3),
          const Divider(color: Colors.black12, height: 24),
          _buildDrawerItem(Icons.logout, 'Logout', 4),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    final double maxDrawerWidth = 320;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double drawerWidth = screenWidth * 0.85 < maxDrawerWidth ? screenWidth * 0.85 : maxDrawerWidth;
    return Drawer(
      elevation: 8,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Scrollbar(
          thumbVisibility: true,
          child: Container(
            width: drawerWidth,
            color: Colors.white,
            child: _buildWebSidebar(),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    final bool isSelected = _selectedDrawerIndex == index;
    final Color iconColor = isSelected ? const Color(0xFF2E7D32) : Colors.black87;
    final Color textColor = isSelected ? const Color(0xFF2E7D32) : Colors.black87;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          border: isSelected
              ? const Border(
                  left: BorderSide(color: Color(0xFF2E7D32), width: 4),
                )
              : null,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          leading: Icon(icon, color: iconColor, size: 26),
          title: Text(
            title,
            style: TextStyle(fontSize: 16, color: textColor, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
          ),
          selected: isSelected,
          selectedTileColor: Colors.white,
          onTap: () {
            setState(() {
              _selectedDrawerIndex = index;
            });
            if (MediaQuery.of(context).size.width < 800) {
              Navigator.pop(context);
            }
            if (title == 'Logout') {
              _showLogoutConfirmationDialog(context);
            }
          },
          hoverColor: const Color(0xFFEDEDED),
        ),
      ),
    );
  }

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
