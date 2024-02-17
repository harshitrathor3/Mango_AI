import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mango_ai/screens/QNA.dart';
import 'package:mango_ai/screens/authScreen.dart';
import 'package:mango_ai/screens/tabsectionscreen.dart';

void main() => runApp(MaterialApp(
    builder: (context, child) {
      return Directionality(textDirection: TextDirection.ltr, child: child!);
    },
    title: 'MangoAI',
    theme: ThemeData(
      primaryColor: Colors.yellowAccent,
    ),
    home: LoginScreen()));
