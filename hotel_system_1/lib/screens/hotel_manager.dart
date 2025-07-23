// lib/screens/hotel_manager.dart
import 'package:flutter/material.dart';
import '../models/hotel.dart';
import '../models/amenity.dart'; // Import Amenity model
import '../models/room.dart'; // Import Room model

class HotelManager extends ChangeNotifier {
  static final HotelManager _instance = HotelManager._internal();
  factory HotelManager() => _instance;
  HotelManager._internal();

  final List<Hotel> _hotels = [];
  // Global lists for categories and amenities available in the app
  final List<Amenity> _availableAmenities = [
    Amenity(icon: Icons.wifi, label: 'Wi-Fi'),
    Amenity(icon: Icons.pool, label: 'Pool'),
    Amenity(icon: Icons.beach_access, label: 'Beach Access'),
    Amenity(icon: Icons.spa, label: 'Spa'),
    Amenity(icon: Icons.restaurant, label: 'Restaurant'),
    Amenity(icon: Icons.local_parking, label: 'Parking'),
    Amenity(icon: Icons.fitness_center, label: 'Fitness Center'),
    Amenity(icon: Icons.ac_unit, label: 'Air Conditioning'),
    Amenity(icon: Icons.tv, label: 'TV'),
    Amenity(icon: Icons.local_bar, label: 'Mini Bar'),
    Amenity(icon: Icons.balcony, label: 'Balcony'),
    Amenity(icon: Icons.breakfast_dining, label: 'Breakfast Included'),
    Amenity(icon: Icons.fireplace, label: 'Fireplace'),
    Amenity(icon: Icons.pets, label: 'Pet-friendly'),
    Amenity(icon: Icons.bathtub, label: 'Jacuzzi'),
    Amenity(icon: Icons.room_service, label: 'Room Service'),
    Amenity(icon: Icons.dry_cleaning, label: 'Laundry Service'),
    Amenity(icon: Icons.airport_shuttle, label: 'Airport Shuttle'),
    Amenity(icon: Icons.desk, label: 'Work Desk'),
    Amenity(icon: Icons.kitchen, label: 'Kitchenette'),
    Amenity(icon: Icons.accessible_forward, label: 'Accessible'),
    // Add more common amenities here
  ];

  // Global list for categories available in the app
  final List<String> _availableCategories = [
    'Luxury',
    'Budget',
    'Family',
    'Business',
    'Boutique',
    'Resort',
    'Hostel',
    // Add more categories as needed
  ];


  List<Hotel> get hotels => List.unmodifiable(_hotels);
  List<String> get availableCategories => List.unmodifiable(_availableCategories);
  List<Amenity> get availableAmenities => List.unmodifiable(_availableAmenities);

  void addHotel(Hotel hotel) {
    if (!_hotels.any((h) => h.name == hotel.name)) {
      _hotels.add(hotel);
      notifyListeners();
    }
  }

  void updateHotel(Hotel originalHotel, {
    String? image,
    String? name,
    String? location,
    String? rating,
    String? description,
    List<String>? categories,
    List<Amenity>? amenities, // Updated type
    String? priceRange,
    bool? isFavorite,
    String? contactNumber,
    String? licenseNumber,
    int? roomCount,
    List<Room>? rooms, // Add rooms parameter
  }) {
    final int index = _hotels.indexOf(originalHotel);
    if (index != -1) {
      _hotels[index] = originalHotel.copyWith(
        image: image,
        name: name,
        location: location,
        rating: rating,
        description: description,
        categories: categories,
        amenities: amenities, // Updated type
        priceRange: priceRange,
        isFavorite: isFavorite,
        contactNumber: contactNumber,
        licenseNumber: licenseNumber,
        roomCount: roomCount,
        rooms: rooms, // Pass rooms to copyWith
      );
      notifyListeners();
    }
  }

  void toggleFavoriteStatus(Hotel hotel) {
    final int index = _hotels.indexOf(hotel);
    if (index != -1) {
      _hotels[index].isFavorite = !_hotels[index].isFavorite;
      notifyListeners();
    }
  }

  void addCategory(String category) {
    if (!_availableCategories.contains(category)) {
      _availableCategories.add(category);
      notifyListeners();
    }
  }

  void removeCategory(String category) {
    if (_availableCategories.remove(category)) {
      notifyListeners();
    }
  }

  void addAmenity(Amenity amenity) {
    // Check if an amenity with the same label already exists to avoid duplicates
    if (!_availableAmenities.any((a) => a.label == amenity.label)) {
      _availableAmenities.add(amenity);
      notifyListeners();
    }
  }

  void removeAmenity(Amenity amenity) {
    final exists = _availableAmenities.any((a) => a.label == amenity.label);
    _availableAmenities.removeWhere((a) => a.label == amenity.label);
    if (exists) {
      notifyListeners();
    }
  }
}
