import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../login/form_container.dart';
import '../notification_screen/botification_screen.dart';
import '../profile/profile_screen.dart';

class HeaderSection extends StatelessWidget {
  final String profileId;

  const HeaderSection({Key? key, required this.profileId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D1B2A), // Dark background similar to AppHeader design
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (profileId.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User not authenticated. Please log in.')),
                );
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(profileId: profileId),
                ),
              );
            },
            child: _buildCircularButton(Icons.person), // Profile button using Icon
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE0E1DD)), // Matching border style
              ),
              child: const Text(
                'FiverUP',
                style: TextStyle(
                  color: Color(0xFFE0E1DD), // Light text color
                  fontSize: 22,
                  fontFamily: 'Playfair Display',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.66,
                ),
              ),
            ),
          ),
          Row(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('notifications')
                    .where('receiverEmail', isEqualTo: profileId)
                    .where('isRead', isEqualTo: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  Color bellColor = Colors.white;
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    bellColor = Colors.red; // Unread notifications
                  }
                  return IconButton(
                    icon: Icon(Icons.notifications, color: bellColor),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsScreen(),
                        ),
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.exit_to_app, color: Colors.white),
                onPressed: () {
                  _showSignOutDialog(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton(IconData icon) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Center(
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white, // Circular button with a white background
          ),
          child: Icon(icon, size: 24, color: const Color(0xFF415A77)), // Icon color adjusted to match the scheme
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Out'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => FormContainerPage()),
                );
              },
              child: Text('Log Out'),
            ),
          ],
        );
      },
    );
  }
}
