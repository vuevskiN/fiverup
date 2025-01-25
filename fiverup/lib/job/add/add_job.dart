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
        backgroundColor: const Color(0xFF0D1B2A), // AppBar color
        foregroundColor: Colors.white, // AppBar text color
        title: Text(widget.jobToEdit != null ? 'Edit Job' : 'Add Job'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Job Title Field
              _buildTextField(_titleController, 'Job Title'),

              // Job Description Field
              _buildTextField(_descriptionController, 'Job Description'),

              // Hourly Rate Field
              _buildTextField(_hourlyRateController, 'Hourly Rate', isNumber: true),

              const SizedBox(height: 16),

              // Offering Toggle
              _buildSwitchRow('Offering:', _isOffering, _onOfferingChanged),

              // Seeking Toggle
              _buildSwitchRow('Seeking:', _isSeeking, _onSeekingChanged),

              const SizedBox(height: 16),

              // Due Date Field
              Row(
                children: [
                  const Text('Due Date:', style: TextStyle(fontSize: 16)),
                  TextButton(
                    onPressed: _pickDueDate,
                    child: Text(
                      _dueDate == null
                          ? 'Select Date'
                          : DateFormat('yyyy-MM-dd').format(_dueDate!),
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _addOrUpdateJob,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D1B2A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    widget.jobToEdit != null ? 'Update Job' : 'Add Job',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) => value == null || value.trim().isEmpty ? 'Enter a $label' : null,
    );
  }

  // Helper method to build switch rows
  Widget _buildSwitchRow(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
