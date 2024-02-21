import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:googleapis/deploymentmanager/v2.dart';
import 'package:mango_ai/screens/summaryScreen.dart';
import 'package:mango_ai/widgets/userSelectionButton.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:mango_ai/main3.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;

class TaskAutomationSection extends StatefulWidget {
  const TaskAutomationSection({super.key});

  @override
  State<TaskAutomationSection> createState() => _TaskAutomationSectionState();
}

class _TaskAutomationSectionState extends State<TaskAutomationSection> {
  bool _optionSelected = false;
  int _selectedOption = -1;
  bool _resultfound = false;
  String _result = "";
  final ScrollController _scrollController = ScrollController();
  final SpeechToText _speechToText = SpeechToText();
  String generatedMail = "";
  bool _speechEnabled = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;
  List<String> _mailResults = [];
  GoogleSignInAccount? _currentUser;
  final GoogleSignIn googleSignIn = GoogleSignIn.standard();
  List<String> _mailData = [];
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    initSpeech();
    googleSignIn.signInSilently();
  }

  Future<void> readRecentUnreads(int hours) async {
    // var googleSignIn = await GoogleSignIn();
    final authClient =
        await googleSignIn.authenticatedClient() as auth.AuthClient;
    final gmailApi = GmailApi(authClient);

    var response = await gmailApi.users.messages.list('me',
        // q: 'is:unread in:inbox after:${DateTime.now().subtract(Duration(hours: hours)).toIso8601String()}',
        maxResults: 5);

    print('Recent unread emails:');

    for (var message in response.messages ?? []) {
      var metadata = await gmailApi.users.messages.get('me', message.id);

      var subjectHeader = metadata.payload?.headers
          ?.where((header) => header.name == 'Subject')
          .first;

      var body = _decodeBody(metadata.payload?.body?.data ?? '');

      print(' - Subject: ${subjectHeader?.value}');
      _mailData.add(subjectHeader?.value as String);
      print(' - Body: ${body}');
    }
  }

  String _decodeBody(String encodedBody) {
    var bytes = base64.decode(encodedBody);
    return utf8.decode(bytes);
  }

  // String _decodeBody(String encodedBody) {
  //   var bytes = base64.decode(encodedBody);
  //   return utf8.decode(bytes);
  // }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    isReady = false;
    await _speechToText.listen(
        onResult: _onSpeechResult,
        listenOptions: SpeechListenOptions(
            partialResults: true, listenMode: ListenMode.dictation));
    setState(() {
      _confidenceLevel = 0;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) async {
    _wordsSpoken = "${result.recognizedWords}";
    if (_speechToText.isListening == false) {
      isReady = true;
      _getResults();
    }
    setState(() {
      _confidenceLevel = result.confidence;
    });
  }

  Future<void> _getResults() async {
    String content = _wordsSpoken;
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
      print(response.body);
      var body = jsonDecode(response.body);
      print(body);

      // _mailResults = body["mails"];
      // return body["answer"];
      setState(() {
        generatedMail = body;
      });
    } catch (err) {
      print(err);
      // return "";
      // return [];
      generatedMail = "Not Found";
    }
  }

  bool isAlphaNumeric(String input) {
    RegExp _alphanumeric = new RegExp(r'^[a-zA-Z0-9]+$');
    if (_alphanumeric.hasMatch(input)) {
      return true;
    } else {
      return false;
    }
  }

  Future<Message> sendMessage(String email, String subject, String body) async {
    // var _googleSignIn = await GoogleSignIn();
    final auth.AuthClient client =
        await googleSignIn.authenticatedClient() as auth.AuthClient;
    final gmailApi = GmailApi(client);
    var message = new Message();
    message.raw =
        "From: me <${email}>\nTo: ${email}\nSubject: ${subject}\n\n${body}";
    // Encode the message.raw property in Base64
    String encodedMessage = base64.encode(message.raw?.codeUnits ?? []);
    message.raw = encodedMessage;

    final response = await gmailApi.users.messages.send(message, 'me');
    print('Email Sent');
    return response;
  }

  Widget EmailAutoWrite() {
    var _formKey = GlobalKey<FormState>();
    var _emailController = TextEditingController();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ElevatedButton(
              onPressed:
                  _speechToText.isListening ? _stopListening : _startListening,
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 255, 164, 102)),
              // tooltip: 'Listen',
              child: Icon(
                _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
              ),
              // backgroundColor: Colors.red,
            ),
          ),
        ),
        Text(_wordsSpoken),
        Expanded(
            child: (_wordsSpoken.isEmpty)
                ? const Center(
                    child: Text("Press Mic To speak"),
                  )
                : isReady
                    ? SingleChildScrollView(
                        child: Column(children: [
                          Text(generatedMail),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 164, 102)),
                              onPressed: () {
                                final isValid =
                                    _formKey.currentState!.validate();
                                if (!isValid) {
                                  return;
                                }
                                _formKey.currentState!.save();
                                sendMessage(
                                    _emailController.value.toString(),
                                    _wordsSpoken,
                                    "This is my sample generated mail from flutter");
                              },
                              child: const Text("Send Mail"))
                        ]),
                      )
                    : const SizedBox(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator())),
        Center(
          child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Form(
                  key: _formKey,
                  child: TextFormField(
                    decoration: const InputDecoration(
                        fillColor: Colors.black,
                        hintText: "Reciever Email",
                        hintStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: Colors.black)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: Colors.black))),
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'PLease enter Reciever Address';
                      return null;
                    },
                  ))),
        )
      ],
    );
  }

  // Widget _suggestionWidget() {
  // }

  Widget EmailSummary() {
    print("this is inside code");
    return Expanded(
      child: Center(
          child: FutureBuilder(
        future: readRecentUnreads(10),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const CircularProgressIndicator();
          else
            return ListView.builder(
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          SummaryScreen(content: _mailData[index]),
                    ));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Card(
                      child: Container(
                        color: const Color.fromARGB(255, 255, 177, 123),
                        child: Text(
                          _mailData[index],
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: _mailData.length,
            );
        },
      )),
    );
    // return Text("Email Summary");
  }

  @override
  Widget build(BuildContext context) {
    readRecentUnreads(10);
    return Expanded(
      child: Center(
        child: (_optionSelected)
            ? (_selectedOption == 1)
                ? EmailAutoWrite()
                : EmailSummary()
            : Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _optionSelected = true;
                          _selectedOption = 1;
                        });
                      },
                      child: const UserSelectionTile(
                          title: "Email Auto Write & Send")),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _optionSelected = true;
                          _selectedOption = 2;
                        });
                      },
                      child: const UserSelectionTile(title: "Email Summary"))
                ],
              ),
      ),
    );
  }
}
