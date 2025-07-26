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

// Define your NEW color palette based on the image
class AppColors {
  static const Color sapphire = Color(0xFF3C5070);
  static const Color royalBlue = Color(0xFF112250);
  static const Color quicksand = Color(0xFFE0C58F);
  static const Color swanWing = Color(0xFFF5F0E9);
  static const Color shellstone = Color(0xFFD9CBC2);
}

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedDrawerIndex = 0;
  String? _loggedInHotelName;

  @override
  void initState() {
    super.initState();
    _loadLoggedInHotelName();
  }

  void _loadLoggedInHotelName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _loggedInHotelName = prefs.getString('loggedInHotelName');
      print('AdminDashboard loaded hotel: ' + (_loggedInHotelName ?? 'null'));
    });
  }

  Widget _getScreenWidget(int index) {
    switch (index) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return AddRoomScreenContent(
          hotelName: _loggedInHotelName,
        ); // Pass hotel name
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

  Widget _buildDashboardContent() {
    final List<Room> currentRooms = RoomManager().rooms;

    int totalBooked = currentRooms.where((r) => r.status == 'booked').length;
    int totalCompleted = currentRooms
        .where((r) => r.status == 'completed')
        .length;
    int totalAvailable = currentRooms
        .where((r) => r.status == 'available')
        .length;
    int totalCleaning = currentRooms
        .where((r) => r.status == 'cleaning')
        .length;
    int totalRooms = currentRooms.length;
    final bool isSmallScreen = MediaQuery.of(context).size.width < 800;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard Overview',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.royalBlue,
            ), // Royal Blue for text
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
                      AppColors.sapphire, // Sapphire
                    ),
                  ),
                  SizedBox(
                    width: cardMinWidth,
                    height: cardMinHeight,
                    child: _buildStatCard(
                      'AVAILABLE',
                      '$totalAvailable',
                      AppColors.quicksand, // Quicksand
                    ),
                  ),
                  SizedBox(
                    width: cardMinWidth,
                    height: cardMinHeight,
                    child: _buildStatCard(
                      'BOOKED',
                      '$totalBooked',
                      AppColors.royalBlue,
                    ), // Royal Blue
                  ),
                  SizedBox(
                    width: cardMinWidth,
                    height: cardMinHeight,
                    child: _buildStatCard(
                      'COMPLETED',
                      '$totalCompleted',
                      AppColors.shellstone, // Shellstone
                    ),
                  ),
                  SizedBox(
                    width: cardMinWidth,
                    height: cardMinHeight,
                    child: _buildStatCard(
                      'CLEANING',
                      '$totalCleaning',
                      AppColors.royalBlue.withValues(
                        alpha: 0.8,
                      ), // A slightly lighter Royal Blue
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 30),
          Text(
            'Manage Room Status',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.royalBlue,
            ), // Royal Blue for text
          ),
          const SizedBox(height: 20),
          currentRooms.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'No rooms added yet. Go to "Add Rooms" to get started!',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.royalBlue.withOpacity(0.7),
                      ), // Royal Blue with opacity
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
                        tileColor = AppColors.royalBlue;
                        icon = Icons.event_busy;
                        break;
                      case 'completed':
                        tileColor = AppColors.shellstone;
                        icon = Icons.check_circle_outline;
                        break;
                      case 'cleaning':
                        tileColor = AppColors.royalBlue.withValues(alpha: 0.8);
                        icon = Icons.cleaning_services;
                        break;
                      default: // 'available'
                        tileColor = AppColors.quicksand;
                        icon = Icons.hotel;
                        break;
                    }
                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (room.status == 'available') {
                            RoomManager().updateRoomStatus(room.name, 'booked');
                          } else if (room.status == 'booked') {
                            RoomManager().updateRoomStatus(
                              room.name,
                              'completed',
                            );
                          } else if (room.status == 'completed') {
                            RoomManager().updateRoomStatus(
                              room.name,
                              'cleaning',
                            );
                          } else {
                            RoomManager().updateRoomStatus(
                              room.name,
                              'available',
                            );
                          }
                          _selectedDrawerIndex =
                              0; // Stay on dashboard to see updates
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
                                color:
                                    AppColors.swanWing, // Swan Wing for icons
                                size: isSmallScreen ? 26 : 32,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                room.name,
                                style: const TextStyle(
                                  color:
                                      AppColors.swanWing, // Swan Wing for text
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                room.status.toUpperCase(),
                                style: TextStyle(
                                  color: AppColors.swanWing.withOpacity(
                                    0.7,
                                  ), // Slightly transparent Swan Wing
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
                style: TextStyle(
                  color: AppColors.swanWing,
                ), // Swan Wing for app bar title
              ),
              backgroundColor: AppColors.royalBlue, // Royal Blue for app bar
              elevation: 0,
              iconTheme: const IconThemeData(
                color: AppColors.swanWing,
              ), // Swan Wing for icon
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
              color: AppColors.sapphire, // Sapphire for web sidebar background
              child: _buildWebSidebar(),
            ),
          Expanded(child: _getScreenWidget(_selectedDrawerIndex)),
        ],
      ),
    );
  }

  Widget _buildWebSidebar() {
    return Container(
      color: AppColors.sapphire, // Sapphire background for menu area
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.royalBlue, // Royal Blue for drawer header
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.hotel_outlined,
                  color: AppColors.swanWing,
                  size: 40,
                ), // Swan Wing for icon
                SizedBox(height: 10),
                Text(
                  'Booktopia Admin',
                  style: TextStyle(
                    color: AppColors.swanWing, // Swan Wing for text
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.swanWing.withOpacity(0.3),
          ), // Subtle divider
          const SizedBox(height: 8),
          _buildDrawerItem(Icons.dashboard, 'Dashboard', 0),
          const SizedBox(height: 4),
          _buildDrawerItem(Icons.home_work, 'Add Rooms', 1),
          const SizedBox(height: 4),
          _buildDrawerItem(Icons.settings, 'Settings', 2),
          const SizedBox(height: 4),
          _buildDrawerItem(Icons.receipt_long, 'Transactions', 3),
          Divider(
            color: AppColors.swanWing.withOpacity(0.3),
            height: 24,
          ), // Subtle divider
          _buildDrawerItem(Icons.logout, 'Logout', 4),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    final double maxDrawerWidth = 320;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double drawerWidth = screenWidth * 0.85 < maxDrawerWidth
        ? screenWidth * 0.85
        : maxDrawerWidth;
    return Drawer(
      elevation: 8,
      backgroundColor: AppColors.sapphire, // Sapphire for drawer background
      child: SafeArea(
        child: Scrollbar(
          thumbVisibility: true,
          child: Container(
            width: drawerWidth,
            color: AppColors.sapphire, // Sapphire for drawer background
            child: _buildWebSidebar(),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    final bool isSelected = _selectedDrawerIndex == index;
    final Color iconColor = isSelected
        ? AppColors.quicksand
        : AppColors.swanWing; // Quicksand when selected, Swan Wing otherwise
    final Color textColor = isSelected
        ? AppColors.quicksand
        : AppColors.swanWing; // Quicksand when selected, Swan Wing otherwise
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.royalBlue.withOpacity(0.3)
              : Colors.transparent, // Royal Blue with opacity when selected
          border: isSelected
              ? Border(
                  left: BorderSide(
                    color: AppColors.quicksand,
                    width: 4,
                  ), // Quicksand border
                )
              : null,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          leading: Icon(icon, color: iconColor, size: 26),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          selected: isSelected,
          selectedTileColor:
              AppColors.sapphire, // Sapphire for selected tile background
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
          hoverColor: AppColors.sapphire.withOpacity(
            0.7,
          ), // A subtle hover color
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
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.swanWing.withOpacity(
                      0.8,
                    ), // Swan Wing with opacity
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
                    color: AppColors.swanWing, // Swan Wing for values
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
          title: Text(
            'Confirm Logout',
            style: TextStyle(color: AppColors.royalBlue),
          ), // Royal Blue for title
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.royalBlue),
              ), // Royal Blue for cancel
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.royalBlue, // Royal Blue for logout button
                foregroundColor:
                    AppColors.swanWing, // Swan Wing for button text
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
                  SnackBar(
                    content: Text(
                      'You have been logged out.',
                      style: TextStyle(color: AppColors.swanWing),
                    ),
                    backgroundColor: AppColors.sapphire,
                  ), // Swan Wing for text, Sapphire for background
                );
              },
            ),
          ],
        );
      },
    );
  }
}
