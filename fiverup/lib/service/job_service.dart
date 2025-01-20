import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/job.dart';

class JobService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new job
  Future<void> addJob(Job job) async {
    await _firestore.collection('jobs').add({
      'title': job.title,
      'description': job.description,
      'hourlyRate': job.hourlyRate,
    });
  }


  Stream<List<Job>> getAllJobs() {
    return _firestore.collection('jobs').snapshots().map((snapshot) {
      final userJobs = snapshot.docs.map((doc) {
        final data = doc.data();
        return Job(
          title: data['title'],
          description: data['description'],
          hourlyRate: data['hourlyRate'],
        );
      }).toList();
      return [...preMadeJobs, ...userJobs];
    });
  }
}
