import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

class ApplicationHistory {
  final String id;
  final String applicantEmail;
  final String status; // "Accepted" or "Rejected"
  final firestore.Timestamp appliedAt;
  final firestore.Timestamp decisionAt;
  final String? offeredBy;

  ApplicationHistory({
    required this.id,
    required this.applicantEmail,
    required this.status,
    required this.appliedAt,
    required this.decisionAt,
    this.offeredBy,
  });

  factory ApplicationHistory.fromMap(Map<String, dynamic> data, String id) {
    return ApplicationHistory(
      id: id,
      applicantEmail: data['applicantEmail'] ?? '',
      status: data['status'] ?? 'pending',
      appliedAt: data['appliedAt'] ?? firestore.Timestamp.now(),
      decisionAt: data['decisionAt'] ?? firestore.Timestamp.now(),
      offeredBy: data['offeredBy'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'applicantEmail': applicantEmail,
      'status': status,
      'appliedAt': appliedAt,
      'decisionAt': decisionAt,
      'offeredBy': offeredBy,
    };
  }
}