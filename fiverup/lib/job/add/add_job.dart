import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the selected date
import '../../models/job.dart';
import '../../service/job_service.dart';
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

  bool _isOffering = false;
  bool _isSeeking = true; // Initially set seeking to true
  DateTime? _dueDate; // The new field for due date

  final JobService jobService = JobService();

  @override
  void initState() {
    super.initState();

    // Pre-fill fields if editing a job
    if (widget.jobToEdit != null) {
      _titleController.text = widget.jobToEdit!.title;
      _descriptionController.text = widget.jobToEdit!.description;
      _hourlyRateController.text = widget.jobToEdit!.hourlyRate.toString();
      _isOffering = widget.jobToEdit!.offering;
      _isSeeking = widget.jobToEdit!.seeking;
      _dueDate = widget.jobToEdit!.dueDate; // Set due date if editing
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _hourlyRateController.dispose();
    super.dispose();
  }

  void _onOfferingChanged(bool value) {
    setState(() {
      if (value) {
        _isSeeking = false; // If offering is true, set seeking to false
      }
      _isOffering = value;
    });
  }

  void _onSeekingChanged(bool value) {
    setState(() {
      if (value) {
        _isOffering = false; // If seeking is true, set offering to false
      }
      _isSeeking = value;
    });
  }

  Future<void> _addOrUpdateJob() async {
    if (_formKey.currentState!.validate() && (_isSeeking || _isOffering) && _dueDate != null) {
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
          seeking: _isSeeking,
          offering: _isOffering,
          dueDate: _dueDate!, // Pass the selected due date
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields must be filled, including the due date, and at least one type (Seeking or Offering) must be selected.')),
      );
    }
  }

  Future<void> _pickDueDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)), // Limit due date to within 1 year
    );

    if (pickedDate != null) {
      // If the date is picked, now allow the user to pick a time
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dueDate ?? DateTime.now()), // Default time is current time if no previous due date
      );

      if (pickedTime != null) {
        // Combine the selected date and time into a DateTime object
        setState(() {
          _dueDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Offering:'),
                  Switch(
                    value: _isOffering,
                    onChanged: _onOfferingChanged,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Seeking:'),
                  Switch(
                    value: _isSeeking,
                    onChanged: _onSeekingChanged,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Due Date:'),
                  TextButton(
                    onPressed: _pickDueDate,
                    child: Text(
                      _dueDate == null
                          ? 'Select Date'
                          : DateFormat('yyyy-MM-dd').format(_dueDate!),
                    ),
                  ),
                ],
              ),
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
