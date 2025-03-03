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
  final List<Map<String, dynamic>> comments;
  final List<String>? requiredSkills;
  final List<String>? tags;
  final String? location;

  Job({
    required this.jobId,
    required this.title,
    required this.description,
    required this.hourlyRate,
    this.createdBy,
    required this.seeking,
    required this.offering,
    this.dueDate,
    this.comments = const [],
     this.requiredSkills,
     this.tags,
     this.location,
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
      comments: data['comments'] != null ? List<Map<String, dynamic>>.from(data['comments']) : [],
      requiredSkills: List<String>.from(data['requiredSkills'] ?? []),
      location: data['location'] ?? 'Remote'
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
      'comments': comments,
      'requiredSkills' : requiredSkills,
      'tags' : tags,
      'location' : location
    };
  }
}
