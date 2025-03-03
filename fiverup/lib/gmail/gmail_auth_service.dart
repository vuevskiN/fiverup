import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GmailService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/gmail.send',
    ],
  );

  GoogleSignInAccount? _currentUser; // Store the current logged-in user

  Future<String?> getAccessToken() async {
    if (_currentUser == null) {
      _currentUser = await _googleSignIn.signIn();
    }
    final GoogleSignInAuthentication? googleAuth = await _currentUser?.authentication;
    return googleAuth?.accessToken;
  }

  // ✅ New method to get logged-in user's email
  String? getLoggedInUserEmail() {
    return _currentUser?.email;
  }

  Future<bool> sendEmail(String recipient, String subject, String body) async {
    String? accessToken = await getAccessToken();
    if (accessToken == null) {
      print("❌ Error: No Access Token");
      return false;
    }

    String emailContent = """
From: ${_currentUser?.email}  // Show sender's email
To: $recipient
Subject: $subject

$body
    """;

    String base64Email = base64UrlEncode(utf8.encode(emailContent));

    var url = Uri.parse("https://www.googleapis.com/gmail/v1/users/me/messages/send");
    var response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"raw": base64Email}),
    );

    if (response.statusCode == 200) {
      print("✅ Email sent successfully!");
      return true;
    } else {
      print("❌ Error sending email: ${response.body}");
      return false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _currentUser = null; // Clear the stored user
  }
}
