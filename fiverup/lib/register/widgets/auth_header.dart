import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D1B2A),
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          _buildMenuButton(), // Menu button
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE0E1DD)),
              ),
              child: const Text(
                'FiverUP',
                style: TextStyle(
                  color: Color(0xFFE0E1DD),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Playfair Display',
                  letterSpacing: 0.66,
                ),
              ),
            ),
          ),
          _buildIconButton(Icons.account_circle), // Changed to Icon
        ],
      ),
    );
  }

  Widget _buildMenuButton() {
    return SizedBox(
      width: 48,
      child: Center(
        child: Container(
          width: 32, // Width of the rectangle
          height: 16, // Height of the rectangle
          decoration: BoxDecoration(
            color: Colors.grey, // Color of the rectangle
            borderRadius: BorderRadius.circular(4), // Slight rounding if desired
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return SizedBox(
      width: 48,
      child: Center(
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 24,
            color: Colors.grey, // Color of the Icon
          ),
        ),
      ),
    );
  }
}
