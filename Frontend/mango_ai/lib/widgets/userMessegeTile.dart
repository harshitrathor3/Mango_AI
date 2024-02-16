import 'package:flutter/material.dart';

class UserMessegeTile extends StatefulWidget {
  final String messege;
  const UserMessegeTile({super.key, required this.messege});

  @override
  State<UserMessegeTile> createState() => _UserMessegeTileState();
}

class _UserMessegeTileState extends State<UserMessegeTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.messege),
    );
  }
}
