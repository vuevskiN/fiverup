import 'package:flutter/cupertino.dart';

class ImageModel {
  final String userId;
  final IconData icon;

  ImageModel({required this.userId, required this.icon});

  // Convert ImageModel to a map for storage or JSON serialization
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'icon': icon.codePoint,
    };
  }

  // Create an ImageModel from a map (for fetching data from storage or JSON)
  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      userId: map['userId'],
      icon: IconData(map['icon'], fontFamily: 'MaterialIcons'),
    );
  }
}
