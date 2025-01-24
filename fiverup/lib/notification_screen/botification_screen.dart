import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../service/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notificationService = NotificationService();
  late String userEmail;

  @override
  void initState() {
    super.initState();
    // Initialize the userEmail from FirebaseAuth
    userEmail = FirebaseAuth.instance.currentUser!.email!;
    print("Logged in email $userEmail");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _notificationService.getNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No notifications.'));
          }

          // Filter notifications for the logged-in user's email
          final notifications = snapshot.data!
              .where((notification) => notification['receiverEmail'] == userEmail)
              .toList();

          if (notifications.isEmpty) {
            return Center(child: Text('No notifications for you.'));
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return ListTile(
                title: Text('From: ${notification['senderEmail']}'),
                subtitle: Text('Status: ${notification['status']}'),
                trailing: Text(
                  (notification['timestamp'] as Timestamp)
                      .toDate()
                      .toString(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
