import 'package:flutter/material.dart';
import 'home.dart'; // Import home.dart to access its color constants and Hotel model
import '../bookings/roomlist.dart'; // ADDED: Import for RoomListScreen

const Color kPrimaryBlue = Color(0xFF0065FF); // A vibrant blue for primary elements
const Color kDarkBlue = Color(0xFF003C99); // A darker blue for text/icons
const Color kLightBlue = Color(0xFFE6F2FF); // A very light blue for backgrounds
const Color kAccentBlue = Color(0xFF007BFF); // An accent blue for highlights (not directly used here but good for consistency)

class FavoritesScreen extends StatefulWidget {
  final VoidCallback? onFavoriteChanged; // Callback to notify HomePage of changes

  const FavoritesScreen({super.key, this.onFavoriteChanged});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<Hotel> _favoriteHotels;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      _favoriteHotels = HomeContent.getFavoriteHotels();
    });
  }

  // Map amenity strings to their respective IconData (copied from home.dart for convenience)
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

  Widget _buildHotelCard(
      BuildContext context,
      Hotel hotel,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RoomListScreen(hotelName: hotel.name), // Pass the hotel name
          ),
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
                  borderRadius: const BorderRadius.vertical( // Added const
                    top: Radius.circular(12),
                  ),
                  child: Image.asset(
                    hotel.image,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Icon( // Added const
                          Icons.image_not_supported,
                          size: 60,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
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
                      setState(() {
                        hotel.isFavorite = !hotel.isFavorite; // Toggle status
                        _loadFavorites(); // Reload the list to update UI
                        if (widget.onFavoriteChanged != null) {
                          widget.onFavoriteChanged!(); // Notify HomePage
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0), // Added const
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name,
                    style: const TextStyle( // Added const
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kDarkBlue,
                    ),
                  ),
                  const SizedBox(height: 6), // Added const
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon( // Added const
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 5), // Added const
                          Text(
                            hotel.location,
                            style: const TextStyle( // Added const
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Added const
                        decoration: BoxDecoration(
                          color: kLightBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          hotel.priceRange,
                          style: const TextStyle( // Added const
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: kDarkBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6), // Added const
                  Row(
                    children: [
                      const Icon( // Added const
                        Icons.star,
                        color: Colors.orange,
                        size: 18,
                      ),
                      const SizedBox(width: 5), // Added const
                      Text(hotel.rating, style: const TextStyle(fontSize: 14)), // Added const
                    ],
                  ),
                  const SizedBox(height: 10), // Added const
                  Text(
                    hotel.description,
                    style: const TextStyle(fontSize: 14, color: Colors.black87), // Added const
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 15), // Added const
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: hotel.amenities.map((amenity) {
                      return Column(
                        children: [
                          Icon(
                            _amenityIcons[amenity] ?? Icons.help_outline,
                            size: 24,
                            color: kDarkBlue,
                          ),
                          const SizedBox(height: 5), // Added const
                          Text(amenity, style: const TextStyle(fontSize: 12)), // Added const
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
      backgroundColor: kLightBlue,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text( // Added const
          'My Favorites',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kPrimaryBlue,
        elevation: 0,
      ),
      body: _favoriteHotels.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon( // Added const
              Icons.favorite_border,
              size: 80,
              color: kDarkBlue,
            ),
            const SizedBox(height: 20), // Added const
            const Text( // Added const
              'No favorite hotels added yet.',
              style: TextStyle(
                fontSize: 18,
                color: kDarkBlue,
              ),
            ),
            const Text( // Added const
              'Tap the heart icon on hotel listings to add them here!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0), // Added const
        itemCount: _favoriteHotels.length,
        itemBuilder: (context, index) {
          final hotel = _favoriteHotels[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0), // Added const
            child: _buildHotelCard(context, hotel),
          );
        },
      ),
    );
  }
}