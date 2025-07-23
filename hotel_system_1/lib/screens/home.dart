import 'package:flutter/material.dart';
import '../bookings/roomlist.dart'; // Screen to display list of rooms for a hotel
import 'bookings.dart'; // Screen for booking history
import 'favorites.dart'; // Screen for favorite hotels
import 'profile.dart'; // User profile screen
import '../services/notification_service.dart'; // Import NotificationService
import '../auth/signup.dart';
import '../screens/hotel_manager.dart'; // Import HotelManager to manage hotel data
import '../models/amenity.dart'; // Import Amenity model

// Import the new screens for the drawer, assuming they exist
import 'about_us_screen.dart';
import 'contact_us_screen.dart';
import 'feedback_screen.dart';
import 'settings_screen.dart';
import 'terms_conditions_screen.dart';
import 'support_screen.dart';
import 'notification_screen.dart'; // Make sure this is also imported if used elsewhere
import '../utils/constants.dart';
import '../models/hotel.dart';


// Define a GlobalKey for HomePage to access its state from other screens
final GlobalKey<HomePageState> homePageKey = GlobalKey<HomePageState>();

class HomePage extends StatefulWidget {
  // Pass the key to the super constructor explicitly as a named argument
  const HomePage({
    super.key,
  }); // This correctly passes the key to the StatefulWidget's constructor

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
      HomeContent(
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ), // Displays the main dashboard/explore content
      const BookingsScreen(), // Shows user's booking history
      // FavoritesScreen now takes a callback to refresh itself if needed
      FavoritesScreen(
        onFavoriteChanged: () {
          // This callback will be triggered from HomeContent when a hotel's favorite status changes
          // If FavoritesScreen is the current tab, we need to ensure it rebuilds.
          // A simple setState on HomePageState will cause its children (including FavoritesScreen) to rebuild.
          if (_currentIndex == 2) {
            // Assuming 2 is the index for FavoritesScreen
            setState(() {});
          }
        },
      ),
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
        unselectedItemColor: Colors.white.withAlpha(
          (255 * 0.6).round(),
        ), // FIX: Used withAlpha
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

  // This list will now be used to *initialize* HotelManager if it's empty
  // It's renamed to _initialHotels to clarify its purpose as initial data.
  static final List<Hotel> _initialHotels = [
    Hotel(
      image: 'assets/hotel1.png',
      name: 'Seaside Resort Boracay',
      location: 'Boracay, PH',
      rating: '4.8 (1200 reviews)',
      description: 'A beachfront paradise with sparkling pools, vibrant tropical vibes, and exceptionally friendly service.',
      categories: ['Beach', 'Top Rated', 'Family'],
      amenities: [
        const Amenity(icon: Icons.wifi, label: 'Wi-Fi'),
        const Amenity(icon: Icons.pool, label: 'Pool'),
        const Amenity(icon: Icons.beach_access, label: 'Beach Access'),
        const Amenity(icon: Icons.spa, label: 'Spa')
      ],
      priceRange: '₱3,000 - ₱8,000',
      isFavorite: false,
    ),
    Hotel(
      image: 'assets/hotel2.png',
      name: 'Malvar Mountain Retreat',
      location: 'Malvar, PH',
      rating: '4.9 (500 reviews)',
      description: 'Escape to nature with breathtaking mountain views and serene surroundings, perfect for relaxation and hiking.',
      categories: ['Nature', 'Top Rated', 'Family'],
      amenities: [
        const Amenity(icon: Icons.wifi, label: 'Wi-Fi'),
        const Amenity(icon: Icons.landscape, label: 'Hiking Trails'),
        const Amenity(icon: Icons.restaurant, label: 'Restaurant'),
        const Amenity(icon: Icons.local_parking, label: 'Parking')
      ],
      priceRange: '₱2,000 - ₱5,000',
      isFavorite: false,
    ),
    Hotel(
      image: 'assets/hotel3.png',
      name: 'El Nido Island Paradise',
      location: 'Palawan, PH',
      rating: '4.7 (950 reviews)',
      description: 'An exclusive island paradise offering pristine beaches, world-class diving, and eco-friendly accommodations.',
      categories: ['Beach', 'Luxury', 'Nature'],
      amenities: [
        const Amenity(icon: Icons.wifi, label: 'Wi-Fi'),
        const Amenity(icon: Icons.scuba_diving, label: 'Diving Center'),
        const Amenity(icon: Icons.beach_access, label: 'Private Beach'),
        const Amenity(icon: Icons.eco, label: 'Eco-friendly')
      ],
      priceRange: '₱7,000 - ₱15,000',
      isFavorite: true,
    ),
    Hotel(
      image: 'assets/hotel4.png',
      name: 'Cebu City Business Hotel',
      location: 'Cebu, PH',
      rating: '4.2 (780 reviews)',
      description: 'Strategically located in the city center, ideal for business travelers with modern facilities and conference rooms.',
      categories: ['City', 'Business', 'Budget'],
      amenities: [
        const Amenity(icon: Icons.wifi, label: 'Wi-Fi'),
        const Amenity(icon: Icons.business_center, label: 'Conference Rooms'),
        const Amenity(icon: Icons.fitness_center, label: 'Fitness Center'),
        const Amenity(icon: Icons.restaurant, label: 'Restaurant')
      ],
      priceRange: '₱1,800 - ₱4,500',
      isFavorite: false,
    ),
    Hotel(
      image: 'assets/hotel5.png',
      name: 'Tagaytay Lakeview Suites',
      location: 'Tagaytay, PH',
      rating: '4.6 (620 reviews)',
      description: 'Enjoy the cool climate and stunning Taal Lake views from our elegant suites, perfect for a romantic getaway.',
      categories: ['Nature', 'Romantic', 'Luxury'],
      amenities: [
        const Amenity(icon: Icons.wifi, label: 'Wi-Fi'),
        const Amenity(icon: Icons.water, label: 'Lake View'),
        const Amenity(icon: Icons.spa, label: 'Spa'),
        const Amenity(icon: Icons.balcony, label: 'Balcony')
      ],
      priceRange: '₱2,500 - ₱7,000',
      isFavorite: false,
    ),
    Hotel(
      image: 'assets/hotel6.png',
      name: 'Siargao Surfer\'s Haven',
      location: 'Siargao, PH',
      rating: '4.5 (800 reviews)',
      description: 'The ultimate spot for surfers and adventurers, offering easy access to famous surf breaks and island hopping tours.',
      categories: ['Beach', 'Adventure', 'Budget'],
      amenities: [
        const Amenity(icon: Icons.wifi, label: 'Wi-Fi'),
        const Amenity(icon: Icons.surfing, label: 'Surf Lessons'),
        const Amenity(icon: Icons.directions_boat, label: 'Island Hopping'),
        const Amenity(icon: Icons.motorcycle, label: 'Motorbike Rental'),
      ],
      priceRange: '₱1,200 - ₱3,500',
      isFavorite: false,
    ),
    Hotel(
      image: 'assets/hotel7.png',
      name: 'Manila Urban Grand',
      location: 'Manila, PH',
      rating: '4.3 (1500 reviews)',
      description: 'Experience urban luxury with exquisite dining options and vibrant nightlife right at your doorstep.',
      categories: ['City', 'Luxury', 'Nightlife'],
      amenities: [
        const Amenity(icon: Icons.wifi, label: 'Wi-Fi'),
        const Amenity(icon: Icons.dinner_dining, label: 'Fine Dining'),
        const Amenity(icon: Icons.local_bar, label: 'Bar'),
        const Amenity(icon: Icons.car_rental, label: 'Valet Parking')
      ],
      priceRange: '₱4,000 - ₱10,000',
      isFavorite: false,
    ),
    Hotel(
      image: 'assets/hotel8.png',
      name: 'Baguio Pine Forest Lodge',
      location: 'Baguio, PH',
      rating: '4.7 (700 reviews)',
      description: 'A cozy lodge nestled among pine trees, offering a refreshing cool weather escape and a peaceful atmosphere.',
      categories: ['Nature', 'Family', 'Relaxation'],
      amenities: [
        const Amenity(icon: Icons.wifi, label: 'Wi-Fi'),
        const Amenity(icon: Icons.fireplace, label: 'Fireplace'),
        const Amenity(icon: Icons.local_florist, label: 'Garden'),
        const Amenity(icon: Icons.pets, label: 'Pet-friendly')
      ],
      priceRange: '₱2,200 - ₱5,500',
      isFavorite: false,
    ),
    Hotel(
      image: 'assets/hotel9.png',
      name: 'Davao Nature Park Hotel',
      location: 'Davao, PH',
      rating: '4.4 (550 reviews)',
      description: 'Close to nature parks and cultural sites, offering a unique blend of adventure and local experiences.',
      categories: ['Nature', 'Cultural', 'Adventure'],
      amenities: [
        const Amenity(icon: Icons.wifi, label: 'Wi-Fi'),
        const Amenity(icon: Icons.nature_people, label: 'Nature Tours'),
        const Amenity(icon: Icons.food_bank, label: 'Local Cuisine'),
        const Amenity(icon: Icons.airport_shuttle, label: 'Airport Shuttle')
      ],
      priceRange: '₱1,500 - ₱4,000',
      isFavorite: false,
    ),
    Hotel(
      image: 'assets/hotel10.png',
      name: 'Iloilo Heritage Inn',
      location: 'Iloilo, PH',
      rating: '4.1 (480 reviews)',
      description: 'Step back in time in this heritage city, perfect for culinary tours and exploring historical landmarks.',
      categories: ['Cultural', 'Budget', 'Historical'],
      amenities: [
        const Amenity(icon: Icons.wifi, label: 'Wi-Fi'),
        const Amenity(icon: Icons.museum, label: 'Historical Tours'),
        const Amenity(icon: Icons.coffee, label: 'Cafe'),
        const Amenity(icon: Icons.local_laundry_service, label: 'Laundry Service')
      ],
      priceRange: '₱1,000 - ₱3,000',
      isFavorite: false,
    ),
  ];

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Hotel> _displayedHotels = [];
  final TextEditingController _searchController = TextEditingController();

  final NotificationService _notificationService = NotificationService();
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();

    // Initialize HotelManager with initial hotels if it's empty
    // This ensures that both pre-defined and admin-added hotels are in HotelManager.
    // This check prevents adding duplicates if the app hot-restarts or if data is persistent.
    if (HotelManager().hotels.isEmpty) {
      for (var hotel in HomeContent._initialHotels) {
        HotelManager().addHotel(hotel);
      }
    }

    // Always get the displayed hotels from the HotelManager
    _displayedHotels = List.from(HotelManager().hotels);


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
        _displayedHotels = List.from(HotelManager().hotels); // Source from HotelManager
      } else {
        final lowerCaseQuery = queryOrCategory.toLowerCase();
        // Filter from the comprehensive list held by HotelManager
        _displayedHotels = HotelManager().hotels.where((hotel) {
          return hotel.categories.any(
                (category) => category.toLowerCase().contains(lowerCaseQuery),
              ) ||
              hotel.name.toLowerCase().contains(lowerCaseQuery) ||
              hotel.location.toLowerCase().contains(lowerCaseQuery) ||
              // Check amenity labels for search
              hotel.amenities.any(
                (amenity) => amenity.label.toLowerCase().contains(lowerCaseQuery),
              ) ||
              hotel.priceRange.toLowerCase().contains(lowerCaseQuery);
        }).toList();
      }
    });
  }

  // Modified _toggleHotelFavorite to use HotelManager and refresh displayed list
  void _toggleHotelFavorite(Hotel hotel) {
    setState(() {
      // Toggle the status via HotelManager. This modifies the shared object.
      HotelManager().toggleFavoriteStatus(hotel);

      // Re-initialize _displayedHotels from HotelManager's current state
      // This ensures that the displayed list (and thus the UI) reflects the latest data
      // from your central HotelManager.
      _displayedHotels = List.from(HotelManager().hotels);

      // Optional: If a search filter is currently active, re-apply it to update the displayed list
      if (_searchController.text.isNotEmpty && _searchController.text != 'All') {
        _filterHotels(_searchController.text);
      }

      // Notify HomePageState to potentially refresh FavoritesScreen
      homePageKey.currentState?.setState(() {});
    });
  }

  Widget _buildHotelCard(Hotel hotel) {
    // Determine if the image is an asset or a network image
    final bool isNetworkImage = hotel.image.startsWith('http://') || hotel.image.startsWith('https://');

    Widget hotelImageWidget;
    if (isNetworkImage) {
      hotelImageWidget = Image.network(
        hotel.image,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey[300],
            child: const Icon(
              Icons.broken_image,
              size: 60,
              color: Colors.grey,
            ),
          );
        },
      );
    } else {
      hotelImageWidget = Image.asset(
        hotel.image,
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
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RoomListScreen(hotelName: hotel.name)),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: hotelImageWidget,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      hotel.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: hotel.isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      _toggleHotelFavorite(hotel);
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
                    hotel.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(hotel.location),
                  const SizedBox(height: 8),
                  Text(hotel.priceRange),
                  const SizedBox(height: 12),
                  // Show categories as chips only if not empty
                  if (hotel.categories.isNotEmpty)
                    ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: hotel.categories.map((cat) => Chip(label: Text(cat))).toList(),
                      ),
                    ],
                  // Show amenities as icons+labels only if not empty
                  if (hotel.amenities.isNotEmpty)
                    ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: hotel.amenities.map((a) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(a.icon, size: 24, color: kDarkBlue),
                            Text(a.label, style: const TextStyle(fontSize: 12)),
                          ],
                        )).toList(),
                      ),
                    ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessButton(IconData icon, String label, Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kPrimaryBlue,
        leading: Builder(
          builder: (BuildContext innerContext) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(innerContext).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              widget.onTabSelected(2); // Navigate to Favorites tab (index 2)
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationScreen(),
                    ),
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
                      border: Border.all(
                        color: Colors.white.withAlpha((255 * 1.0).round()),
                        width: 1.5,
                      ),
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
                ),
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
                  image: const AssetImage('assets/hotel_drawer_bg.jpg'),
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
                    style: TextStyle(
                      color: Color.fromARGB(178, 255, 255, 255),
                      fontSize: 14,
                    ),
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
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
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
                  MaterialPageRoute(
                    builder: (context) => const SupportScreen(),
                  ),
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
                  MaterialPageRoute(
                    builder: (context) => const AboutUsScreen(),
                  ),
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
                  MaterialPageRoute(
                    builder: (context) => const FeedbackScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.contact_mail_outlined,
                color: kDarkBlue,
              ),
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
              leading: const Icon(Icons.description_outlined, color: kDarkBlue),
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
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.redAccent),
              ),
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
                        ElevatedButton(
                          // Changed to ElevatedButton
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFFE74C3C,
                            ), // Red color
                            foregroundColor: Colors.white, // White text color
                          ),
                          onPressed: () {
                            // Dismiss the dialog
                            Navigator.of(context).pop();
                            // Perform the actual logout action and navigate
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                              (Route<dynamic> route) =>
                                  false, // Clears all previous routes
                            );
                            // Show a SnackBar notification
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('You have been logged out.'),
                                ),
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
                  prefixIcon: const Icon(Icons.search, color: kDarkBlue),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 15,
                  ),
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
                  _buildQuickAccessButton(Icons.all_inclusive, 'All', () => _filterHotels('All')),
                  _buildQuickAccessButton(Icons.diamond, 'Luxury', () => _filterHotels('Luxury')),
                  _buildQuickAccessButton(Icons.money, 'Budget', () => _filterHotels('Budget')),
                  _buildQuickAccessButton(Icons.place, 'Near Me', () => _filterHotels('Malvar')),
                  _buildQuickAccessButton(Icons.star, 'Top Rated', () => _filterHotels('Top Rated')),
                  _buildQuickAccessButton(Icons.family_restroom, 'Family', () => _filterHotels('Family')),
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
                return _buildHotelCard(hotel);
              }).toList(),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
