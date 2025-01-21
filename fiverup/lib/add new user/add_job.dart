import 'package:flutter/material.dart';
import '../models/job.dart';
import '../service/job_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddJobScreen extends StatefulWidget {
  final Job? jobToEdit; // Pass the job to edit, if any
  final String? jobId; // Pass the job ID to edit, if any

  AddJobScreen({this.jobToEdit, this.jobId});

  @override
  _AddJobScreenState createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _hourlyRateController = TextEditingController();

  final JobService jobService = JobService();

  @override
  void initState() {
    super.initState();

    // Pre-fill fields if editing a job
    if (widget.jobToEdit != null) {
      _titleController.text = widget.jobToEdit!.title;
      _descriptionController.text = widget.jobToEdit!.description;
      _hourlyRateController.text = widget.jobToEdit!.hourlyRate.toString();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _hourlyRateController.dispose();
    super.dispose();
  }

  Future<void> _addOrUpdateJob() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      try {
        // Assign a job ID for new jobs
        final jobId = widget.jobId ?? jobService.jobsCollection.doc().id;

        final job = Job(
          jobId: jobId,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          hourlyRate: double.parse(_hourlyRateController.text.trim()),
          createdBy: widget.jobToEdit?.createdBy ?? user.email,
        );

        if (widget.jobToEdit != null) {
          // Update the existing job
          await jobService.updateJob(jobId, job);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Job updated successfully!')),
          );
        } else {
          // Add a new job
          await jobService.addJob(job);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Job added successfully!')),
          );
        }

        Navigator.pop(context); // Navigate back to the previous screen
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save job: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.jobToEdit != null ? 'Edit Job' : 'Add Job'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Job Title'),
                validator: (value) =>
                value == null || value.trim().isEmpty ? 'Enter a job title' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Job Description'),
                validator: (value) =>
                value == null || value.trim().isEmpty ? 'Enter a job description' : null,
              ),
              TextFormField(
                controller: _hourlyRateController,
                decoration: const InputDecoration(labelText: 'Hourly Rate'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final rate = double.tryParse(value ?? '');
                  if (rate == null || rate <= 0) {
                    return 'Enter a valid hourly rate';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addOrUpdateJob,
                child: Text(widget.jobToEdit != null ? 'Update Job' : 'Add Job'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
