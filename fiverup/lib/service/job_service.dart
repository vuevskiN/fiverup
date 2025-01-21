import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/job.dart';

class JobService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add a new job
  Future<void> addJob(Job job) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('jobs').add({
        'title': job.title,
        'description': job.description,
        'hourlyRate': job.hourlyRate,
        'createdBy': user.email, // Store the user's email as the creator
      });
    }
  }

  // Update an existing job
  Future<void> updateJob(String jobId, Job updatedJob) async {
    await _firestore.collection('jobs').doc(jobId).update({
      'title': updatedJob.title,
      'description': updatedJob.description,
      'hourlyRate': updatedJob.hourlyRate,
    });
  }

  // Delete a job
  Future<void> deleteJob(String jobId) async {
    await _firestore.collection('jobs').doc(jobId).delete();
  }

  // Fetch all jobs and stream them
  Stream<List<Job>> getAllJobs() {
    return _firestore.collection('jobs').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Job.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  final CollectionReference jobsCollection =
  FirebaseFirestore.instance.collection('jobs');
}
