//fliter.dart
import 'package:hotel_system_1/models/room.dart'; // Import the canonical Room model

/// Filters rooms based on multiple criteria.
/// If all filters are null or default, all rooms are returned.
List<Room> filterRooms(
  List<Room> allRooms,
  String query, {
  double? minPrice, // Changed to double to match Room.pricePerNight
  double? maxPrice, // Changed to double to match Room.pricePerNight
  int? capacity,
  String? type,
  bool reset = false, // 🔄 NEW reset flag
}) {
  if (reset || (query.isEmpty && minPrice == null && maxPrice == null && capacity == null && (type == null || type == 'All'))) {
    return List.from(allRooms); // Return all rooms when no filters are applied or reset is true
  }

  final lowerQuery = query.toLowerCase();

  return allRooms.where((room) {
    final matchesQuery = room.name.toLowerCase().contains(lowerQuery) ||
        room.features.toLowerCase().contains(lowerQuery) ||
        room.description.toLowerCase().contains(lowerQuery);

    final matchesPrice = (minPrice == null || room.pricePerNight >= minPrice) && // Use pricePerNight
        (maxPrice == null || room.pricePerNight <= maxPrice); // Use pricePerNight

    final matchesCapacity = capacity == null || room.capacity == capacity;

    final matchesType = type == null || type == 'All' || room.type == type;

    return matchesQuery && matchesPrice && matchesCapacity && matchesType;
  }).toList();
} 