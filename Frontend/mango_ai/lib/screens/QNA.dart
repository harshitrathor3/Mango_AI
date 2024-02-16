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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ListView(
            reverse: true,
            children: [Text("data")],
          ),
        ),
        Container(
          height: 40,
          width: size.width,
          child: ListView(scrollDirection: Axis.horizontal, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: () {}, child: Text("data")),
            ),
            ElevatedButton(onPressed: () {}, child: Text("data")),
            ElevatedButton(onPressed: () {}, child: Text("data")),
            ElevatedButton(onPressed: () {}, child: Text("data")),
            ElevatedButton(onPressed: () {}, child: Text("data")),
            ElevatedButton(onPressed: () {}, child: Text("data"))
          ]),
        ),
        Container(
          height: 70,
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
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: ElevatedButton(
                        onPressed: () {},
                        child: Icon(
                          Icons.mic,
                          size: 30,
                        )),
                  ),
                ),
        )
      ],
    );
  }
}
