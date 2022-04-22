import 'package:flutter/material.dart';
import 'package:meditation_tracker/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500,
                color: Colors.white)),
        fontFamily: 'Avenir',
        primarySwatch: Colors.indigo,
      ),
      home: const HomePage(),
    );
  }
}
