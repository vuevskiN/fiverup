import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/job.dart';
import '../../service/job_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddJobScreen extends StatefulWidget {
  final Job? jobToEdit;
  final String? jobId;

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
  bool _isSeeking = true;
  DateTime? _dueDate;

  final JobService jobService = JobService();

  @override
  void initState() {
    super.initState();

    if (widget.jobToEdit != null) {
      _titleController.text = widget.jobToEdit!.title;
      _descriptionController.text = widget.jobToEdit!.description;
      _hourlyRateController.text = widget.jobToEdit!.hourlyRate.toString();
      _isOffering = widget.jobToEdit!.offering;
      _isSeeking = widget.jobToEdit!.seeking;
      _dueDate = widget.jobToEdit!.dueDate;
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
    if (_formKey.currentState!.validate() && (_isSeeking || _isOffering) && _dueDate != null) {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      try {
        final jobId = widget.jobId ?? jobService.jobsCollection.doc().id;

        final job = Job(
          jobId: jobId,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          hourlyRate: double.parse(_hourlyRateController.text.trim()),
          createdBy: widget.jobToEdit?.createdBy ?? user.email,
          seeking: _isSeeking,
          offering: _isOffering,
          dueDate: _dueDate!,
        );

        if (widget.jobToEdit != null) {
          await jobService.updateJob(jobId, job);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Job updated successfully!')),
          );
        } else {
          await jobService.addJob(job);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Job added successfully!')),
          );
        }

        Navigator.pop(context);
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
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dueDate ?? DateTime.now()),
      );

      if (pickedTime != null) {
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
          backgroundColor: const Color(0xFF0D1B2A),
          title: Text(
            widget.jobToEdit != null ? 'Edit Job' : 'Add Job',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),

        body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(_titleController, 'Job Title'),
                _buildTextField(_descriptionController, 'Job Description'),
                _buildTextField(_hourlyRateController, 'Hourly Rate', isNumber: true),
                const SizedBox(height: 16),
                _buildSwitchRow('Offering:', _isOffering, (value) {
                  setState(() {
                    _isOffering = value;
                    if (value) _isSeeking = false;
                  });
                }),
                _buildSwitchRow('Seeking:', _isSeeking, (value) {
                  setState(() {
                    _isSeeking = value;
                    if (value) _isOffering = false;
                  });
                }),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Due Date:', style: TextStyle(fontSize: 16)),
                    TextButton(
                      onPressed: _pickDueDate,
                      child: Text(
                        _dueDate == null
                            ? 'Select Date'
                            : DateFormat('yyyy-MM-dd HH:mm').format(_dueDate!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _addOrUpdateJob,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D1B2A),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: Text(widget.jobToEdit != null ? 'Update Job' : 'Add Job', style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        if (isNumber && double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }

  Widget _buildSwitchRow(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
