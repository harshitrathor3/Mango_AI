import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mango_ai/screens/TalkToMeAs.dart';
import 'package:mango_ai/screens/profile.dart';
import '../screens/QNA.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedIndex = 2;
  List<String> _selectedPage = [
    "Talk to me as",
    "Task Automation",
    "MangoAI",
    "Profile"
  ];
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static const List<Widget> _widgetOptions = <Widget>[
    TalkToMeSection(),
    Text(
      'Likes',
      style: optionStyle,
    ),
    QNAScreen(token: null),
    ProfileSection()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 220, 180),
      appBar: AppBar(
        elevation: 20,
        backgroundColor: Colors.black,
        foregroundColor: Color.fromARGB(255, 255, 164, 102),
        title: Center(
          child: Text(
            _selectedPage[_selectedIndex],
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Color.fromARGB(255, 255, 164, 102),
              color: Color.fromARGB(255, 255, 164, 102),
              tabs: const [
                GButton(
                  icon: Icons.record_voice_over_rounded,
                  text: 'Talk',
                ),
                GButton(
                  icon: Icons.auto_awesome,
                  text: 'Auto',
                ),
                GButton(
                  icon: Icons.chat,
                  text: 'Chat',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
