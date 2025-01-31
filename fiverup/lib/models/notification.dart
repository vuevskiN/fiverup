import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String senderEmail;
  final String receiverEmail;
  final String status;
  final Timestamp timestamp; // Change to Timestamp
  final bool isRead;

  NotificationModel({
    required this.senderEmail,
    required this.receiverEmail,
    required this.status,
    required this.timestamp,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderEmail': senderEmail,
      'receiverEmail': receiverEmail,
      'status': status,
      'timestamp': timestamp, // Use Timestamp
      'isRead': isRead,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      senderEmail: map['senderEmail'],
      receiverEmail: map['receiverEmail'],
      status: map['status'],
      timestamp: map['timestamp'], // Ensure it's a Timestamp
      isRead: map['isRead'] ?? false,
    );
  }
}
