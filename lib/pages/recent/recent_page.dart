import 'package:flutter/material.dart';

class RecentPage extends StatelessWidget {
  const RecentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meditation Tracker')),
      body: const Text('Recent Page'),
    );
  }
}
