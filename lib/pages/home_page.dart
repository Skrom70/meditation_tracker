import 'package:flutter/material.dart';
import 'package:meditation_tracker/common/bottom_bar_provider.dart';
import 'package:meditation_tracker/database/database_manader.dart';
import 'package:meditation_tracker/pages/session/session_start_page.dart';
import 'package:meditation_tracker/pages/recent/recent_page.dart';
import 'package:meditation_tracker/pages/settings/settings_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _bottomNavigationBarItems = [
    SessionStartPage(),
    RecentPage(),
    const SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<BottomNavigationBarProvider>(context, listen: true);
    return Scaffold(
      body: _bottomNavigationBarItems[provider.bottomNavigationBarIndex],
      bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 15,
          iconSize: 30,
          backgroundColor: Theme.of(context).primaryColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.6),
          currentIndex: provider.bottomNavigationBarIndex,
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
    Provider.of<BottomNavigationBarProvider>(context, listen: false)
        .setBottomNavigationBarIndex(index);
  }
}
