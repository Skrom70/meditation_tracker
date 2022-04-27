import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditation_tracker/pages/database/database_session.dart';

class SessionFinishPage extends StatelessWidget {
  const SessionFinishPage({Key? key, required this.session}) : super(key: key);

  final DatabaseSession session;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black),
            ),
            width: double.infinity,
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${DateFormat('EEEE').add_H().format(session.date ?? DateTime.now())}',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      Spacer(),
                      Text(
                        '${session.durationMins} mins',
                        style: TextStyle(fontSize: 20.0),
                      )
                    ],
                  ),
                  Icon(
                    Icons.accessibility_new_rounded,
                    color: Colors.blueGrey,
                    size: 50,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            'Three can keep a secret, if two of them are dead.',
            style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
              onPressed: () => _doneOnTapped(context),
              child: Text(
                'Done',
                style: TextStyle(fontSize: 20.0),
              )),
          Spacer()
        ]),
      ),
    );
  }

  void _doneOnTapped(BuildContext context) {
    Navigator.of(context).pop();
  }
}
