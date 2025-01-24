import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../service/notification_service.dart';

class ApplicantListScreen extends StatefulWidget {
  final String jobTitle;
  final List<Map<String, dynamic>> applications;

  // Constructor
  ApplicantListScreen({required this.jobTitle, required this.applications});

  @override
  _ApplicantListScreenState createState() => _ApplicantListScreenState();
}

class _ApplicantListScreenState extends State<ApplicantListScreen> {
  final NotificationService _notificationService = NotificationService();

  void _sendNotification(String applicantEmail, String status) async {
    // Send notification when a decision is made
    await _notificationService.sendNotification(
      senderEmail: FirebaseAuth.instance.currentUser!.email!,
      receiverEmail: applicantEmail,
      status: status,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Applicants for ${widget.jobTitle}'),
      ),
      body: widget.applications.isEmpty
          ? const Center(child: Text('No applicants yet.'))
          : ListView.builder(
        itemCount: widget.applications.length,
        itemBuilder: (context, index) {
          final application = widget.applications[index];
          return ListTile(
            title: Text(application['applicantEmail']),
            subtitle: Text(
              'Applied on: ${(application['appliedAt'] as Timestamp).toDate().toString()}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check, color: Colors.green),
                  onPressed: () {
                    // Send acceptance notification
                    _sendNotification(application['applicantEmail'], 'accepted');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    // Send denial notification
                    _sendNotification(application['applicantEmail'], 'denied');
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
