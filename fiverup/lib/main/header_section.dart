import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../login/form_container.dart';
import '../notification_screen/botification_screen.dart';
import '../profile/profile_screen.dart';
import '../register/widgets/signup_form.dart';

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
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('notifications')
                .where('receiverEmail', isEqualTo: profileId)
                .where('isRead', isEqualTo: false) // filter unread notifications
                .snapshots(),
            builder: (context, snapshot) {
              Color bellColor = Colors.black;
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                bellColor = Colors.red; // Unread notifications, turn bell red
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

          // Dropdown Menu with Sign Out and Notifications
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onSelected: (String value) {
              if (value == 'notifications') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Notifications coming soon!')),
                );
              } else if (value == 'signOut') {
                _showSignOutDialog(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'notifications',
                  child: Row(
                    children: [
                      Icon(Icons.notifications, size: 24),
                      SizedBox(width: 8),
                      Text('Notifications'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'signOut',
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app, size: 24),
                      SizedBox(width: 8),
                      Text('Sign Out'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
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
