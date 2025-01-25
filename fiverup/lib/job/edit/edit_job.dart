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

  String _getCurrentUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null ? user.email ?? 'guest@example.com' : 'guest@example.com';
  }

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

  void _saveChanges() {
    if (!_validateInputs()) return;

    final updatedJob = Job(
      jobId: widget.job.jobId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      hourlyRate: double.tryParse(_hourlyRateController.text.trim()) ?? widget.job.hourlyRate,
      createdBy: _createdBy,
      seeking: _seeking,
      offering: _offering,
      dueDate: _dueDate,
    );

    jobService.updateJob(widget.job.jobId, updatedJob).then((_) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job updated successfully!')),
      );
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update job: $e')),
      );
    });
  }

  void _deleteJob() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Job'),
          content: const Text('Are you sure you want to delete this job?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                jobService.deleteJob(widget.job.jobId).then((_) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Job deleted successfully!')),
                  );
                }).catchError((e) {
                  Navigator.of(context).pop();
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
        backgroundColor: Color(0xFF0D1B2A), // Dark background color
        foregroundColor: Colors.white, // White text color
        title: const Text('Edit Job'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Job Title', _titleController),
            const SizedBox(height: 12),
            _buildTextField('Job Description', _descriptionController),
            const SizedBox(height: 12),
            _buildTextField('Hourly Rate', _hourlyRateController, keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            _buildSwitchRow('Seeking: ', _seeking, _onSeekingChanged),
            const SizedBox(height: 12),
            _buildSwitchRow('Offering: ', _offering, _onOfferingChanged),
            const SizedBox(height: 20),
            _buildDueDatePicker(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildButton('Save Changes', Colors.green, _saveChanges),
                _buildButton('Delete Job', Colors.red, _deleteJob),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build text fields
  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }

  // Helper function to build switch rows for "Seeking" and "Offering"
  Widget _buildSwitchRow(String label, bool value, Function(bool) onChanged) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  // Helper function to build the due date picker
  Widget _buildDueDatePicker() {
    return Row(
      children: [
        const Text('Due Date: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        TextButton(
          onPressed: _pickDueDate,
          child: Text(
            _dueDate != null ? DateFormat('yyyy-MM-dd').format(_dueDate!) : 'Pick a date',
            style: TextStyle(color: Colors.blueAccent),
          ),
        ),
      ],
    );
  }

  // Helper function to build styled buttons
  Widget _buildButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }
}
