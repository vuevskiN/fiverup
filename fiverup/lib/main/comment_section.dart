import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentSection extends StatefulWidget {
  const CommentSection({Key? key}) : super(key: key);

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _commentController = TextEditingController();
  String? _selectedUserEmail;
  double _rating = 0;

  Future<List<String>> fetchFilteredUserEmails() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return [];

    final querySnapshot = await _firestore.collection('users').get();
    return querySnapshot.docs
        .map((doc) => doc['email'] as String)
        .where((email) => email != currentUser.email)
        .toList();
  }

  Future<void> submitComment() async {
    if (_selectedUserEmail == null || _commentController.text.isEmpty || _rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a user, write a comment, and provide a rating.')),
      );
      return;
    }

    try {
      await _firestore.collection('comments').add({
        'comment': _commentController.text,
        'userEmail': _selectedUserEmail,
        'rating': _rating,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _commentController.clear();
        _rating = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Comment submitted successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error submitting comment')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 350,
        height: 250,
        margin: EdgeInsets.only(bottom: 30),
        decoration: BoxDecoration(
          color: Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, spreadRadius: 2)],
        ),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('User Comments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(height: 8),
              FutureBuilder<List<String>>(
                future: fetchFilteredUserEmails(),
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
                        .map((email) => DropdownMenuItem(value: email, child: Text(email)))
                        .toList(),
                  );
                },
              ),
              SizedBox(height: 8),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 20,
                itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              SizedBox(height: 8),
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Write a comment...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                maxLines: 2,
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: submitComment,
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0D1B2A),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}