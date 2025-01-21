import 'package:firebase_auth/firebase_auth.dart';

class Job {
  final String jobId;
  final String title;
  final String description;
  final double hourlyRate;
  final String? createdBy;

  Job({
    required this.jobId,
    required this.title,
    required this.description,
    required this.hourlyRate,
    this.createdBy,
  });

  factory Job.fromFirestore(String id, Map<String, dynamic> data) {
    return Job(
      jobId: id,
      title: data['title'],
      description: data['description'],
      hourlyRate: data['hourlyRate'],
      createdBy: data['createdBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'hourlyRate': hourlyRate,
      'createdBy': createdBy,
    };
  }

}



// Pre-made jobs
final List<Job> preMadeJobs = [
  Job(
    title: "Web Developer",
    description: "Looking for a skilled developer to build a website.",
    hourlyRate: 25.0,
    createdBy: 'mars@gmail.com', jobId: '1',
  ),
  Job(
    title: "Graphic Designer",
    description: "Need a designer for logo and branding materials.",
    hourlyRate: 20.0, createdBy: 'nikita@gmail.com', jobId: '2',
  ),
];
