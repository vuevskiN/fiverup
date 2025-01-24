import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../service/comment_service.dart';

class CommentSection extends StatefulWidget {
  const CommentSection({Key? key}) : super(key: key);

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  late Future<List<String>> _userEmails;
  TextEditingController _commentController = TextEditingController();
  String? _selectedUserEmail;

  @override
  void initState() {
    super.initState();
    _userEmails = fetchUserEmails();  // Fetch user emails using the updated service
  }

  // Function to submit the comment to Firestore
  void _submitComment() async {
    if (_selectedUserEmail == null || _commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a user and write a comment.')),
      );
      return;
    }

    try {
      // Submit the comment to Firestore under the 'comments' collection
      await FirebaseFirestore.instance.collection('comments').add({
        'userEmail': _selectedUserEmail,
        'comment': _commentController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the text field after submitting
      _commentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Comment submitted successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _userEmails,  // Fetch emails list from the service
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No users found.'));
        }

        final userEmails = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: DropdownButton<String>(
                value: _selectedUserEmail,
                hint: Text('Select a user'),
                isExpanded: true,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedUserEmail = newValue;
                  });
                },
                items: userEmails.map<DropdownMenuItem<String>>((email) {
                  return DropdownMenuItem<String>(
                    value: email,
                    child: Text(email),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Leave a comment',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: _submitComment,
                child: Text('Submit Comment'),
              ),
            ),
          ],
        );
      },
    );
  }
}
