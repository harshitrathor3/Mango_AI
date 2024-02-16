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
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(child: Placeholder()),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
          height: 80,
          child: _inputactive
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: size.width * 0.8,
                          child: TextFormField(),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.send_rounded,
                              size: 24,
                              color: Colors.black,
                            ))
                      ],
                    ),
                  ))
              : Center(
                  child: IconButton(
                      onPressed: () {
                        // setState(() {
                        //   _inputactive = true;
                        // });
                      },
                      icon: Icon(Icons.voice_chat)),
                ),
        )
      ],
    );
  }
}
