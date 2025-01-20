import 'package:flutter/material.dart';
import '../models/job.dart';
import '../service/job_service.dart';

class AddJobScreen extends StatefulWidget {
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
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _hourlyRateController.dispose();
    super.dispose();
  }

  void _addJob() {
    if (_formKey.currentState!.validate()) {
      final job = Job(
        title: _titleController.text,
        description: _descriptionController.text,
        hourlyRate: double.parse(_hourlyRateController.text),
      );
      jobService.addJob(job).then((_) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Job')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Job Title'),
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Job Description'),
                validator: (value) => value!.isEmpty ? 'Enter a description' : null,
              ),
              TextFormField(
                controller: _hourlyRateController,
                decoration: InputDecoration(labelText: 'Hourly Rate'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty || double.tryParse(value) == null
                    ? 'Enter a valid rate'
                    : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addJob,
                child: Text('Add Job'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
