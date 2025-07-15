import 'bookingform.dart'; // For Amenity

class Room {
  final String name;
  final int price;
  final String type;
  final int capacity;
  final String features;
  final String image;
  final String description;
  final List<Amenity> amenities;

  Room({
    required this.name,
    required this.price,
    required this.type,
    required this.capacity,
    required this.features,
    required this.image,
    required this.description,
    required this.amenities,
  });
}

/// Filters rooms based on multiple criteria.
/// If all filters are null or default, all rooms are returned.
List<Room> filterRooms(
  List<Room> allRooms,
  String query, {
  int? minPrice,
  int? maxPrice,
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

    final matchesPrice = (minPrice == null || room.price >= minPrice) &&
        (maxPrice == null || room.price <= maxPrice);

    final matchesCapacity = capacity == null || room.capacity == capacity;

    final matchesType = type == null || type == 'All' || room.type == type;

    return matchesQuery && matchesPrice && matchesCapacity && matchesType;
  }).toList();
}
