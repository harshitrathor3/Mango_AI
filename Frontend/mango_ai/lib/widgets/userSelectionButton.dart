import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserSelectionTile extends StatelessWidget {
  final String title;
  const UserSelectionTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Card(
          child: Container(
            color: Color.fromARGB(255, 255, 177, 123),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
