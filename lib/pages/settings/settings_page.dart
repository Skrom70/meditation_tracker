import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditation_tracker/common/date_formatter.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    List<String> dates = [
      defaultDateFormatter.format(date),
      DateFormat.yMMM().format(date),
      DateFormat.yMMMM().add_s().format(date)
    ];

    debugPrint('date: ${dates[0]}');

    return Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                      image: AssetImage('lib/assets/images/lotus_icon.png'),
                      height: 35),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Lotus',
                    style: Theme.of(context).appBarTheme.titleTextStyle,
                  ),
                ],
              ),
              Text(
                '...work in progress',
                style: TextStyle(fontSize: 10),
              )
            ],
          ),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '...work in progress ',
                style: TextStyle(fontSize: 17),
              ),
              Icon(
                Icons.construction,
                size: 20,
              )
            ],
          ),
        ));
  }
}
