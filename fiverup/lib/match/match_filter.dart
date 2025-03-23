import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../models/job.dart';
import '../service/applicationHistory_service.dart';
import '../service/application_service.dart';
import '../service/job_service.dart';
import '../service/notification_service.dart';

class JobFilterScreen extends StatefulWidget {
  final Profile profile;

  const JobFilterScreen({Key? key, required this.profile}) : super(key: key);

  @override
  _JobFilterScreenState createState() => _JobFilterScreenState();
}

class _JobFilterScreenState extends State<JobFilterScreen> {
  final JobService _jobService = JobService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Recommendations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<Job>>(
          stream: _jobService.getAllJobs(),  // Stream that fetches jobs
          builder: (context, snapshot) {
            // Handle loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Handle error state
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            // Handle empty data state
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No jobs available at the moment.'),
              );
            }

            List<Job> jobs = snapshot.data!;  // List of jobs fetched

            // Filter the jobs based on user's profile (e.g., matching location, skills, and profession)
            List<Job> filteredJobs = jobs.where((job) {
              // Filter jobs based on the profile's profession
              bool differentUsers = job.createdBy != widget.profile.id;

              bool matchesProfession = job.title.toLowerCase().contains(widget.profile.profession.toLowerCase());

              // Filter jobs based on matching skills
              bool matchesSkills = widget.profile.skills?.any((skill) => job.requiredSkills?.contains(skill) ?? false) ?? false;

              // All conditions must be true for the job to match
              return (matchesProfession || matchesSkills) && differentUsers;
            }).toList();

            // If no jobs match the criteria, show a message
            if (filteredJobs.isEmpty) {
              return const Center(
                child: Text('No matching jobs found for your profile.'),
              );
            }

            return ListView.builder(
              itemCount: filteredJobs.length,
              itemBuilder: (context, index) {
                final job = filteredJobs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(job.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hourly Rate: \$${job.hourlyRate.toStringAsFixed(2)}'),
                        const SizedBox(height: 4),
                        Text('Seeking: ${job.seeking}'),
                        const SizedBox(height: 4),
                        Text('Location: ${job.location ?? 'Not Specified'}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () async {

                      if (job.seeking) {
                        final applicationHistoryService = ApplicationHistoryService();
                        final notificationService = NotificationService();
                        final currentUserEmail = FirebaseAuth.instance
                            .currentUser!.email!;

                        await applicationHistoryService.logApplicationDecision(
                          job.createdBy!,
                          'accepted',
                          Timestamp.now(),
                          currentUserEmail,
                        );

                        await notificationService.sendNotification(
                          receiverEmail: job.createdBy!,
                          senderEmail: currentUserEmail,
                          status: 'accepted',
                        );
                      }

                       if(job.offering) {
                        final applicationService = ApplicationService();
                        final currentUser = FirebaseAuth.instance.currentUser;

                        await applicationService.applyForJob(
                            job.jobId, job.createdBy as String,
                            job.hourlyRate,
                            job.title);
                      }


                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(

                        const SnackBar(content: Text('You have applied for the job.')),

                        );

                        },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
