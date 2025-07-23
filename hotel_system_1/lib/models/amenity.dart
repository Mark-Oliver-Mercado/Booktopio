// lib/models/amenity.dart
import 'package:flutter/material.dart'; // For IconData

class Amenity {
  final IconData icon;
  final String label;
  const Amenity({required this.icon, required this.label});

  // Optional: Add a method to convert to/from a storable format if needed for persistence
  Map<String, dynamic> toJson() => {
    'iconCodePoint': icon.codePoint,
    'label': label,
  };

  static Amenity fromJson(Map<String, dynamic> json) => Amenity(
    icon: IconData(json['iconCodePoint'], fontFamily: 'MaterialIcons'),
    label: json['label'],
  );
}
