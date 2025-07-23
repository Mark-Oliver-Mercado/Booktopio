// lib/models/room.dart
import 'amenity.dart'; // Ensure this import is correct for your Amenity class

class Room {
  final String hotelName;
  final String name;
  final double pricePerNight; // Changed to double
  final String type;
  final int capacity;
  final String features;
  final String? imagePath; // Changed to imagePath
  final String description;
  final List<Amenity> amenities;
  String status; // Example of a mutable property

  Room({
    required this.hotelName,
    required this.name,
    required this.pricePerNight,
    required this.type,
    required this.capacity,
    required this.features,
    this.imagePath,
    required this.description,
    required this.amenities,
    this.status = 'Available',
  });

  // You might also have a copyWith method like this (optional but good practice)
  Room copyWith({
    String? hotelName,
    String? name,
    double? pricePerNight,
    String? type,
    int? capacity,
    String? features,
    String? imagePath,
    String? description,
    List<Amenity>? amenities,
    String? status,
  }) {
    return Room(
      hotelName: hotelName ?? this.hotelName,
      name: name ?? this.name,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      type: type ?? this.type,
      capacity: capacity ?? this.capacity,
      features: features ?? this.features,
      imagePath: imagePath ?? this.imagePath,
      description: description ?? this.description,
      amenities: amenities ?? this.amenities,
      status: status ?? this.status,
    );
  }
}
