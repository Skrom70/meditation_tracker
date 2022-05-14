import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:meditation_tracker/common/bottom_bar_provider.dart';
import 'package:meditation_tracker/database/database_provider.dart';
import 'package:meditation_tracker/pages/home_page.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
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
