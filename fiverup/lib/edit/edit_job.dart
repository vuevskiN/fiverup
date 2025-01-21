import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/job.dart';
import '../service/job_service.dart';

class EditJobScreen extends StatefulWidget {
  final Job job;

  EditJobScreen({required this.job});

  @override
  _EditJobScreenState createState() => _EditJobScreenState();
}

class _EditJobScreenState extends State<EditJobScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _hourlyRateController;
  late String _createdBy; // The creator's email

  final JobService jobService = JobService();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.job.title);
    _descriptionController = TextEditingController(text: widget.job.description);
    _hourlyRateController = TextEditingController(text: widget.job.hourlyRate.toString());
    _createdBy = widget.job.createdBy ?? _getCurrentUserEmail();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _hourlyRateController.dispose();
    super.dispose();
  }

  // Get the current user's email from FirebaseAuth
  String _getCurrentUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null ? user.email ?? 'guest@example.com' : 'guest@example.com';
  }

  // Save the updated job
  void _saveChanges() {
    final updatedJob = Job(
      jobId: widget.job.jobId, // Include the jobId here
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      hourlyRate: double.tryParse(_hourlyRateController.text.trim()) ?? widget.job.hourlyRate,
      createdBy: _createdBy,
    );

    jobService.updateJob(widget.job.jobId, updatedJob).then((_) {
      Navigator.pop(context); // Navigate back after saving
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job updated successfully!')),
      );
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update job: $e')),
      );
    });
  }

  // Delete the job
  void _deleteJob() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Job'),
          content: const Text('Are you sure you want to delete this job?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                jobService.deleteJob(widget.job.jobId).then((_) {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Navigate back after deletion
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Job deleted successfully!')),
                  );
                }).catchError((e) {
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete job: $e')),
                  );
                });
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Job'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Job Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Job Description'),
            ),
            TextField(
              controller: _hourlyRateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Hourly Rate'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Save Changes'),
                ),
                ElevatedButton(
                  onPressed: _deleteJob,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Delete Job'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
