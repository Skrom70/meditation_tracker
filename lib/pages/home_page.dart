import 'package:flutter/material.dart';
import 'package:meditation_tracker/pages/timer_page.dart';
import 'package:meditation_tracker/pages/recent_page.dart';
import 'package:meditation_tracker/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _bottomNavigationBarSelectedIndex = 0;
  final List<Widget> _bottomNavigationBarItems = [
    TimerPage(),
    const RecentPage(),
    const SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bottomNavigationBarItems[_bottomNavigationBarSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 14,
          iconSize: 30,
          backgroundColor: Theme.of(context).primaryColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: _bottomNavigationBarSelectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.timer_sharp),
              label: 'Timer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_view_month),
              label: 'Recent',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ]),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _bottomNavigationBarSelectedIndex = index;
    });
  }
}
