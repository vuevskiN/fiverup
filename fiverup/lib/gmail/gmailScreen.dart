import 'package:flutter/material.dart';
import 'gmail_auth_service.dart';

class EmailScreen extends StatefulWidget {
  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final GmailService _gmailService = GmailService();
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  String? loggedInUserEmail; // Store logged-in user's email

  @override
  void initState() {
    super.initState();
    _fetchUserEmail();
  }

  void _fetchUserEmail() async {
    await _gmailService.getAccessToken(); // Ensure the user is signed in
    setState(() {
      loggedInUserEmail = _gmailService.getLoggedInUserEmail();
    });
  }

  void _sendEmail() async {
    String recipient = _recipientController.text;
    String subject = _subjectController.text;
    String body = _bodyController.text;

    if (recipient.isEmpty || subject.isEmpty || body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    bool success = await _gmailService.sendEmail(recipient, subject, body);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Email sent successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to send email")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Send Email")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (loggedInUserEmail != null)
              Text("Logged in as: $loggedInUserEmail", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              controller: _recipientController,
              decoration: InputDecoration(labelText: "Recipient Email"),
            ),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: "Subject"),
            ),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(labelText: "Email Body"),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendEmail,
              child: Text("Send Email"),
            ),

            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await _gmailService.signOut();
                _fetchUserEmail(); // Refresh UI after sign-out
              },
            )
          ],
        ),
      ),
    );
  }
}
