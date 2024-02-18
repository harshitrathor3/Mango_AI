import 'package:flutter/material.dart';
import 'package:mango_ai/widgets/userSelectionButton.dart';
import 'package:speech_to_text/speech_to_text.dart';

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
    if (_speechToText.isListening == false) {}
    setState(() {
      _confidenceLevel = result.confidence;
    });
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
                  backgroundColor: Color.fromARGB(255, 255, 164, 102)),
              // tooltip: 'Listen',
              child: Icon(
                _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
              ),
              // backgroundColor: Colors.red,
            ),
          ),
        ),
        Expanded(
            child: (_wordsSpoken.length == 0)
                ? Text("Press icon to speak")
                : _suggestionWidget()),
        Row(
          children: [
            SizedBox(
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.black)),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.black))),
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'PLease enter Reciever Address';
                        return null;
                      },
                    ))),
            IconButton(
                onPressed: () {
                  final isValid = _formKey.currentState!.validate();
                  if (!isValid) {
                    return;
                  }
                  _formKey.currentState!.save();
                },
                icon: const Icon(Icons.send_rounded))
          ],
        )
      ],
    );
  }

  Widget _suggestionWidget() {
    return Center();
  }

  Widget EmailSummary() {
    return Text("Email Summary");
  }

  @override
  Widget build(BuildContext context) {
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
                      child:
                          UserSelectionTile(title: "Email Auto Write & Send")),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _optionSelected = true;
                          _selectedOption = 2;
                        });
                      },
                      child: UserSelectionTile(title: "Email Summary"))
                ],
              ),
      ),
    );
  }
}
