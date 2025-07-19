import 'package:flutter/material.dart';
import '../bookings/roomlist.dart'; // Screen to display list of rooms for a hotel
import 'bookings.dart'; // Screen for booking history
import 'favorites.dart'; // Screen for favorite hotels
import 'profile.dart'; // User profile screen
import '../services/notification_service.dart'; // Import NotificationService
import '../auth/signup.dart';

// Import the new screens for the drawer, assuming they exist
import 'about_us_screen.dart';
import 'contact_us_screen.dart';
import 'feedback_screen.dart';
import 'settings_screen.dart';
import 'terms_conditions_screen.dart';
import 'support_screen.dart';
import 'notification_screen.dart'; // Make sure this is also imported if used elsewhere

// Define the new blue and white color scheme constants
const Color kPrimaryBlue = Color(0xFF0065FF); // A vibrant blue for primary elements
const Color kDarkBlue = Color(0xFF003C99); // A darker blue for text/icons
const Color kLightBlue = Color(0xFFE6F2FF); // A very light blue for backgrounds
const Color kAccentBlue = Color(0xFF007BFF); // An accent blue for highlights (not directly used here but good for consistency)

// Define a simple Hotel data model
class Hotel {
  final String image;
  final String name;
  final String location;
  final String rating;
  final String description;
  final List<String> categories;
  final List<String> amenities;
  final String priceRange;
  bool isFavorite; // This field is not final

  // Remove 'const' from here because 'isFavorite' is not final
  Hotel({ // <--- REMOVE 'const' here
    required this.image,
    required this.name,
    required this.location,
    required this.rating,
    required this.description,
    this.categories = const [],
    this.amenities = const [],
    this.priceRange = '₱₱₱',
    this.isFavorite = false,
  });
}

// Define a GlobalKey for HomePage to access its state from other screens
final GlobalKey<HomePageState> homePageKey = GlobalKey<HomePageState>();

class HomePage extends StatefulWidget {
  // Pass the key to the super constructor explicitly as a named argument
  const HomePage({super.key}); // This correctly passes the key to the StatefulWidget's constructor


  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void setTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      HomeContent(onTabSelected: (index) {
        setState(() {
          _currentIndex = index;
        });
      }), // Displays the main dashboard/explore content
      const BookingsScreen(), // Shows user's booking history
      // FavoritesScreen now takes a callback to refresh itself if needed
      FavoritesScreen(onFavoriteChanged: () {
        // This callback will be triggered from HomeContent when a hotel's favorite status changes
        // If FavoritesScreen is the current tab, we need to ensure it rebuilds.
        // A simple setState on HomePageState will cause its children (including FavoritesScreen) to rebuild.
        if (_currentIndex == 2) { // Assuming 2 is the index for FavoritesScreen
          setState(() {});
        }
      }),
      const ProfileScreen(), // Displays user profile information
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withAlpha((255 * 0.6).round()), // FIX: Used withAlpha
        backgroundColor: kPrimaryBlue,
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

class HomeContent extends StatefulWidget {
  final Function(int) onTabSelected;

  const HomeContent({super.key, required this.onTabSelected});

  // All available hotels - made static to be accessible from other screens
  static final List<Hotel> _allHotels = [
    Hotel(
      image: '../assets/hotel1.png', // Placeholder, replace with actual image
      name: 'Seaside Resort Boracay',
      location: 'Boracay, PH',
      rating: '4.8 (1200 reviews)',
      description: 'A beachfront paradise with sparkling pools, vibrant tropical vibes, and exceptionally friendly service.',
      categories: ['Beach', 'Top Rated', 'Family'],
      amenities: ['Wi-Fi', 'Pool', 'Beach Access', 'Spa'],
      priceRange: '₱3,000 - ₱8,000',
      isFavorite: false, // Initial favorite status
    ),
    Hotel(
      image: 'assets/hotel2.png', // Placeholder, replace with actual image
      name: 'Malvar Mountain Retreat',
      location: 'Malvar, PH',
      rating: '4.9 (500 reviews)',
      description: 'Escape to nature with breathtaking mountain views and serene surroundings, perfect for relaxation and hiking.',
      categories: ['Nature', 'Top Rated', 'Family'],
      amenities: ['Wi-Fi', 'Hiking Trails', 'Restaurant', 'Parking'],
      priceRange: '₱2,000 - ₱5,000',
      isFavorite: false, // Initial favorite status
    ),
    Hotel(
      image: 'assets/hotel3.png', // Assuming you have this asset
      name: 'El Nido Island Paradise',
      location: 'Palawan, PH',
      rating: '4.7 (950 reviews)',
      description: 'An exclusive island paradise offering pristine beaches, world-class diving, and eco-friendly accommodations.',
      categories: ['Beach', 'Luxury', 'Nature'],
      amenities: ['Wi-Fi', 'Diving Center', 'Private Beach', 'Eco-friendly'],
      priceRange: '₱7,000 - ₱15,000',
      isFavorite: true, // Example: Set this one as favorite initially
    ),
    Hotel(
      image: 'assets/hotel4.png', // Assuming you have this asset
      name: 'Cebu City Business Hotel',
      location: 'Cebu, PH',
      rating: '4.2 (780 reviews)',
      description: 'Strategically located in the city center, ideal for business travelers with modern facilities and conference rooms.',
      categories: ['City', 'Business', 'Budget'],
      amenities: ['Wi-Fi', 'Conference Rooms', 'Fitness Center', 'Restaurant'],
      priceRange: '₱1,800 - ₱4,500',
      isFavorite: false,
    ),
    Hotel(
      image: 'assets/hotel5.png', // Assuming you have this asset
      name: 'Tagaytay Lakeview Suites',
      location: 'Tagaytay, PH',
      rating: '4.6 (620 reviews)',
      description: 'Enjoy the cool climate and stunning Taal Lake views from our elegant suites, perfect for a romantic getaway.',
      categories: ['Nature', 'Romantic', 'Luxury'],
      amenities: ['Wi-Fi', 'Lake View', 'Spa', 'Balcony'],
      priceRange: '₱2,500 - ₱7,000',
      isFavorite: false,
    ),
    Hotel(
      image: 'assets/hotel6.png', // Assuming you have this asset
      name: 'Siargao Surfer\'s Haven',
      location: 'Siargao, PH',
      rating: '4.5 (800 reviews)',
      description: 'The ultimate spot for surfers and adventurers, offering easy access to famous surf breaks and island hopping tours.',
      categories: ['Beach', 'Adventure', 'Budget'],
      amenities: ['Wi-Fi', 'Surf Lessons', 'Island Hopping', 'Motorbike Rental'],
      priceRange: '₱1,200 - ₱3,500',
      isFavorite: false,
    ),
    Hotel(
      image: 'assets/hotel7.png', // Assuming you have this asset
      name: 'Manila Urban Grand',
      location: 'Manila, PH',
      rating: '4.3 (1500 reviews)',
      description: 'Experience urban luxury with exquisite dining options and vibrant nightlife right at your doorstep.',
      categories: ['City', 'Luxury', 'Nightlife'],
      amenities: ['Wi-Fi', 'Fine Dining', 'Bar', 'Valet Parking'],
      priceRange: '₱4,000 - ₱10,000',
      isFavorite: false,
    ),
    Hotel(
      image: 'assets/hotel8.png', // Assuming you have this asset
      name: 'Baguio Pine Forest Lodge',
      location: 'Baguio, PH',
      rating: '4.7 (700 reviews)',
      description: 'A cozy lodge nestled among pine trees, offering a refreshing cool weather escape and a peaceful atmosphere.',
      categories: ['Nature', 'Family', 'Relaxation'],
      amenities: ['Wi-Fi', 'Fireplace', 'Garden', 'Pet-friendly'],
      priceRange: '₱2,200 - ₱5,500',
      isFavorite: false,
    ),
    Hotel(
      image: 'assets/hotel9.png', // Assuming you have this asset
      name: 'Davao Nature Park Hotel',
      location: 'Davao, PH',
      rating: '4.4 (550 reviews)',
      description: 'Close to nature parks and cultural sites, offering a unique blend of adventure and local experiences.',
      categories: ['Nature', 'Cultural', 'Adventure'],
      amenities: ['Wi-Fi', 'Nature Tours', 'Local Cuisine', 'Airport Shuttle'],
      priceRange: '₱1,500 - ₱4,000',
      isFavorite: false,
    ),
    Hotel(
      image: 'assets/hotel10.png', // Assuming you have this asset
      name: 'Iloilo Heritage Inn',
      location: 'Iloilo, PH',
      rating: '4.1 (480 reviews)',
      description: 'Step back in time in this heritage city, perfect for culinary tours and exploring historical landmarks.',
      categories: ['Cultural', 'Budget', 'Historical'],
      amenities: ['Wi-Fi', 'Historical Tours', 'Cafe', 'Laundry Service'],
      priceRange: '₱1,000 - ₱3,000',
      isFavorite: false,
    ),
  ];

  // Static method to get favorite hotels
  static List<Hotel> getFavoriteHotels() {
    return _allHotels.where((hotel) => hotel.isFavorite).toList();
  }

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Hotel> _displayedHotels = [];
  final TextEditingController _searchController = TextEditingController();

  final NotificationService _notificationService = NotificationService();
  int _notificationCount = 0;

  // Map amenity strings to their respective IconData
  static const Map<String, IconData> _amenityIcons = {
    'Wi-Fi': Icons.wifi,
    'Pool': Icons.pool,
    'Beach Access': Icons.beach_access,
    'Spa': Icons.spa,
    'Hiking Trails': Icons.landscape,
    'Restaurant': Icons.restaurant,
    'Parking': Icons.local_parking,
    'Diving Center': Icons.scuba_diving,
    'Private Beach': Icons.beach_access,
    'Eco-friendly': Icons.eco,
    'Conference Rooms': Icons.business_center,
    'Fitness Center': Icons.fitness_center,
    'Lake View': Icons.water,
    'Balcony': Icons.balcony,
    'Surf Lessons': Icons.surfing,
    'Island Hopping': Icons.directions_boat,
    'Motorbike Rental': Icons.motorcycle,
    'Fine Dining': Icons.dinner_dining,
    'Bar': Icons.local_bar,
    'Valet Parking': Icons.car_rental,
    'Fireplace': Icons.fireplace,
    'Garden': Icons.local_florist,
    'Pet-friendly': Icons.pets,
    'Nature Tours': Icons.nature_people,
    'Local Cuisine': Icons.food_bank,
    'Airport Shuttle': Icons.airport_shuttle,
    'Historical Tours': Icons.museum,
    'Cafe': Icons.coffee,
    'Laundry Service': Icons.local_laundry_service,
  };


  @override
  void initState() {
    super.initState();
    _displayedHotels = List.from(HomeContent._allHotels); // Use the static list
    _searchController.addListener(_onSearchChanged);

    _notificationCount = _notificationService.notifications.length;
    _notificationService.addListener(_onNotificationsChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _notificationService.removeListener(_onNotificationsChanged);
    super.dispose();
  }

  void _onNotificationsChanged() {
    setState(() {
      _notificationCount = _notificationService.notifications.length;
    });
  }

  void _onSearchChanged() {
    _filterHotels(_searchController.text);
  }

  void _filterHotels(String queryOrCategory) {
    setState(() {
      if (queryOrCategory == 'All' || queryOrCategory.isEmpty) {
        _displayedHotels = List.from(HomeContent._allHotels);
      } else {
        final lowerCaseQuery = queryOrCategory.toLowerCase();
        _displayedHotels = HomeContent._allHotels.where((hotel) {
          return hotel.categories.any((category) => category.toLowerCase().contains(lowerCaseQuery)) ||
              hotel.name.toLowerCase().contains(lowerCaseQuery) ||
              hotel.location.toLowerCase().contains(lowerCaseQuery) ||
              hotel.amenities.any((amenity) => amenity.toLowerCase().contains(lowerCaseQuery)) ||
              hotel.priceRange.toLowerCase().contains(lowerCaseQuery);
        }).toList();
      }
    });
  }

  void _toggleHotelFavorite(Hotel hotel, bool isFavorite) {
    setState(() {
      final index = HomeContent._allHotels.indexOf(hotel);
      if (index != -1) {
        HomeContent._allHotels[index].isFavorite = isFavorite;
      }
      // Re-filter to update the displayed list if filtering is active
      _filterHotels(_searchController.text);
      // Notify HomePageState to potentially refresh FavoritesScreen
      homePageKey.currentState?.setState(() {});
    });
  }

  Widget _buildQuickAccessButton(IconData icon, String label, {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: kPrimaryBlue.withAlpha((255 * 0.1).round()),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Icon(icon, size: 30, color: kDarkBlue),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(color: kDarkBlue),
            ),
          ],
        ),
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
        required List<String> amenities,
        required String priceRange,
        required bool isFavorite, // New parameter for favorite status
        required ValueChanged<bool> onFavoriteChanged, // New callback for favorite changes
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
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack( // Use Stack to position the heart icon on top of the image
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
                Positioned( // Position the IconButton for favorite
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white, // Changed color for visibility on image
                    ),
                    onPressed: () {
                      onFavoriteChanged(!isFavorite); // Toggle the favorite status
                    },
                  ),
                ),
              ],
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
                      color: kDarkBlue,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            location,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: kLightBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          priceRange,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: kDarkBlue,
                          ),
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
                      ),
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
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: amenities.map((amenity) {
                      return Column(
                        children: [
                          Icon(
                            _amenityIcons[amenity] ?? Icons.help_outline,
                            size: 24,
                            color: kDarkBlue,
                          ),
                          const SizedBox(height: 5),
                          Text(amenity, style: const TextStyle(fontSize: 12)),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Explore Hotels',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kPrimaryBlue,
        leading: Builder(
          builder: (BuildContext innerContext) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(innerContext).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: () {
              widget.onTabSelected(2); // Navigate to Favorites tab (index 2)
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                  );
                },
              ),
              if (_notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withAlpha((255 * 1.0).round()), width: 1.5),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$_notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          ),
        ],
        elevation: 0,
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: kPrimaryBlue,
                image: DecorationImage(
                  image: const AssetImage(
                    'assets/hotel_drawer_bg.jpg',
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    kPrimaryBlue.withAlpha((255 * 0.5).round()),
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
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'John Doe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'johndoe@example.com',
                    style: TextStyle(color: Color.fromARGB(178, 255, 255, 255), fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: kDarkBlue),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.support_agent, color: kDarkBlue),
              title: const Text('Support'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SupportScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: kDarkBlue),
              title: const Text('About Us'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback_outlined, color: kDarkBlue),
              title: const Text('Feedback'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FeedbackScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail_outlined, color: kDarkBlue),
              title: const Text('Contact Us'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContactUsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.description_outlined, color: kDarkBlue),
              title: const Text('Terms and Conditions'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TermsConditionsScreen()),
                );
              },
            ),
            const Divider(),
             ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              // Close the drawer first
              Navigator.pop(context); 
              
              // Show the logout confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          // Dismiss the dialog
                          Navigator.of(context).pop(); 
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton( // Changed to ElevatedButton
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE74C3C), // Red color
                          foregroundColor: Colors.white, // White text color
                        ),
                        onPressed: () {
                          // Dismiss the dialog
                          Navigator.of(context).pop(); 
                          // Perform the actual logout action and navigate
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpScreen()),
                            (Route<dynamic> route) => false, // Clears all previous routes
                          );
                          // Show a SnackBar notification
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('You have been logged out.')),
                          );
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  );
                },
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
              'Booktopia Prestige',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: kDarkBlue,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha((255 * 0.2).round()),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search hotels...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: kDarkBlue,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kPrimaryBlue, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickAccessButton(Icons.all_inclusive, 'All', onPressed: () => _filterHotels('All')),
                  _buildQuickAccessButton(Icons.diamond, 'Luxury', onPressed: () => _filterHotels('Luxury')),
                  _buildQuickAccessButton(Icons.money, 'Budget', onPressed: () => _filterHotels('Budget')),
                  _buildQuickAccessButton(Icons.place, 'Near Me', onPressed: () => _filterHotels('Malvar')),
                  _buildQuickAccessButton(Icons.star, 'Top Rated', onPressed: () => _filterHotels('Top Rated')),
                  _buildQuickAccessButton(Icons.family_restroom, 'Family', onPressed: () => _filterHotels('Family')),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Featured Hotels',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kDarkBlue,
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: _displayedHotels.map((hotel) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: _buildHotelCard(
                    context,
                    image: hotel.image,
                    name: hotel.name,
                    location: hotel.location,
                    rating: hotel.rating,
                    description: hotel.description,
                    amenities: hotel.amenities,
                    priceRange: hotel.priceRange,
                    isFavorite: hotel.isFavorite, // Pass the favorite status
                    onFavoriteChanged: (isFavorite) {
                      _toggleHotelFavorite(hotel, isFavorite); // Handle favorite toggle
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}