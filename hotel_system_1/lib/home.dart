// home.dart
import 'package:flutter/material.dart';
import 'roomlist.dart';
import 'bookings.dart';
import 'favorites.dart';
import 'profile.dart';

// Import the new screens for the drawer
import 'about_us_screen.dart';
import 'contact_us_screen.dart';
import 'feedback_screen.dart';
import 'settings_screen.dart';
import 'terms_conditions_screen.dart';
import 'support_screen.dart';

// Define the main green color and its variations for consistency based on image_24f71b.png
const Color kPrimaryGreen = Color(0xFF73C088); // A refreshing mid-green
const Color kDarkGreen = Color(0xFF235D3A); // A darker shade for text/icons
const Color kLightGreen = Color(
  0xFFC8EAD1,
); // A very light green for backgrounds
const Color kAppBarTitleGreen = Color(
  0xFF397D54,
); // A darker green for high contrast titles
const Color kButtonGreen = Color(0xFFA8E0B7); // A mid-light green for buttons

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const HomeContent(), // Dashboard screen
    const BookingsScreen(), // Booking history
    const FavoritesScreen(), // Favorites
    const ProfileScreen(), // Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white, // Changed to white
        unselectedItemColor: Colors.white.withOpacity(
          0.6,
        ), // Changed to white with opacity
        backgroundColor: kPrimaryGreen, // Bottom nav bar background
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Bookings'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          kLightGreen, // Light green background for the screen body
      appBar: AppBar(
        title: const Text(
          'Explore Hotels',
          style: TextStyle(
            color: Colors.white, // Changed to white
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kPrimaryGreen, // Main refreshing green for app bar
        leading: Builder(
          // Use Builder to ensure correct context for Scaffold.of
          builder: (BuildContext innerContext) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white, // Changed to white
              ), // White menu icon
              onPressed: () {
                Scaffold.of(innerContext).openDrawer(); // Open the drawer
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.favorite_border,
              color: Colors.white, // Changed to white
            ), // White favorite icon
            onPressed: () {
              // Handle favorite button press
              // This should ideally navigate to the FavoritesScreen from the drawer
              // or change the BottomNavigationBar index.
              // For now, it's just a placeholder.
            },
          ),
        ],
        elevation: 0,
      ),
      drawer: Drawer(
        // Add a border radius to the drawer using the 'shape' property
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(0), // Adjust the radius as needed
            bottomRight: Radius.circular(0), // Adjust the radius as needed
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: kPrimaryGreen, // Main refreshing green for drawer header
                image: DecorationImage(
                  image: AssetImage(
                    'assets/hotel_drawer_bg.jpg',
                  ), // Add a background image for the drawer header
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    kPrimaryGreen.withOpacity(0.5), // Blend image with green
                    BlendMode.srcATop,
                  ),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                      'assets/profile_placeholder.png',
                    ), // Add a profile image
                  ),
                  SizedBox(height: 8),
                  Text(
                    'John Doe', // Replace with dynamic user name
                    style: TextStyle(
                      color: Colors.white, // White text for contrast
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'johndoe@example.com', // Replace with dynamic user email
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: kDarkGreen,
              ), // Dark green icon (kept as is for drawer items)
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.support_agent,
                color: kDarkGreen,
              ), // Dark green icon (kept as is for drawer items)
              title: const Text('Support'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SupportScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.info_outline,
                color: kDarkGreen,
              ), // Dark green icon (kept as is for drawer items)
              title: const Text('About Us'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutUsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.feedback_outlined,
                color: kDarkGreen,
              ), // Dark green icon (kept as is for drawer items)
              title: const Text('Feedback'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeedbackScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.contact_mail_outlined,
                color:
                    kDarkGreen, // Dark green icon (kept as is for drawer items)
              ), // Icon for Contact Us
              title: const Text('Contact Us'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactUsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.description_outlined,
                color: kDarkGreen,
              ), // Dark green icon (kept as is for drawer items)
              title: const Text('Terms and Conditions'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsConditionsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: kDarkGreen, // Dark green for dashboard title
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search hotels...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: kDarkGreen,
                ), // Dark green search icon
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickAccessButton(Icons.hotel, 'Bookings'),
                  _buildQuickAccessButton(Icons.favorite, 'Favorites'),
                  _buildQuickAccessButton(Icons.map, 'Nearby'),
                  _buildQuickAccessButton(Icons.local_offer, 'Deals'),
                  _buildQuickAccessButton(Icons.diamond, 'Luxury'),
                  _buildQuickAccessButton(Icons.money, 'Budget'),
                  _buildQuickAccessButton(Icons.place, 'Near Me'),
                  _buildQuickAccessButton(Icons.star, 'Top Rated'),
                  _buildQuickAccessButton(Icons.family_restroom, 'Family'),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Featured Hotels',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kDarkGreen, // Dark green for featured hotels title
              ),
            ),
            const SizedBox(height: 20),
            _buildHotelCard(
              context,
              image: 'assets/facebook.png',
              name: 'The Plaza Hotel',
              location: 'London, UK',
              rating: '4.5 (900 reviews)',
              description:
                  'A luxurious hotel in London with world-class amenities and a beautiful view.',
            ),
            const SizedBox(height: 20),
            _buildHotelCard(
              context,
              image: 'assets/plaza.png',
              name: 'Seaside Resort',
              location: 'Boracay, PH',
              rating: '4.8 (1200 reviews)',
              description:
                  'A beachfront paradise with pools, tropical vibes, and friendly service.',
            ),
            const SizedBox(height: 20),
            _buildHotelCard(
              context,
              image: 'assets/apple.png',
              name: 'Urban Inn',
              location: 'Tokyo, Japan',
              rating: '4.3 (760 reviews)',
              description:
                  'A stylish, modern hotel perfect for city explorers and business travelers.',
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessButton(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: kPrimaryGreen.withOpacity(
                0.3,
              ), // Lighter shade of primary green
            ),
            padding: const EdgeInsets.all(16),
            child: Icon(icon, size: 30, color: kDarkGreen), // Dark green icons
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: kDarkGreen),
          ), // Dark green text
        ],
      ),
    );
  }

  Widget _buildHotelCard(
    BuildContext context, {
    required String image,
    required String name,
    required String location,
    required String rating,
    required String description,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RoomListScreen(hotelName: name)),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.asset(
                image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // This is a fallback for missing images, remove after adding actual assets
                  return Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 60,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kDarkGreen, // Dark green for hotel name
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey, // Keeping grey for location icon
                      ),
                      const SizedBox(width: 5),
                      Text(
                        location,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey, // Keeping grey for location text
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 18,
                      ), // Keeping orange for star rating
                      const SizedBox(width: 5),
                      Text(rating, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 15),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.wifi,
                            size: 24,
                            color: kDarkGreen,
                          ), // Dark green amenity icons
                          SizedBox(height: 5),
                          Text('Wi-Fi', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.pool,
                            size: 24,
                            color: kDarkGreen,
                          ), // Dark green amenity icons
                          SizedBox(height: 5),
                          Text('Pool', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.restaurant,
                            size: 24,
                            color: kDarkGreen,
                          ), // Dark green amenity icons
                          SizedBox(height: 5),
                          Text('Dining', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
