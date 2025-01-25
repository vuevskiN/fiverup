import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
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

  void _sendNotification(String applicantEmail, String status, int index) async {
    // Send notification when a decision is made
    await _notificationService.sendNotification(
      senderEmail: FirebaseAuth.instance.currentUser!.email!,
      receiverEmail: applicantEmail,
      status: status,
    );

    // Remove the card from the list
    setState(() {
      widget.applications.removeAt(index);
    });
  }

  String _formatDate(Timestamp timestamp) {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Applicants for ${widget.jobTitle}'),
        backgroundColor: const Color(0xFF0D1B2A),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: widget.applications.isEmpty
          ? const Center(
        child: Text(
          'No applicants yet.',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: widget.applications.length,
        itemBuilder: (context, index) {
          final application = widget.applications[index];
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Applicant Email
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          application['applicantEmail'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Applied on: ${_formatDate(application['appliedAt'])}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Action Buttons
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _sendNotification(application['applicantEmail'], 'accepted', index);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Green for accepted
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: const Icon(Icons.check, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          _sendNotification(application['applicantEmail'], 'denied', index);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Red for denied
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
