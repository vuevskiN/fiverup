import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF0D1B2A),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://cdn.builder.io/api/v1/image/assets/TEMP/a079ea61b93827878cdf013001ee62e5eb7e224dd09556df71af3f901956a512?placeholderIfAbsent=true&apiKey=a8695391dc78414caaae2cf40409f049'),
            ),
          ),
          SizedBox(width: 6),
          Expanded(
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFE0E1DD)),
              ),
              child: Text(
                'FiverUP',
                style: TextStyle(
                  color: Color(0xFFE0E1DD),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Playfair Display',
                  letterSpacing: 0.66,
                ),
              ),
            ),
          ),
          SizedBox(width: 6),
          Container(
            width: 48,
            height: 48,
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://cdn.builder.io/api/v1/image/assets/TEMP/9a32955cb3b94806a19dd3b300081349490446c424ed877c21c786160b33de92?placeholderIfAbsent=true&apiKey=a8695391dc78414caaae2cf40409f049'),
            ),
          ),
        ],
      ),
    );
  }
}