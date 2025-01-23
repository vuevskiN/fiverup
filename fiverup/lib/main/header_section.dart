import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../profile/profile_screen.dart';

class HeaderSection extends StatelessWidget {
  final String profileId;

  const HeaderSection({Key? key, required this.profileId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0x0D1B2A),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile Icon
          GestureDetector(
            onTap: () {
              if (profileId.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User not authenticated. Please log in.')),
                );
                return;
              }

              print("PROFILE FROM HEADER SECTION: $profileId");

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(profileId: profileId),
                ),
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 24, color: Colors.black),
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
          // Notifications Icon
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Notifications coming soon!')),
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.notifications, size: 24, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
