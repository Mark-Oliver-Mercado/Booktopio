// lib/screens/room_manager.dart
import 'package:flutter/foundation.dart'; // Import for ChangeNotifier
import 'package:hotel_system_1/models/room.dart';
import 'package:hotel_system_1/models/amenity.dart'; // Import Amenity model
import 'hotel_manager.dart'; // Import HotelManager

class RoomManager extends ChangeNotifier { // Extend ChangeNotifier
  static final RoomManager _instance = RoomManager._internal();
  factory RoomManager() => _instance;
  RoomManager._internal();

  final List<Room> _rooms = [];

  List<Room> get rooms => _rooms;

  void addRoom(Room room) {
    // Prevent adding rooms with duplicate names
    if (!_rooms.any((r) => r.name.toLowerCase() == room.name.toLowerCase())) {
      _rooms.add(room);
      // Also add the room to the corresponding hotel's rooms list
      final hotels = HotelManager().hotels.where((h) => h.name == room.hotelName);
      if (hotels.isNotEmpty) {
        final hotel = hotels.first;
        final updatedRooms = List<Room>.from(hotel.rooms)..add(room);
        HotelManager().updateHotel(
          hotel,
          rooms: updatedRooms,
        );
      }
      notifyListeners(); // Notify listeners of change
    } else {
      debugPrint('Room with name "${room.name}" already exists.'); // Use debugPrint for console output
    }
  }

  // Method to update a room's status
  void updateRoomStatus(String roomName, String newStatus) {
    final int index = _rooms.indexWhere((room) => room.name == roomName);
    if (index != -1) {
      _rooms[index].status = newStatus;
      notifyListeners(); // Notify listeners of change
    }
  }

  // Method to update a room's details (if needed in the future)
  void updateRoom(Room originalRoom, {
    String? name,
    String? type,
    int? capacity,
    double? pricePerNight,
    String? description,
    String? imagePath,
    List<Amenity>? amenities, // Changed to List<Amenity>
    String? status,
  }) {
    final int index = _rooms.indexOf(originalRoom);
    if (index != -1) {
      _rooms[index] = originalRoom.copyWith(
        name: name,
        type: type,
        capacity: capacity,
        pricePerNight: pricePerNight,
        description: description,
        imagePath: imagePath,
        amenities: amenities,
        status: status,
      );
      notifyListeners(); // Notify listeners of change
    }
  }

  // Method to get a room by name
  Room? getRoomByName(String name) {
    try {
      return _rooms.firstWhere((room) => room.name == name);
    } catch (e) {
      return null;
    }
  }

  void clearAllRooms() {
    _rooms.clear();
    notifyListeners(); // Notify listeners of change
  }
}
