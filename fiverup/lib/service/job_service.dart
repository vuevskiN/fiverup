import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/job.dart';

class JobService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addJob(Job job) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('jobs').add({
        'title': job.title,
        'description': job.description,
        'hourlyRate': job.hourlyRate,
        'createdBy': user.email,
        'seeking': job.seeking,
        'offering': job.offering,
        'dueDate': job.dueDate,
        'comments': [],
        'requiredSkills': job.requiredSkills ?? [],
        'tags': job.tags ?? [],
        'location': job.location ?? 'Remote',
      });
    }
  }

  Future<void> updateJob(String jobId, Job updatedJob) async {
    await _firestore.collection('jobs').doc(jobId).update({
      'title': updatedJob.title,
      'description': updatedJob.description,
      'hourlyRate': updatedJob.hourlyRate,
      'seeking': updatedJob.seeking,
      'offering': updatedJob.offering,
      'dueDate': updatedJob.dueDate,
      'requiredSkills': updatedJob.requiredSkills ?? [],
      'tags': updatedJob.tags ?? [],
      'location': updatedJob.location ?? 'Remote',
    });
  }

  // Delete a job
  Future<void> deleteJob(String jobId) async {
    await _firestore.collection('jobs').doc(jobId).delete();
  }

  Stream<List<Job>> getAllJobs() {
    return _firestore.collection('jobs').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Job.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<Job?> getJobById(String jobId) async {
    DocumentSnapshot doc = await _firestore.collection('jobs').doc(jobId).get();
    if (doc.exists) {
      return Job.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Add a comment to a job
  Future<void> addCommentToJob(String jobId, String commentText, String userEmail) async {
    try {
      final comment = {
        'userEmail': userEmail,
        'comment': commentText,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('jobs').doc(jobId).update({
        'comments': FieldValue.arrayUnion([comment]),
      });
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  final CollectionReference jobsCollection =
  FirebaseFirestore.instance.collection('jobs');

}
