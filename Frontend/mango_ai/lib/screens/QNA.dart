import 'package:flutter/material.dart';

class QNAScreen extends StatefulWidget {
  const QNAScreen({super.key});

  @override
  State<QNAScreen> createState() => _QNAScreenState();
}

class _QNAScreenState extends State<QNAScreen> {
  bool _inputactive = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Placeholder()),
        Container(
          height: 80,
          child: _inputactive
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // TextFormField(),
                        Icon(
                          Icons.abc,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ))
              : Center(
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          _inputactive = true;
                        });
                      },
                      icon: Icon(Icons.voice_chat)),
                ),
        )
      ],
    );
  }
}
