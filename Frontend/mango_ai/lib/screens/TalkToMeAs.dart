import 'package:flutter/material.dart';
import 'package:mango_ai/screens/QNA.dart';
import 'package:mango_ai/widgets/userSelectionButton.dart';

class TalkToMeSection extends StatefulWidget {
  const TalkToMeSection({super.key});

  @override
  State<TalkToMeSection> createState() => _TalkToMeSectionState();
}

class _TalkToMeSectionState extends State<TalkToMeSection> {
  bool _isPersonSelected = false;
  int _selectedPerson = 0;
  List<String> _persons = ["friend", "teacher"];
  @override
  Widget build(BuildContext context) {
    if (_isPersonSelected) {
      return QNAScreen(token: _persons[_selectedPerson]);
    } else {
      return Center(
        child: ListView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _isPersonSelected = true;
                    _selectedPerson = index;
                  });
                },
                child: UserSelectionTile(title: _persons[index]),
              );
            },
            itemCount: _persons.length),
      );
    }
  }
}
