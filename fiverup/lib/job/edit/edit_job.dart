import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/job.dart';
import '../../service/job_service.dart';

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
  late bool _seeking;
  late bool _offering;
  late String _createdBy; // The creator's email
  late DateTime? _dueDate;

  final JobService jobService = JobService();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.job.title);
    _descriptionController = TextEditingController(text: widget.job.description);
    _hourlyRateController = TextEditingController(text: widget.job.hourlyRate.toString());
    _seeking = widget.job.seeking;
    _offering = widget.job.offering;
    _createdBy = widget.job.createdBy ?? _getCurrentUserEmail();
    _dueDate = widget.job.dueDate;
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

  // Validate input fields
  bool _validateInputs() {
    if (_titleController.text.trim().isEmpty) {
      _showError('Job title cannot be empty.');
      return false;
    }
    if (_descriptionController.text.trim().isEmpty) {
      _showError('Job description cannot be empty.');
      return false;
    }
    final hourlyRate = double.tryParse(_hourlyRateController.text.trim());
    if (hourlyRate == null || hourlyRate <= 0) {
      _showError('Hourly rate must be a positive number.');
      return false;
    }
    if (!_seeking && !_offering) {
      _showError('You must select either "Seeking" or "Offering".');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // Save the updated job
  void _saveChanges() {
    if (!_validateInputs()) return;

    final updatedJob = Job(
      jobId: widget.job.jobId, // Include the jobId here
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      hourlyRate: double.tryParse(_hourlyRateController.text.trim()) ?? widget.job.hourlyRate,
      createdBy: _createdBy,
      seeking: _seeking,
      offering: _offering,
      dueDate: _dueDate,
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

  // Update the seeking and offering states to ensure only one is true
  void _onSeekingChanged(bool value) {
    setState(() {
      _seeking = value;
      if (_seeking) _offering = false;
    });
  }

  void _onOfferingChanged(bool value) {
    setState(() {
      _offering = value;
      if (_offering) _seeking = false;
    });
  }

  // Pick a due date using a date picker
  void _pickDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _dueDate) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
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
              children: [
                const Text('Seeking: '),
                Switch(
                  value: _seeking,
                  onChanged: _onSeekingChanged,
                ),
                const Text('Offering: '),
                Switch(
                  value: _offering,
                  onChanged: _onOfferingChanged,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Due Date: '),
                TextButton(
                  onPressed: _pickDueDate,
                  child: Text(
                    _dueDate != null
                        ? DateFormat('yyyy-MM-dd').format(_dueDate!)
                        : 'Pick a date',
                  ),
                ),
              ],
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
