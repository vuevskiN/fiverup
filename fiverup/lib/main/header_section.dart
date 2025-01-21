import 'package:fiverup/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch the current user's profileId from FirebaseAuth (or any other method you're using to manage profileId)
    final String profileId = FirebaseAuth.instance.currentUser?.uid ?? ''; // Replace this with actual profileId logic

    return Container(
      color: Color(0x0D1B2A),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // First CircleAvatar with Icon instead of Image
          GestureDetector(
            onTap: () {
              // Navigate to ProfileScreen with profileId
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(profileId: profileId), // Pass profileId here
                ),
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.person, // Replace with the appropriate icon
                  size: 24, // Adjust size if needed
                  color: Colors.black, // Adjust icon color if needed
                ),
              ),
            ),
          ),
          Text(
            'FiverUP',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE0E1DD),
              letterSpacing: 0.66,
            ),
          ),
          // Second CircleAvatar with Icon instead of Image
          GestureDetector(
            onTap: () {
              // Add navigation logic for Notifications (or any other page)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(profileId: profileId), // Pass profileId here too
                ),
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.notifications, // Replace with the appropriate icon
                  size: 24, // Adjust size if needed
                  color: Colors.black, // Adjust icon color if needed
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
