import 'package:flutter/material.dart';
import '../models/profile.dart'; // Import Profile model

class ProfileInfo extends StatelessWidget {
  final Profile profile; // Accept the Profile object

  const ProfileInfo({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: 156,
      child: Column(
        children: [
          Text(
            profile.name, // Use profile name
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              letterSpacing: -2.16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            profile.profession, // Use profile profession
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
