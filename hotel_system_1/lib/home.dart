import 'package:flutter/material.dart';
import 'roomlist.dart';
import 'bookings.dart'; // ✅ import the bookings screen
import 'favorites.dart'; // ✅ create this screen
import 'profile.dart';   // ✅ create this screen

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
     const HomeContent(),       // Dashboard screen
    const BookingsScreen(),    // Booking history
    const FavoritesScreen(),   // Favorites
    const ProfileScreen(),     // Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.brown.shade300,
        backgroundColor: const Color(0xFFFFCCBC),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
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
      backgroundColor: const Color(0xFFFBE9E7),
      appBar: AppBar(
        title: const Text(
          'Explore Hotels',
          style: TextStyle(
            color: Color(0xFF5D4037),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFFCCBC),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF5D4037)),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Color(0xFF5D4037)),
            onPressed: () {},
          ),
        ],
        elevation: 0,
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
                color: Color(0xFF4E342E),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search hotels...',
                prefixIcon: const Icon(Icons.search, color: Colors.brown),
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
                color: Color(0xFF6D4C41),
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
              image: 'assets/apple.png',
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
              color: Colors.brown.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Icon(icon, size: 30, color: Colors.brown),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.brown)),
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
          MaterialPageRoute(
            builder: (_) => RoomListScreen(hotelName: name),
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
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
                      color: Color(0xFF4E342E),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(location,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          color: Colors.orange, size: 18),
                      const SizedBox(width: 5),
                      Text(rating,
                          style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style:
                        const TextStyle(fontSize: 14, color: Colors.black87),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Column(
                        children: [
                          Icon(Icons.wifi, size: 24, color: Colors.teal),
                          SizedBox(height: 5),
                          Text('Wi-Fi', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.pool, size: 24, color: Colors.teal),
                          SizedBox(height: 5),
                          Text('Pool', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.restaurant,
                              size: 24, color: Colors.teal),
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
