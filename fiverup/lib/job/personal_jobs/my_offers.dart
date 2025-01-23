import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/job.dart';

class MyOffersPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Job>> _fetchSeekingJobs() async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection('jobs')
        .where('offering', isEqualTo: true)
        .where('createdBy', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get();

    return querySnapshot.docs
        .map((doc) => Job.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Jobs'),
      ),
      body: FutureBuilder<List<Job>>(
        future: _fetchSeekingJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No jobs found.'));
          }

          final jobs = snapshot.data!;
          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return Card(
                child: ListTile(
                  title: Text(job.title),
                  subtitle: Text(job.description),
                  trailing: Text('\$${job.hourlyRate.toStringAsFixed(2)} / hr'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
