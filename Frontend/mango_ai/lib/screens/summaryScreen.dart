import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SummaryScreen extends StatefulWidget {
  final String content;
  const SummaryScreen({super.key, required this.content});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  String summary = "";
  Future<void> _gmail_summary(String content) async {
    String endpoint =
        "https://mangocloud-2b2gpae35q-uc.a.run.app/mango/gmail/summary";
    try {
      print("Gmail summary running");
      final url = Uri.parse(endpoint);
      Map<String, dynamic> mp = {"user_id": "12345", "mail": content};
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: jsonEncode(mp));
      print("Summary ans got");
      var body = jsonDecode(response.body);
      print(response.body);
      summary =
          "\n    \"Summary\":\"The email notifies the user about enhancements made to their ACM Email Forwarding service and provides details regarding these improvements.\",\n    \"Tags\": [\"ACM Email Forwarding Service\", \"Enhancements\", \"Updates\"],\n    \"SuggestedTags\": [],\n    \"Responses\":[\"Thank you for the email regarding the enhancements made to my ACM Email Forwarding service. I will review the provided information.\", \"I appreciate you informing me about the recent enhancements to the ACM Email Forwarding Service. I will take a look at the details you have provided.\", \"It's great to hear about the enhancements to the ACM Email Forwarding Service. I will be sure to check out the information provided.\"]\n}";
      // return body["answer"];
    } catch (err) {
      print(err);
      // return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Summary"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Color.fromARGB(255, 255, 164, 102),
      body: FutureBuilder(
        future: _gmail_summary(widget.content),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Text(summary),
            );
          }
          return Placeholder();
        },
      ),
    );
  }
}
