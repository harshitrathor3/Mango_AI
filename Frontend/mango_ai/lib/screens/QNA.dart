import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../models/messege.dart';
import '../apis.dart';
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

Future<String> ttm_friend(String content) async {
  String endpoint =
      "https://mangocloud-2b2gpae35q-uc.a.run.app/mango/talktome/friend";
  try {
    print("This code is running 1");
    final url = Uri.parse(endpoint);
    Map<String, dynamic> mp = {
      "user_id": "12345",
      "question": content,
      "chat_history": [],
      "name": "Mann",
      "age": 20
    };
    final respose = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(mp));
    print("Result is found");
    var body = jsonDecode(respose.body);
    print(body);
    print(body["answer"]);
    return body["answer"];
  } catch (err) {
    print(err);
    return "Oops!! Got an Error....";
  }
}

Future<String> ttm_teacher(String content) async {
  String endpoint =
      "https://mangocloud-2b2gpae35q-uc.a.run.app/mango/talktome/teacher";
  try {
    print("This code is running 1");
    final url = Uri.parse(endpoint);
    Map<String, dynamic> mp = {
      "user_id": "12345",
      "question": content,
      "chat_history": [],
      "name": "Mann",
      "age": 20,
      "gender": "Male"
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

List<String> Suggestions = [
  "What's Weather Today?",
  "India vs Pakistan Score",
  "What is megalodon"
];

class QNAScreen extends StatefulWidget {
  final String? token;
  const QNAScreen({super.key, required this.token});

  @override
  State<QNAScreen> createState() => _QNAScreenState();
}

class _QNAScreenState extends State<QNAScreen> {
  final ScrollController _scrollController = ScrollController();
  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
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
      chatlist.add(Messege(content: _wordsSpoken, isAi: false));
      // final answer=await
      String answer = "";
      if (widget.token == null) {
        answer = await qna(_wordsSpoken);
      } else if (widget.token == "friend") {
        answer = await ttm_friend(_wordsSpoken);
      } else if (widget.token == "teacher") {
        answer = await ttm_teacher(_wordsSpoken);
      }
      chatlist.add(Messege(content: answer, isAi: true));
      _wordsSpoken = "";
    }
    setState(() {
      _confidenceLevel = result.confidence;
    });
  }

  List<Messege> chatlist = [
    Messege(content: "Hey! How can i help you", isAi: true),
  ];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn);
      }
    });
    var size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Expanded(
        //   child: ListView(
        //     children: [
        //       Container(
        //         padding: EdgeInsets.all(16),
        //         child: Text(
        //           _speechToText.isListening
        //               ? "listening..."
        //               : _speechEnabled
        //                   ? "Tap the microphone to start listening..."
        //                   : "Speech not available",
        //           style: TextStyle(fontSize: 20.0),
        //         ),
        //       ),
        //       Expanded(
        //         child: Container(
        //           padding: EdgeInsets.all(16),
        //           child: Text(
        //             _wordsSpoken,
        //             style: const TextStyle(
        //               fontSize: 25,
        //               fontWeight: FontWeight.w300,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // Expanded(
        //   child: Placeholder(),
        // ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: chatlist.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                padding:
                    EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                child: Align(
                  alignment: (chatlist[index].isAi
                      ? Alignment.topLeft
                      : Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (chatlist[index].isAi
                          ? Color.fromARGB(255, 255, 177, 123)
                          : Colors.amber[50]),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      chatlist[index].content,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        chatlist.length == 1
            ? Container(
                height: 40,
                width: size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(Suggestions[index]),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 255, 177, 123),
                          foregroundColor: Colors.white),
                    ),
                  ),
                  itemCount: Suggestions.length,
                ),
              )
            : _speechToText.isListening
                ? Text(_wordsSpoken)
                : const SizedBox(
                    height: 0,
                  ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ElevatedButton(
              onPressed:
                  _speechToText.isListening ? _stopListening : _startListening,
              // tooltip: 'Listen',
              child: Icon(
                _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
              ),
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 255, 164, 102)),
              // backgroundColor: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
