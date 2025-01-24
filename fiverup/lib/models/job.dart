import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  final String jobId;
  final String title;
  final String description;
  final double hourlyRate;
  final String? createdBy;
  final bool seeking;
  final bool offering;
  final DateTime? dueDate;
  final List<Map<String, dynamic>> comments; // New field for comments

  Job({
    required this.jobId,
    required this.title,
    required this.description,
    required this.hourlyRate,
    this.createdBy,
    required this.seeking,
    required this.offering,
    this.dueDate,
    this.comments = const [], // Initialize with an empty list
  }) {
    if (seeking == offering) {
      throw ArgumentError('Both seeking and offering cannot be true at the same time.');
    }
  }

  factory Job.fromFirestore(String id, Map<String, dynamic> data) {
    return Job(
      jobId: id,
      title: data['title'],
      description: data['description'],
      hourlyRate: data['hourlyRate'],
      createdBy: data['createdBy'],
      seeking: data['seeking'] ?? true,
      offering: data['offering'] ?? false,
      dueDate: data['dueDate'] != null ? (data['dueDate'] as Timestamp).toDate() : null,
      comments: data['comments'] != null ? List<Map<String, dynamic>>.from(data['comments']) : [], // Fetch comments
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'hourlyRate': hourlyRate,
      'createdBy': createdBy,
      'seeking': seeking,
      'offering': offering,
      'dueDate': dueDate,
      'comments': comments, // Store comments as a list of maps
    };
  }
}
