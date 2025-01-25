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
    _userEmails = fetchUserEmails(); // Fetch user emails using the updated service
  }

  void _submitComment() async {
    if (_selectedUserEmail == null || _commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a user and write a comment.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('comments').add({
        'comment': _commentController.text,
        'userEmail': _selectedUserEmail,
        'timestamp': FieldValue.serverTimestamp(),
      });
      setState(() {
        _commentController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error submitting comment')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24), // Added margins for the card
      decoration: BoxDecoration(
        color: Color(0xFFF3F3F3), // Light background for the comment section
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, spreadRadius: 2)], // Soft shadow for depth
      ),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          Text(
            'User Comments',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 12),
          FutureBuilder<List<String>>(
            future: _userEmails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No users available');
              }

              return DropdownButton<String>(
                value: _selectedUserEmail,
                hint: Text('Select user'),
                isExpanded: true,
                onChanged: (newValue) {
                  setState(() {
                    _selectedUserEmail = newValue;
                  });
                },
                items: snapshot.data!
                    .map<DropdownMenuItem<String>>(
                      (email) => DropdownMenuItem<String>(
                    value: email,
                    child: Text(email),
                  ),
                )
                    .toList(),
              );
            },
          ),
          SizedBox(height: 12),
          TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: 'Write a comment...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12), // Smaller padding
            ),
            maxLines: 3, // Make the text field smaller by limiting the lines
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitComment,
            child: Text('Submit Comment'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF0D1B2A),
              foregroundColor: Colors.white,// Consistent color scheme
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}
