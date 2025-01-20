import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0x0D1B2A),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // First CircleAvatar with Icon instead of Image
          CircleAvatar(
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
          CircleAvatar(
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
        ],
      ),
    );
  }
}
