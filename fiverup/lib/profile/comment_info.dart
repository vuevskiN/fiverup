import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiverup/service/comment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({Key? key}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late Future<List<Map<String, dynamic>>> _allComments;

  @override
  void initState() {
    super.initState();
    _allComments = getCommentsById();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Go back', style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _allComments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error fetching comments: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No comments available.'));
          }

          final currentUserEmail =
          FirebaseAuth.instance.currentUser?.email?.trim().toLowerCase();

          final filteredComments = snapshot.data!
              .where((comment) =>
          comment['userEmail']?.trim().toLowerCase() == currentUserEmail)
              .toList();

          if (filteredComments.isEmpty) {
            return const Center(child: Text('No comments available for you.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: filteredComments.length,
              itemBuilder: (context, index) {
                final comment = filteredComments[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(comment['comment'] ?? '', style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        RatingBarIndicator(
                          rating: (comment['rating'] ?? 0).toDouble(),
                          itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                          itemCount: 5,
                          itemSize: 20.0,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Posted on: ${comment['timestamp'].toDate()}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
