import 'package:flutter/material.dart';
import 'package:meditation_tracker/common/bottom_bar_provider.dart';
import 'package:meditation_tracker/database/database_provider.dart';
import 'package:meditation_tracker/pages/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (context) => BottomNavigationBarProvider()),
      ChangeNotifierProvider(
        create: (context) => DatabaseProvider(),
      )
    ],
    child: MyApp(),
  ));
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
                fontSize: 22,
                fontWeight: FontWeight.normal,
                color: Colors.white)),
        fontFamily: 'Avenir',
        primarySwatch: Colors.indigo,
      ),
      home: const HomePage(),
    );
  }
}
