import 'package:cloud_firestore/cloud_firestore.dart';

class EmployerPayment {
  final String id;
  final String employerId; // The logged-in client (Employer)
  final String clientId; // The person being paid
  final double amount;
  final Timestamp timestamp; // Firestore Timestamp for time tracking

  EmployerPayment({
    required this.id,
    required this.employerId,
    required this.clientId,
    required this.amount,
    required this.timestamp,
  });

  // Convert model to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employerId': employerId,
      'clientId': clientId,
      'amount': amount,
      'timestamp': timestamp,
    };
  }

  // Convert Firestore document to EmployerPayment object
  factory EmployerPayment.fromMap(Map<String, dynamic> map, String documentId) {
    return EmployerPayment(
      id: documentId,
      employerId: map['employerId'] ?? '',
      clientId: map['clientId'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }
}
