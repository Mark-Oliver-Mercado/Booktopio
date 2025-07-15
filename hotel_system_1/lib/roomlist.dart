import 'package:flutter/material.dart';
import 'bookingform.dart';
import 'filter.dart';

class RoomListScreen extends StatefulWidget {
  final String hotelName;

  const RoomListScreen({super.key, required this.hotelName});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Room> allRooms = [];
  List<Room> filteredRooms = [];

  // Filter values
  int? selectedMinPrice = 0;
  int? selectedMaxPrice = 300;
  int? selectedCapacity;
  String selectedType = 'All';

  @override
  void initState() {
    super.initState();

    allRooms = [
      Room(
        name: 'Deluxe Room',
        price: 120,
        type: 'Deluxe',
        capacity: 2,
        features: '1 King Bed • Free Wi-Fi • Ocean View',
        image: 'assets/logo.png',
        description:
            'Experience luxury in our spacious Deluxe Room, featuring a comfortable king-size bed and stunning ocean views...',
        amenities: const [
          Amenity(icon: Icons.wifi, label: 'Wi-Fi'),
          Amenity(icon: Icons.hot_tub, label: 'Jacuzzi'),
          Amenity(icon: Icons.local_bar, label: 'Mini Bar'),
          Amenity(icon: Icons.king_bed, label: 'King Bed'),
          Amenity(icon: Icons.tv, label: 'Smart TV'),
        ],
      ),
      Room(
        name: 'Standard Room',
        price: 80,
        type: 'Standard',
        capacity: 1,
        features: '1 Queen Bed • Free Wi-Fi • City View',
        image: 'assets/google.png',
        description:
            'Our Standard Room offers a cozy retreat with a queen-size bed and picturesque city views...',
        amenities: const [
          Amenity(icon: Icons.wifi, label: 'Wi-Fi'),
          Amenity(icon: Icons.single_bed, label: 'Queen Bed'),
          Amenity(icon: Icons.tv, label: 'TV'),
        ],
      ),
      Room(
        name: 'Executive Suite',
        price: 200,
        type: 'Suite',
        capacity: 4,
        features: '2 Rooms • Lounge Access • Pool View',
        image: 'assets/facebook.png',
        description:
            'Indulge in the expansive Executive Suite, offering two distinct rooms and exclusive lounge access...',
        amenities: const [
          Amenity(icon: Icons.wifi, label: 'Wi-Fi'),
          Amenity(icon: Icons.pool, label: 'Pool Access'),
          Amenity(icon: Icons.coffee_maker, label: 'Coffee Maker'),
          Amenity(icon: Icons.chair, label: 'Lounge'),
          Amenity(icon: Icons.balcony, label: 'Balcony'),
        ],
      ),
    ];

    filteredRooms = List.from(allRooms);
  }

  void _filter(String query) {
    setState(() {
      filteredRooms = filterRooms(
        allRooms,
        query,
        minPrice: selectedMinPrice,
        maxPrice: selectedMaxPrice,
        capacity: selectedCapacity,
        type: selectedType,
      );
    });
  }

  void _openFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(20)),
          child: _buildFilterForm(),
        );
      },
    );
  }

  Widget _buildFilterForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Filter Rooms', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),

        Row(
          children: [
            const Text('Min Price:'),
            const SizedBox(width: 10),
            DropdownButton<int>(
              value: selectedMinPrice,
              items: [0, 50, 100, 150].map((v) => DropdownMenuItem(value: v, child: Text('\$$v'))).toList(),
              onChanged: (value) => setState(() => selectedMinPrice = value),
            ),
            const Spacer(),
            const Text('Max Price:'),
            const SizedBox(width: 10),
            DropdownButton<int>(
              value: selectedMaxPrice,
              items: [100, 150, 200, 300].map((v) => DropdownMenuItem(value: v, child: Text('\$$v'))).toList(),
              onChanged: (value) => setState(() => selectedMaxPrice = value),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            const Text('Capacity:'),
            const SizedBox(width: 10),
            DropdownButton<int>(
              value: selectedCapacity,
              hint: const Text('Any'),
              items: [1, 2, 3, 4].map((v) => DropdownMenuItem(value: v, child: Text('$v pax'))).toList(),
              onChanged: (value) => setState(() => selectedCapacity = value),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            const Text('Room Type:'),
            const SizedBox(width: 10),
            DropdownButton<String>(
              value: selectedType,
              items: ['All', 'Standard', 'Deluxe', 'Suite']
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (value) => setState(() => selectedType = value!),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            _filter(_searchController.text);
          },
          icon: const Icon(Icons.check),
          label: const Text('Apply Filters'),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50)),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBE9E7),
      appBar: AppBar(
        title: Text(
          '${widget.hotelName} Rooms',
          style: const TextStyle(
            color: Color(0xFF5D4037),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFFCCBC),
        iconTheme: const IconThemeData(color: Color(0xFF5D4037)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _searchController,
            onChanged: _filter,
            decoration: InputDecoration(
              hintText: 'Search rooms...',
              prefixIcon: const Icon(Icons.search, color: Colors.brown),
              suffixIcon: IconButton(
                icon: const Icon(Icons.filter_list, color: Colors.brown),
                onPressed: _openFilterDialog,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          for (var room in filteredRooms) ...[
            _buildRoomCard(context, room),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildRoomCard(BuildContext context, Room room) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              room.image,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 180,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.error_outline, size: 50)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(room.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4E342E))),
                const SizedBox(height: 6),
                Text(room.features, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: room.amenities.take(5).map((a) => _AmenityIcon(icon: a.icon, label: a.label)).toList(),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${room.price} / night', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingFormScreen(
                              hotelName: widget.hotelName,
                              roomType: room.name,
                              price: room.price,
                              roomImagePath: room.image,
                              roomDescription: room.description,
                              amenities: room.amenities,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50)),
                      child: const Text('Book Now'),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _AmenityIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _AmenityIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.teal),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
