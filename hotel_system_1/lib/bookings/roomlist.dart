import 'package:flutter/material.dart';
import 'bookingform.dart'; // Hide Amenity from bookingform.dart to resolve ambiguity
import '../utils/constants.dart';
import '../models/room.dart'; // Import the Room model
import '../models/amenity.dart'; // Import Amenity model (this is the canonical one)
import '../screens/room_manager.dart'; // Import the RoomManager
import '../screens/hotel_manager.dart'; // Import HotelManager
import 'package:collection/collection.dart'; // For firstWhereOrNull

// Add this extension at the top (after imports) if not already present
extension ColorWithValues on Color {
  Color withValues({double? alpha}) {
    if (alpha != null) {
      return withAlpha((255 * alpha).round());
    }
    return this;
  }
}

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

  // Map of hotel names to their respective static room lists
  // This static data will be merged with dynamic data from RoomManager
  final Map<String, List<Room>> _hotelRoomsData = {
    'Seaside Resort Boracay': [
      Room(hotelName: 'Seaside Resort Boracay', name: 'Deluxe Ocean View', pricePerNight: 7500, type: 'Deluxe', capacity: 2, features: '1 King Bed • Private Balcony • Ocean View', imagePath: 'assets/room1.png', description: 'Experience luxury in our spacious Deluxe Room, featuring a comfortable king-size bed and stunning ocean views...', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Fi'), const Amenity(icon: Icons.hot_tub, label: 'Jacuzzi'), const Amenity(icon: Icons.balcony, label: 'Balcony'), const Amenity(icon: Icons.beach_access, label: 'Beach Access'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Seaside Resort Boracay', name: 'Standard Garden View', pricePerNight: 3500, type: 'Standard', capacity: 2, features: '1 Queen Bed • Garden View • Free Wi-Fi', imagePath: 'assets/room2.png', description: 'Our Standard Room offers a cozy retreat with a queen-size bed and picturesque garden views...', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Fi'), const Amenity(icon: Icons.single_bed, label: 'Queen Bed'), const Amenity(icon: Icons.tv, label: 'TV'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Seaside Resort Boracay', name: 'Family Suite', pricePerNight: 6500, type: 'Suite', capacity: 4, features: '2 Bedrooms • Living Area • Pool Access', imagePath: 'assets/room3.png', description: 'Indulge in the expansive Family Suite, offering two distinct rooms and exclusive pool access...', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Fi'), const Amenity(icon: Icons.pool, label: 'Pool Access'), const Amenity(icon: Icons.kitchen, label: 'Kitchenette'), const Amenity(icon: Icons.family_restroom, label: 'Family Room'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Seaside Resort Boracay', name: 'Executive Suite Oceanfront', pricePerNight: 7800, type: 'Suite', capacity: 3, features: '1 King Bed • Executive Lounge • Oceanfront Balcony', imagePath: 'assets/room4.png', description: 'The ultimate luxury with direct oceanfront views and access to exclusive executive lounge.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Fi'), const Amenity(icon: Icons.hot_tub, label: 'Jacuzzi'), const Amenity(icon: Icons.local_bar, label: 'Mini Bar'), const Amenity(icon: Icons.balcony, label: 'Balcony'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Seaside Resort Boracay', name: 'Superior Room', pricePerNight: 4000, type: 'Standard', capacity: 2, features: '1 King Bed • City View • Work Desk', imagePath: 'assets/room5.png', description: 'A comfortable and functional room with a king-size bed and a dedicated work desk.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.desk, label: 'Work Desk'), const Amenity(icon: Icons.tv, label: 'TV'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Seaside Resort Boracay', name: 'Honeymoon Villa', pricePerNight: 8000, type: 'Villa', capacity: 2, features: 'Private Pool • Secluded Garden • Romantic Setup', imagePath: 'assets/room6.png', description: 'A private villa designed for romance, featuring your own pool and secluded garden.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.pool, label: 'Private Pool'), const Amenity(icon: Icons.spa, label: 'Spa'), const Amenity(icon: Icons.wine_bar, label: 'Wine Bar'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Seaside Resort Boracay', name: 'Budget Room', pricePerNight: 3000, type: 'Budget', capacity: 1, features: '1 Single Bed • Basic Amenities', imagePath: 'assets/room7.png', description: 'A simple and affordable room with essential amenities for a comfortable stay.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.single_bed, label: 'Queen Bed'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Seaside Resort Boracay', name: 'Connecting Rooms', pricePerNight: 6000, type: 'Family', capacity: 5, features: '2 Connecting Rooms • Shared Bathroom', imagePath: 'assets/room8.png', description: 'Ideal for families, offering two connecting rooms for ample space and privacy.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.family_restroom, label: 'Family Room'), const Amenity(icon: Icons.tv, label: 'TV'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Seaside Resort Boracay', name: 'Presidential Suite', pricePerNight: 7900, type: 'Suite', capacity: 4, features: 'Luxury Furnishings • Personal Butler • Panoramic Views', imagePath: 'assets/room9.png', description: 'The pinnacle of luxury with panoramic views, exquisite furnishings, and personalized butler service.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.hot_tub, label: 'Jacuzzi'), const Amenity(icon: Icons.local_bar, label: 'Mini Bar'), const Amenity(icon: Icons.room_service, label: 'Room Service'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Seaside Resort Boracay', name: 'Studio Apartment', pricePerNight: 4500, type: 'Apartment', capacity: 2, features: 'Kitchenette • Living Area • City View', imagePath: 'assets/room10.png', description: 'A compact and modern studio apartment with a well-equipped kitchenette and city views.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.kitchen, label: 'Kitchenette'), const Amenity(icon: Icons.tv, label: 'TV'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
    ],
    'Malvar Mountain Retreat': [
      Room(hotelName: 'Malvar Mountain Retreat', name: 'Mountain View Cabin', pricePerNight: 4500, type: 'Cabin', capacity: 2, features: '1 Queen Bed • Mountain View Balcony • Fireplace', imagePath: 'assets/room1.png', description: 'A cozy cabin with stunning mountain views, a private balcony, and a warm fireplace.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.fireplace, label: 'Fireplace'), const Amenity(icon: Icons.balcony, label: 'Balcony'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Malvar Mountain Retreat', name: 'Forest Suite', pricePerNight: 5000, type: 'Suite', capacity: 3, features: '1 King Bed • Forest View • Jacuzzi', imagePath: 'assets/room2.png', description: 'Spacious suite with lush forest views and a relaxing in-room jacuzzi.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.hot_tub, label: 'Jacuzzi'), const Amenity(icon: Icons.local_bar, label: 'Mini Bar'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Malvar Mountain Retreat', name: 'Standard Room', pricePerNight: 2500, type: 'Standard', capacity: 2, features: '1 Double Bed • Garden Access', imagePath: 'assets/room3.png', description: 'A comfortable standard room with direct access to the beautiful garden.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.local_florist, label: 'Garden'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Malvar Mountain Retreat', name: 'Family Lodge', pricePerNight: 4800, type: 'Lodge', capacity: 5, features: '2 Bedrooms • Kitchenette • Dining Area', imagePath: 'assets/room4.png', description: 'A spacious lodge perfect for families, complete with a kitchenette and dining area.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.kitchen, label: 'Kitchenette'), const Amenity(icon: Icons.family_restroom, label: 'Family Room'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Malvar Mountain Retreat', name: 'Deluxe View Room', pricePerNight: 3800, type: 'Deluxe', capacity: 2, features: '1 King Bed • Panoramic Window View', imagePath: 'assets/room5.png', description: 'Enjoy breathtaking panoramic views from this deluxe room with a king-size bed.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.tv, label: 'Smart TV'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Malvar Mountain Retreat', name: 'Hiker\'s Den', pricePerNight: 2000, type: 'Budget', capacity: 1, features: '1 Single Bed • Basic Amenities • Near Trailhead', imagePath: 'assets/room6.png', description: 'A simple and convenient room for hikers, located near the main trailheads.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.hiking, label: 'Hiking Access'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Malvar Mountain Retreat', name: 'Executive Cabin', pricePerNight: 3500, type: 'Cabin', capacity: 2, features: 'Luxury Furnishings • Private Deck • BBQ Grill', imagePath: 'assets/room7.png', description: 'An executive cabin with luxury furnishings, a private deck, and a BBQ grill for outdoor dining.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.deck, label: 'Private Deck'), const Amenity(icon: Icons.outdoor_grill, label: 'BBQ'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Malvar Mountain Retreat', name: 'Glamping Tent', pricePerNight: 3000, type: 'Glamping', capacity: 2, features: 'Luxury Tent • Outdoor Seating • Shared Bathroom', imagePath: 'assets/room8.png', description: 'Experience glamping in a luxurious tent with comfortable outdoor seating.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.chair, label: 'Outdoor Seating'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Malvar Mountain Retreat', name: 'Summit Suite', pricePerNight: 4900, type: 'Suite', capacity: 4, features: 'Top Floor • Best Views • Private Dining Area', imagePath: 'assets/room9.png', description: 'Located on the top floor, this suite offers the best views and a private dining area.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.restaurant, label: 'Dining Area'), const Amenity(icon: Icons.balcony, label: 'Balcony'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Malvar Mountain Retreat', name: 'Cozy Nook', pricePerNight: 2200, type: 'Standard', capacity: 1, features: '1 Single Bed • Quiet Corner • Reading Lamp', imagePath: 'assets/room10.png', description: 'A small, cozy room perfect for a solo traveler looking for a quiet space to relax and read.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.book, label: 'Reading Nook'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
    ],
    'El Nido Island Paradise': [
      Room(hotelName: 'El Nido Island Paradise', name: 'Beachfront Villa', pricePerNight: 14000, type: 'Villa', capacity: 2, features: 'Private Beach Access • King Bed • Outdoor Shower', imagePath: 'assets/room1.png', description: 'Luxurious villa with direct private beach access and an invigorating outdoor shower.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.beach_access, label: 'Private Beach'), const Amenity(icon: Icons.shower, label: 'Outdoor Shower'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'El Nido Island Paradise', name: 'Overwater Bungalow', pricePerNight: 15000, type: 'Bungalow', capacity: 2, features: 'Glass Floor • Direct Ocean Access • Sundeck', imagePath: 'assets/room2.png', description: 'Experience unique luxury in a bungalow built over the water with a glass floor and direct ocean access.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.water, label: 'Ocean Access'), const Amenity(icon: Icons.balcony, label: 'Sundeck'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'El Nido Island Paradise', name: 'Garden Casita', pricePerNight: 8000, type: 'Casita', capacity: 2, features: 'Secluded Garden • Queen Bed • Hammock', imagePath: 'assets/room3.png', description: 'A charming, secluded casita surrounded by a lush garden, perfect for relaxation with a hammock.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.local_florist, label: 'Garden'), const Amenity(icon: Icons.self_improvement, label: 'Hammock'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'El Nido Island Paradise', name: 'Family Beach House', pricePerNight: 12000, type: 'House', capacity: 5, features: '3 Bedrooms • Full Kitchen • Private Dining', imagePath: 'assets/room4.png', description: 'A spacious beach house with multiple bedrooms, a full kitchen, and private dining area, ideal for large families.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.kitchen, label: 'Full Kitchen'), const Amenity(icon: Icons.family_restroom, label: 'Family Room'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'El Nido Island Paradise', name: 'Cliffside Suite', pricePerNight: 10000, type: 'Suite', capacity: 2, features: 'Panoramic Ocean Views • Infinity Pool Access', imagePath: 'assets/room5.png', description: 'Perched on a cliff with panoramic ocean views and access to a stunning infinity pool.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.pool, label: 'Infinity Pool'), const Amenity(icon: Icons.balcony, label: 'Balcony'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'El Nido Island Paradise', name: 'Eco-Lodge Room', pricePerNight: 7000, type: 'Eco-friendly', capacity: 2, features: 'Sustainable Design • Nature Immersion', imagePath: 'assets/room6.png', description: 'An eco-friendly room designed for nature immersion, featuring sustainable materials and practices.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.eco, label: 'Eco-friendly'), const Amenity(icon: Icons.nature, label: 'Nature Views'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'El Nido Island Paradise', name: 'Diver\'s Den', pricePerNight: 9000, type: 'Standard', capacity: 2, features: 'Near Dive Center • Gear Storage', imagePath: 'assets/room7.png', description: 'Conveniently located near the dive center with dedicated storage for your diving gear.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.scuba_diving, label: 'Dive Center Access'), const Amenity(icon: Icons.storage, label: 'Gear Storage'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'El Nido Island Paradise', name: 'Sunset View Room', pricePerNight: 11000, type: 'Deluxe', capacity: 2, features: 'Best Sunset Spot • Private Terrace', imagePath: 'assets/room8.png', description: 'Enjoy the most spectacular sunsets from your private terrace in this deluxe room.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.balcony, label: 'Private Terrace'), const Amenity(icon: Icons.wb_sunny, label: 'Sunset View'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'El Nido Island Paradise', name: 'Island Hopper Suite', pricePerNight: 7500, type: 'Suite', capacity: 3, features: 'Complimentary Island Tour • Spacious Living', imagePath: 'assets/room9.png', description: 'A spacious suite that includes a complimentary island hopping tour for an unforgettable experience.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.directions_boat, label: 'Island Tour'), const Amenity(icon: Icons.room_service, label: 'Room Service'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'El Nido Island Paradise', name: 'Budget Room', pricePerNight: 6000, type: 'Budget', capacity: 1, features: 'Basic Amenities • Shared Bathroom', imagePath: 'assets/room10.png', description: 'An affordable room with basic amenities, perfect for solo travelers on a budget.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.single_bed, label: 'Single Bed'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
    ],
    'Cebu City Business Hotel': [
      Room(hotelName: 'Cebu City Business Hotel', name: 'Executive Business Room', pricePerNight: 4000, type: 'Deluxe', capacity: 1, features: 'King Bed • Executive Desk • City View', imagePath: 'assets/room1.png', description: 'Designed for business travelers, featuring an executive desk and city views.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.desk, label: 'Work Desk'), const Amenity(icon: Icons.business_center, label: 'Business Center'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Cebu City Business Hotel', name: 'Standard City View', pricePerNight: 2000, type: 'Standard', capacity: 2, features: 'Queen Bed • Basic Amenities', imagePath: 'assets/room2.png', description: 'A comfortable standard room with a queen-size bed and city views.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.tv, label: 'TV'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Cebu City Business Hotel', name: 'Conference Suite', pricePerNight: 4500, type: 'Suite', capacity: 4, features: 'Small Meeting Area • Projector • Whiteboard', imagePath: 'assets/room3.png', description: 'A versatile suite with a dedicated small meeting area, perfect for business discussions.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.meeting_room, label: 'Meeting Area'), const Amenity(icon: Icons.tv, label: 'Projector'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Cebu City Business Hotel', name: 'Deluxe Twin Room', pricePerNight: 3000, type: 'Deluxe', capacity: 2, features: '2 Single Beds • City View', imagePath: 'assets/room4.png', description: 'A deluxe room with two single beds and views of the bustling city.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.single_bed, label: 'Twin Beds'), const Amenity(icon: Icons.tv, label: 'TV'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Cebu City Business Hotel', name: 'Junior Suite', pricePerNight: 3800, type: 'Suite', capacity: 3, features: 'Separate Living Area • King Bed', imagePath: 'assets/room5.png', description: 'A spacious junior suite with a separate living area and a comfortable king-size bed.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.living_outlined, label: 'Living Area'), const Amenity(icon: Icons.local_bar, label: 'Mini Bar'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Cebu City Business Hotel', name: 'Budget Single Room', pricePerNight: 1800, type: 'Budget', capacity: 1, features: '1 Single Bed • Shared Bathroom', imagePath: 'assets/room6.png', description: 'An economical single room with essential amenities and access to a shared bathroom.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.single_bed, label: 'Single Bed'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Cebu City Business Hotel', name: 'Fitness Room', pricePerNight: 3500, type: 'Standard', capacity: 1, features: 'Exercise Bike • Yoga Mat • Healthy Snacks', imagePath: 'assets/room7.png', description: 'Stay active in this room equipped with an exercise bike, yoga mat, and healthy snacks.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.fitness_center, label: 'Fitness Gear'), const Amenity(icon: Icons.local_dining, label: 'Healthy Snacks'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Cebu City Business Hotel', name: 'Accessible Room', pricePerNight: 2800, type: 'Standard', capacity: 2, features: 'Wheelchair Accessible • Grab Bars', imagePath: 'assets/room8.png', description: 'A thoughtfully designed accessible room with features for comfortable stay.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.accessible_forward, label: 'Accessible'), const Amenity(icon: Icons.bathtub, label: 'Grab Bars'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Cebu City Business Hotel', name: 'Family Connecting Room', pricePerNight: 4200, type: 'Family', capacity: 4, features: '2 Connecting Rooms • Shared Lounge', imagePath: 'assets/room9.png', description: 'Two connecting rooms perfect for families, offering ample space and a shared lounge area.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.family_restroom, label: 'Family Room'), const Amenity(icon: Icons.tv, label: 'TV'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Cebu City Business Hotel', name: 'Penthouse Suite', pricePerNight: 4400, type: 'Suite', capacity: 4, features: 'Top Floor • Panoramic City View • Private Bar', imagePath: 'assets/room10.png', description: 'The luxurious penthouse suite on the top floor, offering panoramic city views and a private bar.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.local_bar, label: 'Private Bar'), const Amenity(icon: Icons.balcony, label: 'Panoramic View'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
    ],
    'Tagaytay Lakeview Suites': [
      Room(hotelName: 'Tagaytay Lakeview Suites', name: 'Lakeview Deluxe', pricePerNight: 6000, type: 'Deluxe', capacity: 2, features: 'King Bed • Taal Lake View • Balcony', imagePath: 'assets/room1.png', description: 'A deluxe room offering stunning views of Taal Lake from your private balcony.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.water, label: 'Lake View'), const Amenity(icon: Icons.balcony, label: 'Balcony'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Tagaytay Lakeview Suites', name: 'Garden Suite', pricePerNight: 5500, type: 'Suite', capacity: 3, features: 'Queen Bed • Private Garden • Outdoor Seating', imagePath: 'assets/room2.png', description: 'A serene suite with a private garden and comfortable outdoor seating area.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.local_florist, label: 'Garden'), const Amenity(icon: Icons.chair, label: 'Outdoor Seating'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Tagaytay Lakeview Suites', name: 'Standard Room', pricePerNight: 2800, type: 'Standard', capacity: 2, features: 'Double Bed • Basic Amenities', imagePath: 'assets/room3.png', description: 'A comfortable standard room with essential amenities for a pleasant stay.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.tv, label: 'TV'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Tagaytay Lakeview Suites', name: 'Family Villa', pricePerNight: 6800, type: 'Villa', capacity: 5, features: '3 Bedrooms • Kitchen • Lake Access', imagePath: 'assets/room4.png', description: 'A spacious villa with multiple bedrooms and a kitchen, offering convenient lake access.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.kitchen, label: 'Kitchen'), const Amenity(icon: Icons.family_restroom, label: 'Family Room'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Tagaytay Lakeview Suites', name: 'Romantic Casita', pricePerNight: 7000, type: 'Casita', capacity: 2, features: 'Secluded • Jacuzzi • Candlelight Setup', imagePath: 'assets/room5.png', description: 'A secluded casita designed for a romantic getaway, complete with a jacuzzi and special setup.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.hot_tub, label: 'Jacuzzi'), const Amenity(icon: Icons.wine_bar, label: 'Wine Service'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Tagaytay Lakeview Suites', name: 'Budget Room', pricePerNight: 2500, type: 'Budget', capacity: 1, features: 'Single Bed • Shared Bathroom', imagePath: 'assets/room6.png', description: 'An affordable room with basic amenities, suitable for solo travelers on a budget.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.single_bed, label: 'Single Bed'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Tagaytay Lakeview Suites', name: 'Executive Suite', pricePerNight: 6200, type: 'Suite', capacity: 4, features: 'Separate Living Room • Dining Area • Lake View', imagePath: 'assets/room7.png', description: 'A luxurious executive suite with separate living and dining areas, offering stunning lake views.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.restaurant, label: 'Dining Area'), const Amenity(icon: Icons.balcony, label: 'Lake View'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Tagaytay Lakeview Suites', name: 'Spa Retreat Room', pricePerNight: 6500, type: 'Deluxe', capacity: 2, features: 'Complimentary Spa Session • Aromatherapy Diffuser', imagePath: 'assets/room8.png', description: 'A deluxe room focused on wellness, including a complimentary spa session and aromatherapy.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.spa, label: 'Spa Access'), const Amenity(icon: Icons.self_improvement, label: 'Aromatherapy'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Tagaytay Lakeview Suites', name: 'Artist\'s Loft', pricePerNight: 3000, type: 'Unique', capacity: 2, features: 'Creative Decor • Art Supplies • Inspiring Views', imagePath: 'assets/room9.png', description: 'A uniquely designed loft with creative decor, art supplies, and inspiring views for artists.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.brush, label: 'Art Supplies'), const Amenity(icon: Icons.palette, label: 'Creative Space'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Tagaytay Lakeview Suites', name: 'Pet-Friendly Room', pricePerNight: 3500, type: 'Standard', capacity: 2, features: 'Pet Amenities • Garden Access', imagePath: 'assets/room10.png', description: 'A comfortable room that welcomes your furry friends, with dedicated pet amenities and garden access.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.pets, label: 'Pet-friendly'), const Amenity(icon: Icons.local_florist, label: 'Garden'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
    ],
    'Siargao Surfer\'s Haven': [
      Room(hotelName: 'Siargao Surfer\'s Haven', name: 'Surf Shack', pricePerNight: 2500, type: 'Budget', capacity: 1, features: 'Single Bed • Fan • Surfboard Rack', imagePath: 'assets/room1.png', description: 'A basic surf shack ideal for solo surfers, equipped with a fan and surfboard rack.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.surfing, label: 'Surfboard Rack'), const Amenity(icon: Icons.shower, label: 'Outdoor Shower')]),
      Room(hotelName: 'Siargao Surfer\'s Haven', name: 'Beach Bungalow', pricePerNight: 3500, type: 'Standard', capacity: 2, features: 'Queen Bed • Beach Access • Hammock', imagePath: 'assets/room2.png', description: 'A charming bungalow with direct beach access and a relaxing hammock.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.beach_access, label: 'Beach Access'), const Amenity(icon: Icons.self_improvement, label: 'Hammock')]),
      Room(hotelName: 'Siargao Surfer\'s Haven', name: 'Family Villa', pricePerNight: 3000, type: 'Villa', capacity: 4, features: '2 Bedrooms • Kitchenette • Patio', imagePath: 'assets/room3.png', description: 'A spacious villa with two bedrooms, a kitchenette, and a private patio, great for families.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.kitchen, label: 'Kitchenette'), const Amenity(icon: Icons.family_restroom, label: 'Family Room')]),
      Room(hotelName: 'Siargao Surfer\'s Haven', name: 'Deluxe Ocean View', pricePerNight: 3200, type: 'Deluxe', capacity: 2, features: 'King Bed • Ocean View Balcony', imagePath: 'assets/room4.png', description: 'Enjoy stunning ocean views from the private balcony of this deluxe room.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.balcony, label: 'Balcony'), const Amenity(icon: Icons.water, label: 'Ocean View')]),
      Room(hotelName: 'Siargao Surfer\'s Haven', name: 'Dorm Bed', pricePerNight: 1200, type: 'Budget', capacity: 1, features: 'Bunk Bed • Shared Bathroom • Locker', imagePath: 'assets/room5.png', description: 'An economical bunk bed in a shared dormitory, with a personal locker for your belongings.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.lock, label: 'Locker')]),
      Room(hotelName: 'Siargao Surfer\'s Haven', name: 'Treehouse Room', pricePerNight: 3400, type: 'Unique', capacity: 2, features: 'Elevated Room • Forest Canopy View', imagePath: 'assets/room6.png', description: 'A unique elevated room offering immersive views of the forest canopy.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.nature, label: 'Forest View'), const Amenity(icon: Icons.eco, label: 'Eco-friendly')]),
      Room(hotelName: 'Siargao Surfer\'s Haven', name: 'Surfer\'s Suite', pricePerNight: 3300, type: 'Suite', capacity: 3, features: 'Spacious • Private Gear Drying Area • Lounge', imagePath: 'assets/room7.png', description: 'A spacious suite designed for surfers, featuring a private gear drying area and a comfortable lounge.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.surfing, label: 'Surf Gear Area'), const Amenity(icon: Icons.chair, label: 'Lounge')]),
      Room(hotelName: 'Siargao Surfer\'s Haven', name: 'Garden View Room', pricePerNight: 2800, type: 'Standard', capacity: 2, features: 'Queen Bed • Lush Garden View', imagePath: 'assets/room8.png', description: 'A comfortable room with a queen-size bed and views of the lush garden.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.local_florist, label: 'Garden View')]),
      Room(hotelName: 'Siargao Surfer\'s Haven', name: 'Private Cottage', pricePerNight: 2900, type: 'Cottage', capacity: 2, features: 'Secluded • Outdoor Seating • Basic Kitchen', imagePath: 'assets/room9.png', description: 'A secluded private cottage with outdoor seating and a basic kitchen for your convenience.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.kitchen, label: 'Basic Kitchen'), const Amenity(icon: Icons.chair, label: 'Outdoor Seating')]),
      Room(hotelName: 'Siargao Surfer\'s Haven', name: 'Yoga Retreat Room', pricePerNight: 2700, type: 'Wellness', capacity: 1, features: 'Yoga Mat • Meditation Cushion • Quiet Zone', imagePath: 'assets/room10.png', description: 'A tranquil room dedicated to wellness, equipped with a yoga mat and meditation cushion.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.self_improvement, label: 'Yoga Mat'), const Amenity(icon: Icons.spa, label: 'Meditation')]),
    ],
    'Manila Urban Grand': [
      Room(hotelName: 'Manila Urban Grand', name: 'Executive City View', pricePerNight: 8000, type: 'Deluxe', capacity: 2, features: 'King Bed • Panoramic City View • Lounge Access', imagePath: 'assets/room1.png', description: 'An executive room offering panoramic city views and exclusive lounge access.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.business_center, label: 'Lounge Access'), const Amenity(icon: Icons.balcony, label: 'City View'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Manila Urban Grand', name: 'Standard Room', pricePerNight: 4500, type: 'Standard', capacity: 2, features: 'Queen Bed • Basic Amenities', imagePath: 'assets/room2.png', description: 'A comfortable standard room with a queen-size bed and essential amenities.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.tv, label: 'TV'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Manila Urban Grand', name: 'Presidential Suite', pricePerNight: 9800, type: 'Suite', capacity: 4, features: 'Multiple Rooms • Private Bar • Butler Service', imagePath: 'assets/room3.png', description: 'The epitome of luxury, this suite offers multiple rooms, a private bar, and personalized butler service.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.local_bar, label: 'Private Bar'), const Amenity(icon: Icons.room_service, label: 'Butler Service'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Manila Urban Grand', name: 'Family Room', pricePerNight: 7000, type: 'Family', capacity: 4, features: '2 Queen Beds • Connecting Option', imagePath: 'assets/room4.png', description: 'An ideal room for families, featuring two queen beds and an option for connecting rooms.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.family_restroom, label: 'Family Room'), const Amenity(icon: Icons.tv, label: 'TV'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Manila Urban Grand', name: 'Club Room', pricePerNight: 6000, type: 'Deluxe', capacity: 2, features: 'Access to Club Lounge • Complimentary Breakfast', imagePath: 'assets/room5.png', description: 'A deluxe room with exclusive access to the club lounge and complimentary breakfast.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.coffee, label: 'Breakfast'), const Amenity(icon: Icons.local_bar, label: 'Club Lounge'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Manila Urban Grand', name: 'Business Suite', pricePerNight: 9500, type: 'Suite', capacity: 2, features: 'Separate Office Area • High-Speed Internet', imagePath: 'assets/room6.png', description: 'A professional suite with a dedicated office area and high-speed internet, perfect for business trips.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.desk, label: 'Work Desk'), const Amenity(icon: Icons.print, label: 'Printer'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Manila Urban Grand', name: 'Accessible Room', pricePerNight: 4000, type: 'Standard', capacity: 2, features: 'Wheelchair Accessible • Roll-in Shower', imagePath: 'assets/room7.png', description: 'A comfortable and accessible room with features designed for guests with mobility needs.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.accessible_forward, label: 'Accessible'), const Amenity(icon: Icons.shower, label: 'Roll-in Shower'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Manila Urban Grand', name: 'Premier Suite', pricePerNight: 10000, type: 'Suite', capacity: 3, features: 'Spacious Layout • Dining Table • City Lights View', imagePath: 'assets/room8.png', description: 'A spacious premier suite with a dining table and captivating city lights view.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.restaurant, label: 'Dining Area'), const Amenity(icon: Icons.balcony, label: 'City Lights View'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Manila Urban Grand', name: 'Studio Apartment', pricePerNight: 5500, type: 'Apartment', capacity: 2, features: 'Kitchenette • Living Area • Long Stay Friendly', imagePath: 'assets/room9.png', description: 'A fully equipped studio apartment with a kitchenette and living area, ideal for long stays.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.kitchen, label: 'Kitchenette'), const Amenity(icon: Icons.living_outlined, label: 'Living Area'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Manila Urban Grand', name: 'Budget Room', pricePerNight: 4000, type: 'Budget', capacity: 1, features: 'Single Bed • Shared Lounge Access', imagePath: 'assets/room10.png', description: 'An affordable single room with access to a shared lounge, perfect for budget-conscious travelers.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.single_bed, label: 'Single Bed'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
    ],
    'Baguio Pine Forest Lodge': [
      Room(hotelName: 'Baguio Pine Forest Lodge', name: 'Pine View Cabin', pricePerNight: 4500, type: 'Cabin', capacity: 2, features: '1 King Bed • Pine Forest View • Balcony', imagePath: 'assets/room1.png', description: 'A charming cabin offering serene pine forest views from its private balcony.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.balcony, label: 'Balcony'), const Amenity(icon: Icons.nature, label: 'Forest View'), const Amenity(icon: Icons.fireplace, label: 'Fireplace')]),
      Room(hotelName: 'Baguio Pine Forest Lodge', name: 'Cozy Standard Room', pricePerNight: 2500, type: 'Standard', capacity: 2, features: 'Queen Bed • Garden Access', imagePath: 'assets/room2.png', description: 'A cozy standard room with a queen-size bed and direct access to the lodge garden.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.local_florist, label: 'Garden'), const Amenity(icon: Icons.tv, label: 'TV')]),
      Room(hotelName: 'Baguio Pine Forest Lodge', name: 'Family Suite', pricePerNight: 5000, type: 'Suite', capacity: 4, features: '2 Bedrooms • Living Area • Fireplace', imagePath: 'assets/room3.png', description: 'A spacious suite with two bedrooms, a comfortable living area, and a cozy fireplace, ideal for families.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.family_restroom, label: 'Family Room'), const Amenity(icon: Icons.fireplace, label: 'Fireplace'), const Amenity(icon: Icons.kitchen, label: 'Kitchenette')]),
      Room(hotelName: 'Baguio Pine Forest Lodge', name: 'Deluxe Balcony Room', pricePerNight: 3800, type: 'Deluxe', capacity: 2, features: 'King Bed • Large Balcony • Mountain Breeze', imagePath: 'assets/room4.png', description: 'A deluxe room with a king-size bed and a large balcony to enjoy the refreshing mountain breeze.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.balcony, label: 'Balcony'), const Amenity(icon: Icons.wind_power, label: 'Fresh Air')]),
      Room(hotelName: 'Baguio Pine Forest Lodge', name: 'Budget Twin Room', pricePerNight: 2200, type: 'Budget', capacity: 2, features: '2 Single Beds • Shared Bathroom', imagePath: 'assets/room5.png', description: 'An economical twin room with two single beds and access to a shared bathroom.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.single_bed, label: 'Twin Beds')]),
      Room(hotelName: 'Baguio Pine Forest Lodge', name: 'Pet-Friendly Cottage', pricePerNight: 3500, type: 'Cottage', capacity: 3, features: 'Private Entrance • Pet Amenities • Enclosed Yard', imagePath: 'assets/room6.png', description: 'A charming cottage with a private entrance and enclosed yard, perfect for guests traveling with pets.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.pets, label: 'Pet-friendly'), const Amenity(icon: Icons.local_florist, label: 'Private Yard')]),
      Room(hotelName: 'Baguio Pine Forest Lodge', name: 'Honeymoon Suite', pricePerNight: 5500, type: 'Suite', capacity: 2, features: 'Romantic Decor • Jacuzzi • Special Amenities', imagePath: 'assets/room7.png', description: 'A beautifully decorated suite designed for honeymooners, featuring a jacuzzi and special amenities.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.hot_tub, label: 'Jacuzzi'), const Amenity(icon: Icons.wine_bar, label: 'Wine Service'), const Amenity(icon: Icons.fireplace, label: 'Fireplace')]),
      Room(hotelName: 'Baguio Pine Forest Lodge', name: 'Artist\'s Retreat', pricePerNight: 3000, type: 'Unique', capacity: 1, features: 'Inspiring Views • Easel & Supplies • Quiet Space', imagePath: 'assets/room8.png', description: 'A unique room offering inspiring views and a quiet space, equipped with an easel and art supplies.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.brush, label: 'Art Supplies'), const Amenity(icon: Icons.palette, label: 'Creative Space')]),
      Room(hotelName: 'Baguio Pine Forest Lodge', name: 'Executive Lodge Room', pricePerNight: 4800, type: 'Deluxe', capacity: 2, features: 'Luxury Furnishings • Lounge Access • Mountain View', imagePath: 'assets/room9.png', description: 'A luxurious lodge room with high-end furnishings, lounge access, and beautiful mountain views.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.business_center, label: 'Lounge Access'), const Amenity(icon: Icons.nature, label: 'Mountain View')]),
      Room(hotelName: 'Baguio Pine Forest Lodge', name: 'Dormitory Bed', pricePerNight: 1500, type: 'Budget', capacity: 1, features: 'Bunk Bed • Shared Facilities • Locker', imagePath: 'assets/room10.png', description: 'An economical bunk bed in a dormitory setting, with shared facilities and a personal locker.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.lock, label: 'Locker')]),
    ],
    'Davao Nature Park Hotel': [
      Room(hotelName: 'Davao Nature Park Hotel', name: 'Nature View Room', pricePerNight: 3500, type: 'Standard', capacity: 2, features: 'Queen Bed • Park View • Balcony', imagePath: 'assets/room1.png', description: 'A comfortable room with a queen-size bed, offering serene park views from its private balcony.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.nature, label: 'Park View'), const Amenity(icon: Icons.balcony, label: 'Balcony'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Davao Nature Park Hotel', name: 'Family Eco Suite', pricePerNight: 4000, type: 'Suite', capacity: 4, features: '2 Bedrooms • Eco-friendly Design • Garden Access', imagePath: 'assets/room2.png', description: 'An eco-friendly suite with two bedrooms and direct garden access, perfect for families.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.eco, label: 'Eco-friendly'), const Amenity(icon: Icons.family_restroom, label: 'Family Room'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Davao Nature Park Hotel', name: 'Adventure Lodge Room', pricePerNight: 3800, type: 'Deluxe', capacity: 2, features: 'King Bed • Near Adventure Park • Gear Storage', imagePath: 'assets/room3.png', description: 'A deluxe room conveniently located near the adventure park, with dedicated gear storage.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.hiking, label: 'Adventure Access'), const Amenity(icon: Icons.storage, label: 'Gear Storage'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Davao Nature Park Hotel', name: 'Standard Twin Room', pricePerNight: 2800, type: 'Standard', capacity: 2, features: '2 Single Beds • Basic Amenities', imagePath: 'assets/room4.png', description: 'A standard room with two single beds and essential amenities for a comfortable stay.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.tv, label: 'TV'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Davao Nature Park Hotel', name: 'Cultural Immersion Room', pricePerNight: 3000, type: 'Unique', capacity: 2, features: 'Local Art Decor • Cultural Books', imagePath: 'assets/room5.png', description: 'A uniquely decorated room featuring local art and cultural books for an immersive experience.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.museum, label: 'Cultural Decor'), const Amenity(icon: Icons.book, label: 'Local Books'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Davao Nature Park Hotel', name: 'Budget Room', pricePerNight: 1500, type: 'Budget', capacity: 1, features: 'Single Bed • Shared Bathroom', imagePath: 'assets/room6.png', description: 'An economical single room with basic amenities and access to a shared bathroom.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.single_bed, label: 'Single Bed'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Davao Nature Park Hotel', name: 'Deluxe Pool Access', pricePerNight: 3200, type: 'Deluxe', capacity: 2, features: 'Direct Pool Access • King Bed', imagePath: 'assets/room7.png', description: 'A deluxe room with a king-size bed and direct access to the hotel\'s swimming pool.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.pool, label: 'Pool Access'), const Amenity(icon: Icons.balcony, label: 'Terrace'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Davao Nature Park Hotel', name: 'Executive Suite', pricePerNight: 3900, type: 'Suite', capacity: 3, features: 'Separate Living Area • City View', imagePath: 'assets/room8.png', description: 'A spacious executive suite with a separate living area and views of the city.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.living_outlined, label: 'Living Area'), const Amenity(icon: Icons.balcony, label: 'City View'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Davao Nature Park Hotel', name: 'Treehouse Glamping', pricePerNight: 2500, type: 'Glamping', capacity: 2, features: 'Elevated Tent • Outdoor Seating • Forest Sounds', imagePath: 'assets/room9.png', description: 'Experience glamping in an elevated tent, surrounded by forest sounds and outdoor seating.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.nature, label: 'Forest Immersion'), const Amenity(icon: Icons.chair, label: 'Outdoor Seating'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Davao Nature Park Hotel', name: 'Honeymoon Villa', pricePerNight: 3700, type: 'Villa', capacity: 2, features: 'Secluded Villa • Private Garden • Romantic Setup', imagePath: 'assets/room10.png', description: 'A secluded villa with a private garden, designed for a romantic and intimate honeymoon.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.local_florist, label: 'Private Garden'), const Amenity(icon: Icons.wine_bar, label: 'Wine Service'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
    ],
    'Iloilo Heritage Inn': [
      Room(hotelName: 'Iloilo Heritage Inn', name: 'Heritage Deluxe Room', pricePerNight: 2800, type: 'Deluxe', capacity: 2, features: 'Queen Bed • Colonial Decor • City View', imagePath: 'assets/room1.png', description: 'A deluxe room with charming colonial decor and views of the city.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.museum, label: 'Historical Decor'), const Amenity(icon: Icons.tv, label: 'TV'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Iloilo Heritage Inn', name: 'Standard Twin Room', pricePerNight: 1800, type: 'Standard', capacity: 2, features: '2 Single Beds • Basic Amenities', imagePath: 'assets/room2.png', description: 'A comfortable standard room with two single beds and essential amenities.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.single_bed, label: 'Twin Beds'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Iloilo Heritage Inn', name: 'Family Connecting Room', pricePerNight: 2900, type: 'Family', capacity: 4, features: '2 Connecting Rooms • Shared Bathroom', imagePath: 'assets/room3.png', description: 'Two connecting rooms with a shared bathroom, ideal for families traveling together.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.family_restroom, label: 'Family Room'), const Amenity(icon: Icons.tv, label: 'TV'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Iloilo Heritage Inn', name: 'Culinary Suite', pricePerNight: 2500, type: 'Suite', capacity: 2, features: 'Kitchenette • Dining Area • Local Cookbook', imagePath: 'assets/room4.png', description: 'A suite designed for food enthusiasts, featuring a kitchenette, dining area, and local cookbooks.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.kitchen, label: 'Kitchenette'), const Amenity(icon: Icons.restaurant_menu, label: 'Local Cuisine'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Iloilo Heritage Inn', name: 'Budget Single', pricePerNight: 1000, type: 'Budget', capacity: 1, features: 'Single Bed • Shared Bathroom', imagePath: 'assets/room5.png', description: 'An economical single room with basic amenities and access to a shared bathroom.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.single_bed, label: 'Single Bed'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Iloilo Heritage Inn', name: 'Executive Suite', pricePerNight: 2700, type: 'Suite', capacity: 3, features: 'Separate Living Area • Work Desk', imagePath: 'assets/room6.png', description: 'A spacious executive suite with a separate living area and a dedicated work desk.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.living_outlined, label: 'Living Area'), const Amenity(icon: Icons.desk, label: 'Work Desk'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Iloilo Heritage Inn', name: 'Art Deco Room', pricePerNight: 2600, type: 'Unique', capacity: 2, features: 'Vintage Decor • City Landmark View', imagePath: 'assets/room7.png', description: 'A uniquely designed room with vintage art deco decor and views of city landmarks.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.architecture, label: 'Art Deco'), const Amenity(icon: Icons.location_city, label: 'Landmark View'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Iloilo Heritage Inn', name: 'Accessible Room', pricePerNight: 2500, type: 'Standard', capacity: 2, features: 'Wheelchair Accessible • Grab Bars', imagePath: 'assets/room8.png', description: 'A comfortable and accessible room with features designed for guests with mobility needs.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.accessible_forward, label: 'Accessible'), const Amenity(icon: Icons.bathtub, label: 'Grab Bars'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Iloilo Heritage Inn', name: 'Balcony Room', pricePerNight: 2400, type: 'Deluxe', capacity: 2, features: 'Queen Bed • Private Balcony • Street View', imagePath: 'assets/room9.png', description: 'A deluxe room with a queen-size bed and a private balcony offering street views.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.balcony, label: 'Balcony'), const Amenity(icon: Icons.streetview, label: 'Street View'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
      Room(hotelName: 'Iloilo Heritage Inn', name: 'Long Stay Apartment', pricePerNight: 2300, type: 'Apartment', capacity: 2, features: 'Full Kitchen • Laundry Facilities • Spacious', imagePath: 'assets/room10.png', description: 'A spacious apartment with a full kitchen and laundry facilities, ideal for extended stays.', amenities: [const Amenity(icon: Icons.wifi, label: 'Wi-Wi'), const Amenity(icon: Icons.kitchen, label: 'Full Kitchen'), const Amenity(icon: Icons.local_laundry_service, label: 'Laundry'), const Amenity(icon: Icons.ac_unit, label: 'AC')]),
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadRooms();
    // Listen to RoomManager for changes and update the UI
    RoomManager().addListener(_onRoomManagerChanged);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    RoomManager().removeListener(_onRoomManagerChanged);
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onRoomManagerChanged() {
    // This method is called when RoomManager notifies listeners of a change
    _loadRooms(); // Reload all rooms (static + dynamic)
    _filter(_searchController.text); // Re-filter based on current search/filters
  }

  void _loadRooms() {
    setState(() {
      // Try to get the hotel from HotelManager
      final hotel = HotelManager().hotels.firstWhereOrNull(
        (h) => h.name == widget.hotelName,
      );
      if (hotel != null && hotel.rooms.isNotEmpty) {
        allRooms = List<Room>.from(hotel.rooms);
        print('RoomListScreen: Displaying rooms for hotel ${hotel.name}: ' + hotel.rooms.map((r) => r.name).toList().toString());
      } else {
        // Fallback to static and manager logic
        List<Room> roomsFromStaticData = _hotelRoomsData[widget.hotelName] ?? [];
        List<Room> roomsFromManager = RoomManager().rooms.where((room) => room.hotelName == widget.hotelName).toList();
        Set<String> existingRoomNames = roomsFromStaticData.map((room) => room.name.toLowerCase()).toSet();
        for (var room in roomsFromManager) {
          if (!existingRoomNames.contains(room.name.toLowerCase())) {
            roomsFromStaticData.add(room);
          }
        }
        allRooms = roomsFromStaticData;
        print('RoomListScreen: Fallback, displaying rooms for hotel ${widget.hotelName}: ' + allRooms.map((r) => r.name).toList().toString());
      }
      filteredRooms = List.from(allRooms);
    });
  }

  void _onSearchChanged() {
    _filter(_searchController.text);
  }

  void _filter(String query) {
    setState(() {
      filteredRooms = allRooms.where((room) {
        final lowerCaseQuery = query.toLowerCase();
        final matchesSearch = room.name.toLowerCase().contains(lowerCaseQuery) ||
            room.type.toLowerCase().contains(lowerCaseQuery) ||
            room.description.toLowerCase().contains(lowerCaseQuery) ||
            room.features.toLowerCase().contains(lowerCaseQuery);

        final matchesPrice = (selectedMinPrice == 0 || room.pricePerNight >= selectedMinPrice!) &&
                             (selectedMaxPrice == 20000 || room.pricePerNight <= selectedMaxPrice!);

        final matchesCapacity = selectedCapacity == null || room.capacity >= selectedCapacity!;

        final matchesType = selectedType == 'All' || room.type.toLowerCase() == selectedType.toLowerCase();

        return matchesSearch && matchesPrice && matchesCapacity && matchesType;
      }).toList();
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
                  color: Colors.grey.withValues(alpha: 0.2), // Use withValues instead of withOpacity
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
    // Determine if the image is a network image or an asset
    final bool isNetworkImage = room.imagePath != null && (room.imagePath!.startsWith('http://') || room.imagePath!.startsWith('https://'));

    Widget roomImageWidget;
    if (isNetworkImage) {
      roomImageWidget = Image.network(
        room.imagePath!, // Use room.imagePath
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 180,
          color: Colors.grey[300],
          child: const Center(child: Icon(Icons.broken_image, size: 50)), // Changed to broken_image
        ),
      );
    } else {
      roomImageWidget = Image.asset(
        room.imagePath ?? 'assets/placeholder_room.png', // Use room.imagePath or a placeholder
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 180,
          color: Colors.grey[300],
          child: const Center(child: Icon(Icons.image_not_supported, size: 50)), // Changed to image_not_supported
        ),
      );
    }


    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: kWhite, // Changed to kWhite
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: roomImageWidget, // Use the determined image widget
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
                    Text('₱${room.pricePerNight.toStringAsFixed(2)} / night', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kPrimaryBlue)), // Use pricePerNight and format
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingFormScreen(
                              hotelName: widget.hotelName,
                              roomType: room.name,
                              price: room.pricePerNight, // Use pricePerNight
                              roomImagePath: room.imagePath ?? 'assets/placeholder_room.png', // Pass imagePath
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
