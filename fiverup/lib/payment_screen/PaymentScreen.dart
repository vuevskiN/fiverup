import 'package:fiverup/service/job_service.dart';
import 'package:flutter/material.dart';
import '../gmail/gmail_auth_service.dart';
import '../service/applicationHistory_service.dart'; // Import the service

class PaymentScreen extends StatefulWidget {
  final String applicantEmail;
  final String jobId;
  final String? applicationHistoryId; // Add this

  PaymentScreen({
    required this.applicantEmail,
    required this.jobId,
    this.applicationHistoryId, // Initialize it
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _myEmailController = TextEditingController();
  TextEditingController _jobTitleController = TextEditingController();
  TextEditingController _jobDataTitleController = TextEditingController();
  TextEditingController _recipientEmailController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  final GmailService _gmailService = GmailService();
  String? loggedInUserEmail;
  JobService _jobService = JobService();
  Map<String, dynamic>? jobData;
  final ApplicationHistoryService _applicationHistoryService =
  ApplicationHistoryService(); // Create an instance

  @override
  void initState() {
    super.initState();
    _recipientEmailController.text = widget.applicantEmail;
    _fetchUserEmail();
    _fetchJobDetails();
  }

  void _fetchJobDetails() async {
    try {
      final job = await _jobService.getJobById(widget.jobId);
      if (job != null) {
        setState(() {
          jobData = job.toMap();
          // Pre-fill the amount with the hourly rate
          _amountController.text = jobData?['hourlyRate'] != null
              ? jobData!['hourlyRate'].toString()
              : '';
          // Pre-fill the Job Title
          _jobTitleController.text = jobData?['title'] ?? '';
          // Pre-fill the Job Data Title
          _jobDataTitleController.text = jobData?['description'] ?? '';
        });
      } else {
        print("Job not found with ID: ${widget.jobId}");
      }
    } catch (e) {
      print("Error fetching job details: $e");
    }
  }

  void _fetchUserEmail() async {
    await _gmailService.getAccessToken();
    String? userEmail = _gmailService.getLoggedInUserEmail();
    if (userEmail != null) {
      setState(() {
        loggedInUserEmail = userEmail;
        _myEmailController.text = loggedInUserEmail!;
      });
    } else {
      print("Error: Could not retrieve logged-in user's email.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                readOnly: true,
                controller: _myEmailController,
                decoration: InputDecoration(labelText: 'Your Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                readOnly: true,
                controller: _jobDataTitleController,
                decoration: InputDecoration(labelText: 'Job Data Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the job data title';
                  }
                  return null;
                },
              ),
              TextFormField(
                readOnly: true,
                controller: _jobTitleController,
                decoration: InputDecoration(labelText: 'Job Title'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the job title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _recipientEmailController,
                decoration: InputDecoration(labelText: 'Recipient Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                readOnly: true,
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Payment Amount'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _processPayment();
                  }
                },
                child: Text('Make Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _processPayment() async {
    String recipientEmail = _recipientEmailController.text;
    String amount = _amountController.text;
    String subject = "Payment Confirmation - FiverUp";
    String body = "Dear Recipient,\n\n"
        "This email confirms that a payment has been processed through FiverUp.\n\n"
        "Payment Details:\n"
        "- Sender: ${_myEmailController.text}\n"
        "- Job Title: ${_jobTitleController.text}\n"
        "- Job Details: ${_jobDataTitleController.text}\n"
        "- Amount: ${_amountController.text}\n\n"
        "Please log in to your bank account to review the complete transaction details.\n\n"
        "If you have any questions or require further assistance, please do not hesitate to contact our support team.\n\n"
        "Thank you for using FiverUp.\n\n"
        "Sincerely,\n"
        "The FiverUp Team";




    bool emailSent = await _gmailService.sendEmail(recipientEmail, subject, body);

    if (emailSent) {
      // Delete the application history entry
      if (widget.applicationHistoryId != null) {
        await _applicationHistoryService
            .deleteApplicationHistory(widget.applicationHistoryId!);
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Payment'),
            content: Text(
              'Payment and email notification sent successfully!\n'
                  'From: ${_myEmailController.text}\n'
                  'To: ${_recipientEmailController.text}\n'
                  'Amount: ${_amountController.text}',
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Navigate back
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Payment Error'),
            content: Text('Failed to send payment notification email.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}