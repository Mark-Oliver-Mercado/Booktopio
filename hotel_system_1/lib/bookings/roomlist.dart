import 'package:flutter/material.dart';
import 'bookingform.dart';
import '../filter.dart'; // This file is expected to contain Room and Amenity class definitions

// Define the main blue and white colors for consistency
const Color kPrimaryBlue = Color(0xFF0065FF); // A vibrant blue for primary elements
const Color kDarkBlue = Color(0xFF003C99); // A darker blue for text/icons
const Color kLightBlue = Color(0xFFE6F2FF); // A very light blue for backgrounds
const Color kWhite = Colors.white; // Pure white for elements

// It is assumed that Room and Amenity classes are defined in filter.dart
// If they are not, please move their definitions from here to filter.dart
// to avoid duplicate definitions and type conflicts.

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
  int? selectedMaxPrice = 20000; // Adjusted max price for Philippine Pesos to cover all ranges
  int? selectedCapacity;
  String selectedType = 'All';

  // Map of hotel names to their respective room lists
  final Map<String, List<Room>> _hotelRoomsData = {
    'Seaside Resort Boracay': [
    Room(name: 'Deluxe Ocean View', price: 7500, type: 'Deluxe', capacity: 2, features: '1 King Bed • Private Balcony • Ocean View', image: 'assets/room1.png', description: 'Experience luxury in our spacious Deluxe Room, featuring a comfortable king-size bed and stunning ocean views...', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.hot_tub, label: 'Jacuzzi'), Amenity(icon: Icons.balcony, label: 'Balcony'), Amenity(icon: Icons.beach_access, label: 'Beach Access'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Standard Garden View', price: 3500, type: 'Standard', capacity: 2, features: '1 Queen Bed • Garden View • Free Wi-Fi', image: 'assets/room2.png', description: 'Our Standard Room offers a cozy retreat with a queen-size bed and picturesque garden views...', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.single_bed, label: 'Queen Bed'), Amenity(icon: Icons.tv, label: 'TV'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Family Suite', price: 6500, type: 'Suite', capacity: 4, features: '2 Bedrooms • Living Area • Pool Access', image: 'assets/room3.png', description: 'Indulge in the expansive Family Suite, offering two distinct rooms and exclusive pool access...', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.pool, label: 'Pool Access'), Amenity(icon: Icons.kitchen, label: 'Kitchenette'), Amenity(icon: Icons.family_restroom, label: 'Family Room'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Executive Suite Oceanfront', price: 7800, type: 'Suite', capacity: 3, features: '1 King Bed • Executive Lounge • Oceanfront Balcony', image: 'assets/room4.png', description: 'The ultimate luxury with direct oceanfront views and access to exclusive executive lounge.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.hot_tub, label: 'Jacuzzi'), Amenity(icon: Icons.local_bar, label: 'Mini Bar'), Amenity(icon: Icons.balcony, label: 'Balcony'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Superior Room', price: 4000, type: 'Standard', capacity: 2, features: '1 King Bed • City View • Work Desk', image: 'assets/room5.png', description: 'A comfortable and functional room with a king-size bed and a dedicated work desk.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.desk, label: 'Work Desk'), Amenity(icon: Icons.tv, label: 'TV'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Honeymoon Villa', price: 8000, type: 'Villa', capacity: 2, features: 'Private Pool • Secluded Garden • Romantic Setup', image: 'assets/room6.png', description: 'A private villa designed for romance, featuring your own pool and secluded garden.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.pool, label: 'Private Pool'), Amenity(icon: Icons.spa, label: 'Spa'), Amenity(icon: Icons.wine_bar, label: 'Wine Bar'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Budget Room', price: 3000, type: 'Budget', capacity: 1, features: '1 Single Bed • Basic Amenities', image: 'assets/room7.png', description: 'A simple and affordable room with essential amenities for a comfortable stay.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.single_bed, label: 'Single Bed'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Connecting Rooms', price: 6000, type: 'Family', capacity: 5, features: '2 Connecting Rooms • Shared Bathroom', image: 'assets/room8.png', description: 'Ideal for families, offering two connecting rooms for ample space and privacy.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.family_restroom, label: 'Family Room'), Amenity(icon: Icons.tv, label: 'TV'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Presidential Suite', price: 7900, type: 'Suite', capacity: 4, features: 'Luxury Furnishings • Personal Butler • Panoramic Views', image: 'assets/room9.png', description: 'The pinnacle of luxury with panoramic views, exquisite furnishings, and personalized butler service.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.hot_tub, label: 'Jacuzzi'), Amenity(icon: Icons.local_bar, label: 'Mini Bar'), Amenity(icon: Icons.room_service, label: 'Room Service'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Studio Apartment', price: 4500, type: 'Apartment', capacity: 2, features: 'Kitchenette • Living Area • City View', image: 'assets/room10.png', description: 'A compact and modern studio apartment with a well-equipped kitchenette and city views.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.kitchen, label: 'Kitchenette'), Amenity(icon: Icons.tv, label: 'TV'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
    ],
    'Malvar Mountain Retreat': [
    Room(name: 'Mountain View Cabin', price: 4500, type: 'Cabin', capacity: 2, features: '1 Queen Bed • Mountain View Balcony • Fireplace', image: 'assets/room1.png', description: 'A cozy cabin with stunning mountain views, a private balcony, and a warm fireplace.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.fireplace, label: 'Fireplace'), Amenity(icon: Icons.balcony, label: 'Balcony'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Forest Suite', price: 5000, type: 'Suite', capacity: 3, features: '1 King Bed • Forest View • Jacuzzi', image: 'assets/room2.png', description: 'Spacious suite with lush forest views and a relaxing in-room jacuzzi.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Wi'), Amenity(icon: Icons.hot_tub, label: 'Jacuzzi'), Amenity(icon: Icons.local_bar, label: 'Mini Bar'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Standard Room', price: 2500, type: 'Standard', capacity: 2, features: '1 Double Bed • Garden Access', image: 'assets/room3.png', description: 'A comfortable standard room with direct access to the beautiful garden.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.local_florist, label: 'Garden'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Family Lodge', price: 4800, type: 'Lodge', capacity: 5, features: '2 Bedrooms • Kitchenette • Dining Area', image: 'assets/room4.png', description: 'A spacious lodge perfect for families, complete with a kitchenette and dining area.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.kitchen, label: 'Kitchenette'), Amenity(icon: Icons.family_restroom, label: 'Family Room'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Deluxe View Room', price: 3800, type: 'Deluxe', capacity: 2, features: '1 King Bed • Panoramic Window View', image: 'assets/room5.png', description: 'Enjoy breathtaking panoramic views from this deluxe room with a king-size bed.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.tv, label: 'Smart TV'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Hiker\'s Den', price: 2000, type: 'Budget', capacity: 1, features: '1 Single Bed • Basic Amenities • Near Trailhead', image: 'assets/room6.png', description: 'A simple and convenient room for hikers, located near the main trailheads.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.hiking, label: 'Hiking Access'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Executive Cabin', price: 3500, type: 'Cabin', capacity: 2, features: 'Luxury Furnishings • Private Deck • BBQ Grill', image: 'assets/room7.png', description: 'An executive cabin with luxury furnishings, a private deck, and a BBQ grill for outdoor dining.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.deck, label: 'Private Deck'), Amenity(icon: Icons.outdoor_grill, label: 'BBQ'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Glamping Tent', price: 3000, type: 'Glamping', capacity: 2, features: 'Luxury Tent • Outdoor Seating • Shared Bathroom', image: 'assets/room8.png', description: 'Experience glamping in a luxurious tent with comfortable outdoor seating.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.chair, label: 'Outdoor Seating'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Summit Suite', price: 4900, type: 'Suite', capacity: 4, features: 'Top Floor • Best Views • Private Dining Area', image: 'assets/room9.png', description: 'Located on the top floor, this suite offers the best views and a private dining area.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.restaurant, label: 'Dining Area'), Amenity(icon: Icons.balcony, label: 'Balcony'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Cozy Nook', price: 2200, type: 'Standard', capacity: 1, features: '1 Single Bed • Quiet Corner • Reading Lamp', image: 'assets/room10.png', description: 'A small, cozy room perfect for a solo traveler looking for a quiet space to relax and read.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.book, label: 'Reading Nook'), Amenity(icon: Icons.ac_unit, label: 'AC')]), ],
    'El Nido Island Paradise': [
    Room(name: 'Beachfront Villa', price: 14000, type: 'Villa', capacity: 2, features: 'Private Beach Access • King Bed • Outdoor Shower', image: 'assets/room1.png', description: 'Luxurious villa with direct private beach access and an invigorating outdoor shower.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.beach_access, label: 'Private Beach'), Amenity(icon: Icons.shower, label: 'Outdoor Shower'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Overwater Bungalow', price: 15000, type: 'Bungalow', capacity: 2, features: 'Glass Floor • Direct Ocean Access • Sundeck', image: 'assets/room2.png', description: 'Experience unique luxury in a bungalow built over the water with a glass floor and direct ocean access.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.water, label: 'Ocean Access'), Amenity(icon: Icons.balcony, label: 'Sundeck'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Garden Casita', price: 8000, type: 'Casita', capacity: 2, features: 'Secluded Garden • Queen Bed • Hammock', image: 'assets/room3.png', description: 'A charming, secluded casita surrounded by a lush garden, perfect for relaxation with a hammock.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.local_florist, label: 'Garden'), Amenity(icon: Icons.self_improvement, label: 'Hammock'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Family Beach House', price: 12000, type: 'House', capacity: 5, features: '3 Bedrooms • Full Kitchen • Private Dining', image: 'assets/room4.png', description: 'A spacious beach house with multiple bedrooms, a full kitchen, and private dining area, ideal for large families.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.kitchen, label: 'Full Kitchen'), Amenity(icon: Icons.family_restroom, label: 'Family Room'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Cliffside Suite', price: 10000, type: 'Suite', capacity: 2, features: 'Panoramic Ocean Views • Infinity Pool Access', image: 'assets/room5.png', description: 'Perched on a cliff with panoramic ocean views and access to a stunning infinity pool.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.pool, label: 'Infinity Pool'), Amenity(icon: Icons.balcony, label: 'Balcony'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Eco-Lodge Room', price: 7000, type: 'Eco-friendly', capacity: 2, features: 'Sustainable Design • Nature Immersion', image: 'assets/room6.png', description: 'An eco-friendly room designed for nature immersion, featuring sustainable materials and practices.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.eco, label: 'Eco-friendly'), Amenity(icon: Icons.nature, label: 'Nature Views'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Diver\'s Den', price: 9000, type: 'Standard', capacity: 2, features: 'Near Dive Center • Gear Storage', image: 'assets/room7.png', description: 'Conveniently located near the dive center with dedicated storage for your diving gear.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.scuba_diving, label: 'Dive Center Access'), Amenity(icon: Icons.storage, label: 'Gear Storage'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Sunset View Room', price: 11000, type: 'Deluxe', capacity: 2, features: 'Best Sunset Spot • Private Terrace', image: 'assets/room8.png', description: 'Enjoy the most spectacular sunsets from your private terrace in this deluxe room.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Wi'), Amenity(icon: Icons.balcony, label: 'Private Terrace'), Amenity(icon: Icons.wb_sunny, label: 'Sunset View'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Island Hopper Suite', price: 7500, type: 'Suite', capacity: 3, features: 'Complimentary Island Tour • Spacious Living', image: 'assets/room9.png', description: 'A spacious suite that includes a complimentary island hopping tour for an unforgettable experience.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.directions_boat, label: 'Island Tour'), Amenity(icon: Icons.room_service, label: 'Room Service'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Budget Room', price: 6000, type: 'Budget', capacity: 1, features: 'Basic Amenities • Shared Bathroom', image: 'assets/room10.png', description: 'An affordable room with basic amenities, perfect for solo travelers on a budget.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.single_bed, label: 'Single Bed'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
       ],
    'Cebu City Business Hotel': [
Room(name: 'Executive Business Room', price: 4000, type: 'Deluxe', capacity: 1, features: 'King Bed • Executive Desk • City View', image: 'assets/room1.png', description: 'Designed for business travelers, featuring an executive desk and city views.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.desk, label: 'Work Desk'), Amenity(icon: Icons.business_center, label: 'Business Center'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Standard City View', price: 2000, type: 'Standard', capacity: 2, features: 'Queen Bed • Basic Amenities', image: 'assets/room2.png', description: 'A comfortable standard room with a queen-size bed and city views.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.tv, label: 'TV'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Conference Suite', price: 4500, type: 'Suite', capacity: 4, features: 'Small Meeting Area • Projector • Whiteboard', image: 'assets/room3.png', description: 'A versatile suite with a dedicated small meeting area, perfect for business discussions.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Wi'), Amenity(icon: Icons.meeting_room, label: 'Meeting Area'), Amenity(icon: Icons.tv, label: 'Projector'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Deluxe Twin Room', price: 3000, type: 'Deluxe', capacity: 2, features: '2 Single Beds • City View', image: 'assets/room4.png', description: 'A deluxe room with two single beds and views of the bustling city.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.single_bed, label: 'Twin Beds'), Amenity(icon: Icons.tv, label: 'TV'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Junior Suite', price: 3800, type: 'Suite', capacity: 3, features: 'Separate Living Area • King Bed', image: 'assets/room5.png', description: 'A spacious junior suite with a separate living area and a comfortable king-size bed.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.living_outlined, label: 'Living Area'), Amenity(icon: Icons.local_bar, label: 'Mini Bar'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Budget Single Room', price: 1800, type: 'Budget', capacity: 1, features: '1 Single Bed • Shared Bathroom', image: 'assets/room6.png', description: 'An economical single room with essential amenities and access to a shared bathroom.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.single_bed, label: 'Single Bed'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Fitness Room', price: 3500, type: 'Standard', capacity: 1, features: 'Exercise Bike • Yoga Mat • Healthy Snacks', image: 'assets/room7.png', description: 'Stay active in this room equipped with an exercise bike, yoga mat, and healthy snacks.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.fitness_center, label: 'Fitness Gear'), Amenity(icon: Icons.local_dining, label: 'Healthy Snacks'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Accessible Room', price: 2800, type: 'Standard', capacity: 2, features: 'Wheelchair Accessible • Grab Bars', image: 'assets/room8.png', description: 'A thoughtfully designed accessible room with features for comfortable stay.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.accessible_forward, label: 'Accessible'), Amenity(icon: Icons.bathtub, label: 'Grab Bars'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Family Connecting Room', price: 4200, type: 'Family', capacity: 4, features: '2 Connecting Rooms • Shared Lounge', image: 'assets/room9.png', description: 'Two connecting rooms perfect for families, offering ample space and a shared lounge area.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Wi'), Amenity(icon: Icons.family_restroom, label: 'Family Room'), Amenity(icon: Icons.tv, label: 'TV'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Penthouse Suite', price: 4400, type: 'Suite', capacity: 4, features: 'Top Floor • Panoramic City View • Private Bar', image: 'assets/room10.png', description: 'The luxurious penthouse suite on the top floor, offering panoramic city views and a private bar.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.local_bar, label: 'Private Bar'), Amenity(icon: Icons.balcony, label: 'Panoramic View'), Amenity(icon: Icons.ac_unit, label: 'AC')]),  ],
    'Tagaytay Lakeview Suites': [
   Room(name: 'Lakeview Deluxe', price: 6000, type: 'Deluxe', capacity: 2, features: 'King Bed • Taal Lake View • Balcony', image: 'assets/room1.png', description: 'A deluxe room offering stunning views of Taal Lake from your private balcony.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.water, label: 'Lake View'), Amenity(icon: Icons.balcony, label: 'Balcony'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Garden Suite', price: 5500, type: 'Suite', capacity: 3, features: 'Queen Bed • Private Garden • Outdoor Seating', image: 'assets/room2.png', description: 'A serene suite with a private garden and comfortable outdoor seating area.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Wi'), Amenity(icon: Icons.local_florist, label: 'Garden'), Amenity(icon: Icons.chair, label: 'Outdoor Seating'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Standard Room', price: 2800, type: 'Standard', capacity: 2, features: 'Double Bed • Basic Amenities', image: 'assets/room3.png', description: 'A comfortable standard room with essential amenities for a pleasant stay.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.tv, label: 'TV'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Family Villa', price: 6800, type: 'Villa', capacity: 5, features: '3 Bedrooms • Kitchen • Lake Access', image: 'assets/room4.png', description: 'A spacious villa with multiple bedrooms and a kitchen, offering convenient lake access.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.kitchen, label: 'Kitchen'), Amenity(icon: Icons.family_restroom, label: 'Family Room'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Romantic Casita', price: 7000, type: 'Casita', capacity: 2, features: 'Secluded • Jacuzzi • Candlelight Setup', image: 'assets/room5.png', description: 'A secluded casita designed for a romantic getaway, complete with a jacuzzi and special setup.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.hot_tub, label: 'Jacuzzi'), Amenity(icon: Icons.wine_bar, label: 'Wine Service'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Budget Room', price: 2500, type: 'Budget', capacity: 1, features: 'Single Bed • Shared Bathroom', image: 'assets/room6.png', description: 'An affordable room with basic amenities, suitable for solo travelers on a budget.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.single_bed, label: 'Single Bed'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Executive Suite', price: 6200, type: 'Suite', capacity: 4, features: 'Separate Living Room • Dining Area • Lake View', image: 'assets/room7.png', description: 'A luxurious executive suite with separate living and dining areas, offering stunning lake views.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.restaurant, label: 'Dining Area'), Amenity(icon: Icons.balcony, label: 'Lake View'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Spa Retreat Room', price: 6500, type: 'Deluxe', capacity: 2, features: 'Complimentary Spa Session • Aromatherapy Diffuser', image: 'assets/room8.png', description: 'A deluxe room focused on wellness, including a complimentary spa session and aromatherapy.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Wi'), Amenity(icon: Icons.spa, label: 'Spa Access'), Amenity(icon: Icons.self_improvement, label: 'Aromatherapy'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Artist\'s Loft', price: 3000, type: 'Unique', capacity: 2, features: 'Creative Decor • Art Supplies • Inspiring Views', image: 'assets/room9.png', description: 'A uniquely designed loft with creative decor, art supplies, and inspiring views for artists.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.brush, label: 'Art Supplies'), Amenity(icon: Icons.palette, label: 'Creative Space'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Pet-Friendly Room', price: 3500, type: 'Standard', capacity: 2, features: 'Pet Amenities • Garden Access', image: 'assets/room10.png', description: 'A comfortable room that welcomes your furry friends, with dedicated pet amenities and garden access.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Wi'), Amenity(icon: Icons.pets, label: 'Pet-friendly'), Amenity(icon: Icons.local_florist, label: 'Garden'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
 ],
    'Siargao Surfer\'s Haven': [
    Room(name: 'Surf Shack', price: 2500, type: 'Budget', capacity: 1, features: 'Single Bed • Fan • Surfboard Rack', image: 'assets/room1.png', description: 'A basic surf shack ideal for solo surfers, equipped with a fan and surfboard rack.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.surfing, label: 'Surfboard Rack'), Amenity(icon: Icons.shower, label: 'Outdoor Shower')]),
      Room(name: 'Beach Bungalow', price: 3500, type: 'Standard', capacity: 2, features: 'Queen Bed • Beach Access • Hammock', image: 'assets/room2.png', description: 'A charming bungalow with direct beach access and a relaxing hammock.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.beach_access, label: 'Beach Access'), Amenity(icon: Icons.self_improvement, label: 'Hammock')]),
      Room(name: 'Family Villa', price: 3000, type: 'Villa', capacity: 4, features: '2 Bedrooms • Kitchenette • Patio', image: 'assets/room3.png', description: 'A spacious villa with two bedrooms, a kitchenette, and a private patio, great for families.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.kitchen, label: 'Kitchenette'), Amenity(icon: Icons.family_restroom, label: 'Family Room')]),
      Room(name: 'Deluxe Ocean View', price: 3200, type: 'Deluxe', capacity: 2, features: 'King Bed • Ocean View Balcony', image: 'assets/room4.png', description: 'Enjoy stunning ocean views from the private balcony of this deluxe room.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.balcony, label: 'Balcony'), Amenity(icon: Icons.water, label: 'Ocean View')]),
      Room(name: 'Dorm Bed', price: 1200, type: 'Budget', capacity: 1, features: 'Bunk Bed • Shared Bathroom • Locker', image: 'assets/room5.png', description: 'An economical bunk bed in a shared dormitory, with a personal locker for your belongings.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.lock, label: 'Locker')]),
      Room(name: 'Treehouse Room', price: 3400, type: 'Unique', capacity: 2, features: 'Elevated Room • Forest Canopy View', image: 'assets/room6.png', description: 'A unique elevated room offering immersive views of the forest canopy.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.nature, label: 'Forest View'), Amenity(icon: Icons.eco, label: 'Eco-friendly')]),
      Room(name: 'Surfer\'s Suite', price: 3300, type: 'Suite', capacity: 3, features: 'Spacious • Private Gear Drying Area • Lounge', image: 'assets/room7.png', description: 'A spacious suite designed for surfers, featuring a private gear drying area and a comfortable lounge.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.surfing, label: 'Surf Gear Area'), Amenity(icon: Icons.chair, label: 'Lounge')]),
      Room(name: 'Garden View Room', price: 2800, type: 'Standard', capacity: 2, features: 'Queen Bed • Lush Garden View', image: 'assets/room8.png', description: 'A comfortable room with a queen-size bed and views of the lush garden.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.local_florist, label: 'Garden View')]),
      Room(name: 'Private Cottage', price: 2900, type: 'Cottage', capacity: 2, features: 'Secluded • Outdoor Seating • Basic Kitchen', image: 'assets/room9.png', description: 'A secluded private cottage with outdoor seating and a basic kitchen for your convenience.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.kitchen, label: 'Basic Kitchen'), Amenity(icon: Icons.chair, label: 'Outdoor Seating')]),
      Room(name: 'Yoga Retreat Room', price: 2700, type: 'Wellness', capacity: 1, features: 'Yoga Mat • Meditation Cushion • Quiet Zone', image: 'assets/room10.png', description: 'A tranquil room dedicated to wellness, equipped with a yoga mat and meditation cushion.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.self_improvement, label: 'Yoga Mat'), Amenity(icon: Icons.spa, label: 'Meditation')]),],
    'Manila Urban Grand': [
   Room(name: 'Executive City View', price: 8000, type: 'Deluxe', capacity: 2, features: 'King Bed • Panoramic City View • Lounge Access', image: 'assets/room1.png', description: 'An executive room offering panoramic city views and exclusive lounge access.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.business_center, label: 'Lounge Access'), Amenity(icon: Icons.balcony, label: 'City View'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Standard Room', price: 4500, type: 'Standard', capacity: 2, features: 'Queen Bed • Basic Amenities', image: 'assets/room2.png', description: 'A comfortable standard room with a queen-size bed and essential amenities.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.tv, label: 'TV'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Presidential Suite', price: 9800, type: 'Suite', capacity: 4, features: 'Multiple Rooms • Private Bar • Butler Service', image: 'assets/room3.png', description: 'The epitome of luxury, this suite offers multiple rooms, a private bar, and personalized butler service.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.local_bar, label: 'Private Bar'), Amenity(icon: Icons.room_service, label: 'Butler Service'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Family Room', price: 7000, type: 'Family', capacity: 4, features: '2 Queen Beds • Connecting Option', image: 'assets/room4.png', description: 'An ideal room for families, featuring two queen beds and an option for connecting rooms.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.family_restroom, label: 'Family Room'), Amenity(icon: Icons.tv, label: 'TV'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Club Room', price: 6000, type: 'Deluxe', capacity: 2, features: 'Access to Club Lounge • Complimentary Breakfast', image: 'assets/room5.png', description: 'A deluxe room with exclusive access to the club lounge and complimentary breakfast.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.coffee, label: 'Breakfast'), Amenity(icon: Icons.local_bar, label: 'Club Lounge'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Business Suite', price: 9500, type: 'Suite', capacity: 2, features: 'Separate Office Area • High-Speed Internet', image: 'assets/room6.png', description: 'A professional suite with a dedicated office area and high-speed internet, perfect for business trips.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.desk, label: 'Office Area'), Amenity(icon: Icons.print, label: 'Printer'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Accessible Room', price: 4000, type: 'Standard', capacity: 2, features: 'Wheelchair Accessible • Roll-in Shower', image: 'assets/room7.png', description: 'A comfortable and accessible room with features designed for guests with mobility needs.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.accessible_forward, label: 'Accessible'), Amenity(icon: Icons.shower, label: 'Roll-in Shower'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Premier Suite', price: 10000, type: 'Suite', capacity: 3, features: 'Spacious Layout • Dining Table • City Lights View', image: 'assets/room8.png', description: 'A spacious premier suite with a dining table and captivating city lights view.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.restaurant, label: 'Dining Area'), Amenity(icon: Icons.balcony, label: 'City Lights View'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Studio Apartment', price: 5500, type: 'Apartment', capacity: 2, features: 'Kitchenette • Living Area • Long Stay Friendly', image: 'assets/room9.png', description: 'A fully equipped studio apartment with a kitchenette and living area, ideal for long stays.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.kitchen, label: 'Kitchenette'), Amenity(icon: Icons.living_outlined, label: 'Living Area'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Budget Room', price: 4000, type: 'Budget', capacity: 1, features: 'Single Bed • Shared Lounge Access', image: 'assets/room10.png', description: 'An affordable single room with access to a shared lounge, perfect for budget-conscious travelers.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.single_bed, label: 'Single Bed'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      ],
    'Baguio Pine Forest Lodge': [
     Room(name: 'Pine View Cabin', price: 4500, type: 'Cabin', capacity: 2, features: '1 King Bed • Pine Forest View • Balcony', image: 'assets/room1.png', description: 'A charming cabin offering serene pine forest views from its private balcony.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.balcony, label: 'Balcony'), Amenity(icon: Icons.nature, label: 'Forest View'), Amenity(icon: Icons.fireplace, label: 'Fireplace')]),
      Room(name: 'Cozy Standard Room', price: 2500, type: 'Standard', capacity: 2, features: 'Queen Bed • Garden Access', image: 'assets/room2.png', description: 'A cozy standard room with a queen-size bed and direct access to the lodge garden.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Wi'), Amenity(icon: Icons.local_florist, label: 'Garden'), Amenity(icon: Icons.tv, label: 'TV')]),
      Room(name: 'Family Suite', price: 5000, type: 'Suite', capacity: 4, features: '2 Bedrooms • Living Area • Fireplace', image: 'assets/room3.png', description: 'A spacious suite with two bedrooms, a comfortable living area, and a cozy fireplace, ideal for families.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.family_restroom, label: 'Family Room'), Amenity(icon: Icons.fireplace, label: 'Fireplace'), Amenity(icon: Icons.kitchen, label: 'Kitchenette')]),
      Room(name: 'Deluxe Balcony Room', price: 3800, type: 'Deluxe', capacity: 2, features: 'King Bed • Large Balcony • Mountain Breeze', image: 'assets/room4.png', description: 'A deluxe room with a king-size bed and a large balcony to enjoy the refreshing mountain breeze.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.balcony, label: 'Balcony'), Amenity(icon: Icons.wind_power, label: 'Fresh Air')]),
      Room(name: 'Budget Twin Room', price: 2200, type: 'Budget', capacity: 2, features: '2 Single Beds • Shared Bathroom', image: 'assets/room5.png', description: 'An economical twin room with two single beds and access to a shared bathroom.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.single_bed, label: 'Twin Beds')]),
      Room(name: 'Pet-Friendly Cottage', price: 3500, type: 'Cottage', capacity: 3, features: 'Private Entrance • Pet Amenities • Enclosed Yard', image: 'assets/room6.png', description: 'A charming cottage with a private entrance and enclosed yard, perfect for guests traveling with pets.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Wi'), Amenity(icon: Icons.pets, label: 'Pet-friendly'), Amenity(icon: Icons.local_florist, label: 'Private Yard')]),
      Room(name: 'Honeymoon Suite', price: 5500, type: 'Suite', capacity: 2, features: 'Romantic Decor • Jacuzzi • Special Amenities', image: 'assets/room7.png', description: 'A beautifully decorated suite designed for honeymooners, featuring a jacuzzi and special amenities.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.hot_tub, label: 'Jacuzzi'), Amenity(icon: Icons.wine_bar, label: 'Wine Service'), Amenity(icon: Icons.fireplace, label: 'Fireplace')]),
      Room(name: 'Artist\'s Retreat', price: 3000, type: 'Unique', capacity: 1, features: 'Inspiring Views • Easel & Supplies • Quiet Space', image: 'assets/room8.png', description: 'A unique room offering inspiring views and a quiet space, equipped with an easel and art supplies.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.brush, label: 'Art Supplies'), Amenity(icon: Icons.palette, label: 'Creative Space')]),
      Room(name: 'Executive Lodge Room', price: 4800, type: 'Deluxe', capacity: 2, features: 'Luxury Furnishings • Lounge Access • Mountain View', image: 'assets/room9.png', description: 'A luxurious lodge room with high-end furnishings, lounge access, and beautiful mountain views.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.business_center, label: 'Lounge Access'), Amenity(icon: Icons.nature, label: 'Mountain View')]),
      Room(name: 'Dormitory Bed', price: 1500, type: 'Budget', capacity: 1, features: 'Bunk Bed • Shared Facilities • Locker', image: 'assets/room10.png', description: 'An economical bunk bed in a dormitory setting, with shared facilities and a personal locker.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.lock, label: 'Locker')]),
       ],
    'Davao Nature Park Hotel': [
    Room(name: 'Nature View Room', price: 3500, type: 'Standard', capacity: 2, features: 'Queen Bed • Park View • Balcony', image: 'assets/room1.png', description: 'A comfortable room with a queen-size bed, offering serene park views from its private balcony.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.nature, label: 'Park View'), Amenity(icon: Icons.balcony, label: 'Balcony'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Family Eco Suite', price: 4000, type: 'Suite', capacity: 4, features: '2 Bedrooms • Eco-friendly Design • Garden Access', image: 'assets/room2.png', description: 'An eco-friendly suite with two bedrooms and direct garden access, perfect for families.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.eco, label: 'Eco-friendly'), Amenity(icon: Icons.family_restroom, label: 'Family Room'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Adventure Lodge Room', price: 3800, type: 'Deluxe', capacity: 2, features: 'King Bed • Near Adventure Park • Gear Storage', image: 'assets/room3.png', description: 'A deluxe room conveniently located near the adventure park, with dedicated gear storage.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.hiking, label: 'Adventure Access'), Amenity(icon: Icons.storage, label: 'Gear Storage'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Standard Twin Room', price: 2800, type: 'Standard', capacity: 2, features: '2 Single Beds • Basic Amenities', image: 'assets/room4.png', description: 'A standard room with two single beds and essential amenities for a comfortable stay.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.tv, label: 'TV'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Cultural Immersion Room', price: 3000, type: 'Unique', capacity: 2, features: 'Local Art Decor • Cultural Books', image: 'assets/room5.png', description: 'A uniquely decorated room featuring local art and cultural books for an immersive experience.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.museum, label: 'Cultural Decor'), Amenity(icon: Icons.book, label: 'Local Books'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Budget Room', price: 1500, type: 'Budget', capacity: 1, features: 'Single Bed • Shared Bathroom', image: 'assets/room6.png', description: 'An economical single room with basic amenities and access to a shared bathroom.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.single_bed, label: 'Single Bed'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Deluxe Pool Access', price: 3200, type: 'Deluxe', capacity: 2, features: 'Direct Pool Access • King Bed', image: 'assets/room7.png', description: 'A deluxe room with a king-size bed and direct access to the hotel\'s swimming pool.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.pool, label: 'Pool Access'), Amenity(icon: Icons.balcony, label: 'Terrace'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Executive Suite', price: 3900, type: 'Suite', capacity: 3, features: 'Separate Living Area • City View', image: 'assets/room8.png', description: 'A spacious executive suite with a separate living area and views of the city.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.living_outlined, label: 'Living Area'), Amenity(icon: Icons.balcony, label: 'City View'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Treehouse Glamping', price: 2500, type: 'Glamping', capacity: 2, features: 'Elevated Tent • Outdoor Seating • Forest Sounds', image: 'assets/room9.png', description: 'Experience glamping in an elevated tent, surrounded by forest sounds and outdoor seating.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.nature, label: 'Forest Immersion'), Amenity(icon: Icons.chair, label: 'Outdoor Seating'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Honeymoon Villa', price: 3700, type: 'Villa', capacity: 2, features: 'Secluded Villa • Private Garden • Romantic Setup', image: 'assets/room10.png', description: 'A secluded villa with a private garden, designed for a romantic and intimate honeymoon.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.local_florist, label: 'Private Garden'), Amenity(icon: Icons.wine_bar, label: 'Wine Service'), Amenity(icon: Icons.ac_unit, label: 'AC')]),],
    'Iloilo Heritage Inn': [
    Room(name: 'Heritage Deluxe Room', price: 2800, type: 'Deluxe', capacity: 2, features: 'Queen Bed • Colonial Decor • City View', image: 'assets/room1.png', description: 'A deluxe room with charming colonial decor and views of the city.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.museum, label: 'Historical Decor'), Amenity(icon: Icons.tv, label: 'TV'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Standard Twin Room', price: 1800, type: 'Standard', capacity: 2, features: '2 Single Beds • Basic Amenities', image: 'assets/room2.png', description: 'A comfortable standard room with two single beds and essential amenities.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.single_bed, label: 'Twin Beds'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Family Connecting Room', price: 2900, type: 'Family', capacity: 4, features: '2 Connecting Rooms • Shared Bathroom', image: 'assets/room3.png', description: 'Two connecting rooms with a shared bathroom, ideal for families traveling together.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.family_restroom, label: 'Family Room'), Amenity(icon: Icons.tv, label: 'TV'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Culinary Suite', price: 2500, type: 'Suite', capacity: 2, features: 'Kitchenette • Dining Area • Local Cookbook', image: 'assets/room4.png', description: 'A suite designed for food enthusiasts, featuring a kitchenette, dining area, and local cookbooks.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.kitchen, label: 'Kitchenette'), Amenity(icon: Icons.restaurant_menu, label: 'Local Cuisine'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Budget Single', price: 1000, type: 'Budget', capacity: 1, features: 'Single Bed • Shared Bathroom', image: 'assets/room5.png', description: 'An economical single room with basic amenities and access to a shared bathroom.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.single_bed, label: 'Single Bed'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Executive Suite', price: 2700, type: 'Suite', capacity: 3, features: 'Separate Living Area • Work Desk', image: 'assets/room6.png', description: 'A spacious executive suite with a separate living area and a dedicated work desk.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.living_outlined, label: 'Living Area'), Amenity(icon: Icons.desk, label: 'Work Desk'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Art Deco Room', price: 2600, type: 'Unique', capacity: 2, features: 'Vintage Decor • City Landmark View', image: 'assets/room7.png', description: 'A uniquely designed room with vintage art deco decor and views of city landmarks.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.architecture, label: 'Art Deco'), Amenity(icon: Icons.location_city, label: 'Landmark View'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Accessible Room', price: 2500, type: 'Standard', capacity: 2, features: 'Wheelchair Accessible • Grab Bars', image: 'assets/room8.png', description: 'A comfortable and accessible room with features designed for guests with mobility needs.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.accessible_forward, label: 'Accessible'), Amenity(icon: Icons.bathtub, label: 'Grab Bars'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Balcony Room', price: 2400, type: 'Deluxe', capacity: 2, features: 'Queen Bed • Private Balcony • Street View', image: 'assets/room9.png', description: 'A deluxe room with a queen-size bed and a private balcony offering street views.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.balcony, label: 'Balcony'), Amenity(icon: Icons.streetview, label: 'Street View'), Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(name: 'Long Stay Apartment', price: 2300, type: 'Apartment', capacity: 2, features: 'Full Kitchen • Laundry Facilities • Spacious', image: 'assets/room10.png', description: 'A spacious apartment with a full kitchen and laundry facilities, ideal for extended stays.', amenities: [Amenity(icon: Icons.wifi, label: 'Wi-Fi'), Amenity(icon: Icons.kitchen, label: 'Full Kitchen'), Amenity(icon: Icons.local_laundry_service, label: 'Laundry'), Amenity(icon: Icons.ac_unit, label: 'AC')]), ],
  };

  @override
  void initState() {
    super.initState();
    // Initialize allRooms based on the current hotelName
    allRooms = _hotelRoomsData[widget.hotelName] ?? [];
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
        const Text('Filter Rooms', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kDarkBlue)),
        const SizedBox(height: 16),

        Row(
          children: [
            const Text('Min Price:', style: TextStyle(color: kDarkBlue)),
            const SizedBox(width: 10),
            DropdownButton<int>(
              value: selectedMinPrice,
              items: [0, 1000, 2000, 3000, 5000, 7000, 10000].map((v) => DropdownMenuItem(value: v, child: Text('₱$v'))).toList(),
              onChanged: (value) => setState(() => selectedMinPrice = value),
              dropdownColor: kLightBlue, // Light blue dropdown background
              style: const TextStyle(color: kDarkBlue), // Dark blue text
            ),
            const Spacer(),
            const Text('Max Price:', style: TextStyle(color: kDarkBlue)),
            const SizedBox(width: 10),
            DropdownButton<int>(
              value: selectedMaxPrice,
              items: [2000, 3000, 5000, 7000, 10000, 15000, 20000].map((v) => DropdownMenuItem(value: v, child: Text('₱$v'))).toList(),
              onChanged: (value) => setState(() => selectedMaxPrice = value),
              dropdownColor: kLightBlue, // Light blue dropdown background
              style: const TextStyle(color: kDarkBlue), // Dark blue text
            ),
          ],
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            const Text('Capacity:', style: TextStyle(color: kDarkBlue)),
            const SizedBox(width: 10),
            DropdownButton<int>(
              value: selectedCapacity,
              hint: const Text('Any', style: TextStyle(color: kDarkBlue)),
              items: [1, 2, 3, 4, 5].map((v) => DropdownMenuItem(value: v, child: Text('$v pax'))).toList(),
              onChanged: (value) => setState(() => selectedCapacity = value),
              dropdownColor: kLightBlue, // Light blue dropdown background
              style: const TextStyle(color: kDarkBlue), // Dark blue text
            ),
          ],
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            const Text('Room Type:', style: TextStyle(color: kDarkBlue)),
            const SizedBox(width: 10),
            DropdownButton<String>(
              value: selectedType,
              items: ['All', 'Standard', 'Deluxe', 'Suite', 'Villa', 'Cabin', 'Bungalow', 'Casita', 'House', 'Eco-friendly', 'Glamping', 'Apartment', 'Unique', 'Wellness', 'Cottage']
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (value) => setState(() => selectedType = value!),
              dropdownColor: kLightBlue, // Light blue dropdown background
              style: const TextStyle(color: kDarkBlue), // Dark blue text
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            _filter(_searchController.text);
          },
          icon: const Icon(Icons.check, color: kWhite), // White icon
          label: const Text('Apply Filters', style: TextStyle(color: kWhite)), // White text
          style: ElevatedButton.styleFrom(backgroundColor: kPrimaryBlue), // Primary blue button
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite, // Changed to kWhite
      appBar: AppBar(
        title: Text(
          '${widget.hotelName} Rooms',
          style: const TextStyle(
            color: kWhite, // Changed to kWhite
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kPrimaryBlue, // Changed to kPrimaryBlue
        iconTheme: const IconThemeData(color: kWhite), // Changed to kWhite
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search Field wrapped in a Container for shadow and consistent styling
          Container(
            decoration: BoxDecoration(
              color: kWhite, // White background for the search field container
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _filter,
              decoration: InputDecoration(
                hintText: 'Search rooms...',
                prefixIcon: const Icon(Icons.search, color: kDarkBlue), // Dark blue search icon
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_list, color: kDarkBlue), // Dark blue filter icon
                  onPressed: _openFilterDialog,
                ),
                filled: true,
                fillColor: kWhite, // Ensure TextField's internal fill is white
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                border: InputBorder.none, // No internal border for TextField
                enabledBorder: OutlineInputBorder( // Re-added enabled border for consistency
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300), // Subtle grey border
                ),
                focusedBorder: OutlineInputBorder( // Re-added blue border on focus
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: kPrimaryBlue, width: 2), // Highlight when focused, using primary blue
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (filteredRooms.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'No rooms found matching your criteria.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          else
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
      color: kWhite, // Changed to kWhite
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
                Text(room.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kDarkBlue)), // Changed to kDarkBlue
                const SizedBox(height: 6),
                Text(room.features, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: room.amenities.take(5).map((a) => _AmenityIcon(icon: a.icon, label: a.label)).toList(),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₱${room.price} / night', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kPrimaryBlue)), // Changed to kPrimaryBlue
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
                      style: ElevatedButton.styleFrom(backgroundColor: kPrimaryBlue, foregroundColor: kWhite), // Changed to kPrimaryBlue and kWhite
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
        Icon(icon, size: 24, color: kDarkBlue), // Changed to kDarkBlue
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: kDarkBlue)), // Changed to kDarkBlue
      ],
    );
  }
}
