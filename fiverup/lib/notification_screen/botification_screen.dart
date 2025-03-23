import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiverup/gmail/gmailScreen.dart';
import 'package:fiverup/payment_screen/PaymentScreen.dart';
import 'package:fiverup/service/applicationHistory_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/applicationHistory.dart';
import '../service/application_service.dart';
import '../service/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ApplicationService _applicationService = ApplicationService();
  final NotificationService _notificationService = NotificationService();
  final ApplicationHistoryService _applicationHistoryService = ApplicationHistoryService();
  late String userEmail;
  late Future<List<Map<String, dynamic>>> applications;

  @override
  void initState() {
    super.initState();
    userEmail = FirebaseAuth.instance.currentUser!.email!;
    applications = _applicationService.fetchApplicationsForUser();
  }

  Future<String> _getApplicantName(String applicantEmail) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(applicantEmail)
          .get();

      if (userDoc.exists) {
        return userDoc['email'] ?? 'Unknown';
      } else {
        return 'Unknown';
      }
    } catch (e) {
      print("Error fetching applicant name: $e");
      return 'Unknown';
    }
  }

  void _acceptApplication(
      String applicationId, String applicantEmail) async {
    try {

      await FirebaseFirestore.instance
          .collection('applications')
          .doc(applicationId)
          .update({'status': 'accepted'});

          await _applicationService.processApplication(applicantEmail, 'accepted', applicationId);


      await _applicationHistoryService.logApplicationDecision(
        applicantEmail,
        'accepted',
        Timestamp.now(),
        userEmail,
      );

      setState(() {
        applications = _applicationService.fetchApplicationsForUser();
      });
    } catch (e) {
      print("Error accepting application: $e");
    }
  }

  void _rejectApplication(String applicationId, String applicantEmail) async {
    try {

      await FirebaseFirestore.instance
          .collection('applications')
          .doc(applicationId)
          .update({'status': 'rejected'});

          await _applicationService.processApplication(applicantEmail, 'rejected', applicationId);

      // Log this decision
      await _applicationHistoryService.logApplicationDecision(
        applicantEmail, 'rejected', Timestamp.now(), userEmail
      );

      setState(() {
        applications = _applicationService.fetchApplicationsForUser();
      });
    } catch (e) {
      print("Error rejecting application: $e");
    }
  }


  String _formatTimestamp(Timestamp timestamp) {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp.toDate());
  }

  void _showDeleteDialog(BuildContext context, String notificationId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Notification'),
          content: const Text('Are you sure you want to delete this notification?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close dialog
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: () async {
                await _notificationService.deleteNotification(notificationId);
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFF0D1B2A), // Modern dark-blue theme
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Notifications Stream
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _notificationService.getNotifications(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No notifications.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                final notifications = snapshot.data!
                    .where((notification) => notification['receiverEmail'] == userEmail)
                    .toList();

                if (notifications.isEmpty) {
                  return SizedBox.shrink();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    final notificationId = notification['id']; // Unique ID for deletion

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        notification['status'] == 'accepted'
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color: notification['status'] == 'rejected'
                                            ? Colors.green
                                            : Colors.red,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'From: ${notification['senderEmail']}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Status: ${notification['status']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  if (notification['status'] == 'accepted') ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      '🎉 Congratulations! Please email ${notification['senderEmail']} for more details.',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: (){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => EmailScreen()));
                                        },
                                        child: Center(
                                          child: Text("Send Gmail"),
                                        )
                                    )
                                  ],
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      _formatTimestamp(notification['timestamp']),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _showDeleteDialog(context, notificationId),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Applications Future
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: applications,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return SizedBox.shrink();
                }

                final appList = snapshot.data!;
                final pendingApplications = appList.where((applications) => applications['status'] == "pending").toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: pendingApplications.length,
                  itemBuilder: (context, index) {
                    final application = appList[index];
                    final applicationId = application['id'];
                    final applicantEmail = application['applicantEmail'];
                    final appliedAt = application['appliedAt'] as Timestamp;
                    final formattedDate = DateFormat('MMM dd, yyyy - hh:mm a').format(appliedAt.toDate());

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Applicant: ${application['applicantEmail']}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Applied on: $formattedDate',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () => _acceptApplication(applicationId, applicantEmail),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                  child: const Text('Accept'),
                                ),
                                ElevatedButton(
                                  onPressed: () => _rejectApplication(applicationId, applicantEmail),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  child: const Text('Reject'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ApplicationHistory>>(
              stream: _applicationHistoryService.fetchApplicationHistory(userEmail),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No application history found.'));
                }

                // Now displaying the data fetched from Firestore
                List<ApplicationHistory> applicationHistory = snapshot.data!;

                List<ApplicationHistory> acceptedHistory = applicationHistory
                .where((history) => history.status == "accepted")
                .toList();

                return ListView.builder(
                  itemCount: acceptedHistory.length,
                  itemBuilder: (context, index) {
                    ApplicationHistory history = acceptedHistory[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                      child: ListTile(
                        title: Text(history.applicantEmail),
                        subtitle: Text("Pending", style: TextStyle(color: Colors.orange),),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  final List<Map<String, dynamic>> applications =
                                  await _applicationService.fetchApplicationsForUser();

                                  print("Fetching applications for ${history.offeredBy}");
                                  print("Fetched applications: $applications");

                                  Map<String, dynamic>? foundApplication;

                                  foundApplication = applications.firstWhere(
                                        (element) =>
                                    (element['offeredBy'] == history.offeredBy ||
                                        element['applicantEmail'] == history.applicantEmail) &&
                                        element['jobId'] != null,
                                    orElse: () => {},
                                  );

                                  if (foundApplication != null) {
                                    print("Job ID: ${foundApplication['jobId']}");
                                    print("Offered By: ${foundApplication['offeredBy']}");
                                    print("Applicant Email: ${foundApplication['applicantEmail']}");

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => PaymentScreen(
                                          applicantEmail: history.applicantEmail,
                                          jobId: foundApplication!['jobId'],
                                          applicationHistoryId: history.id ,
                                        ),
                                      ),
                                    );
                                  } else {
                                    print("No matching application found for ${history.applicantEmail}");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("No matching application found.")),
                                    );
                                  }
                                } catch (e) {
                                  print("Error navigating to PaymentScreen: $e");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Error processing payment.")),
                                  );
                                }
                              },
                              child: Text("Pay"),
                            ),

                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async{
                                await _applicationHistoryService.deleteApplicationHistory(history.id);
                              },
                            ),
                          ],
                        )
                      ),
                    );
                  },
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}
