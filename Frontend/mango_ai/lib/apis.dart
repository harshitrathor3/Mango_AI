import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String> qna(String content) async {
  String endpoint = "https://mangocloud-2b2gpae35q-uc.a.run.app/mango/qna";
  try {
    print("This code is running 1");
    final url = Uri.parse(endpoint);
    Map<String, dynamic> mp = {
      "user_id": "12345",
      "question": content,
      "chat_history": []
    };
    final respose = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(mp));
    print("Result is found");
    var body = jsonDecode(respose.body);
    print(body["answer"]);
    return body["answer"];
  } catch (err) {
    print(err);
    return "";
  }
}

Future<String> gmail_autowrite(String content) async {
  String endpoint =
      "https://mangocloud-2b2gpae35q-uc.a.run.app/mango/gmail/autowriting";
  try {
    print("Gmail autowrite running");
    final url = Uri.parse(endpoint);
    Map<String, dynamic> mp = {
      "user_id": "12345",
      "mail_subject": content,
      "gmail_token": ""
    };
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(mp));
    print("Autowrite ans got");
    var body = jsonDecode(response.body);
    print(body["answer"]);
    return body["answer"];
  } catch (err) {
    print(err);
    return "";
  }
}

Future<String> gmail_summary(String content) async {
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
    print(body["answer"]);
    return body["answer"];
  } catch (err) {
    print(err);
    return "";
  }
}

Future<String> ttm_teacher(String content) async {
  String endpoint =
      "https://mangocloud-2b2gpae35q-uc.a.run.app/mango/talktome/teacher";
  try {
    print("TTM teacher running");
    final url = Uri.parse(endpoint);
    Map<String, dynamic> mp = {
      "user_id": "12345",
      "question": content,
      "chat_history": content,
      "name": content,
      "age": content,
      "gender": content
    };
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(mp));
    print("TTM teacher ans got");
    var body = jsonDecode(response.body);
    print(body["answer"]);
    return body["answer"];
  } catch (err) {
    print(err);
    return "";
  }
}
