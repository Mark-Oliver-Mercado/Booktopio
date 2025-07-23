// lib/models/hotel.dart
// Ensure this file exists and has the correct structure for Hotel
import 'amenity.dart'; // Import the Amenity model
import 'room.dart'; // Import the Room model

class Hotel {
  final String image;
  final String name;
  final String location;
  final String rating;
  final String description;
  final List<String> categories; // Categories will remain strings
  final List<Amenity> amenities; // Changed to list of Amenity objects
  final String priceRange;
  bool isFavorite;
  final String? contactNumber; // Added for Hotel Owner info
  final String? licenseNumber; // Added for Hotel Owner info
  final int? roomCount; // Added for Hotel Owner info
  final List<Room> rooms;

  Hotel({
    required this.image,
    required this.name,
    required this.location,
    required this.rating,
    required this.description,
    this.categories = const [],
    this.amenities = const [], // Default to empty list of Amenity
    required this.priceRange,
    this.isFavorite = false,
    this.contactNumber,
    this.licenseNumber,
    this.roomCount,
    this.rooms = const [],
  });

  // Method to update favorite status
  Hotel copyWith({
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
    List<Room>? rooms,
  }) {
    return Hotel(
      image: image ?? this.image,
      name: name ?? this.name,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      description: description ?? this.description,
      categories: categories ?? this.categories,
      amenities: amenities ?? this.amenities, // Updated type
      priceRange: priceRange ?? this.priceRange,
      isFavorite: isFavorite ?? this.isFavorite,
      contactNumber: contactNumber ?? this.contactNumber,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      roomCount: roomCount ?? this.roomCount,
      rooms: rooms ?? this.rooms,
    );
  }
}