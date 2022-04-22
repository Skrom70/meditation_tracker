import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class TimerPage extends StatefulWidget {
  TimerPage({Key? key}) : super(key: key);

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int _currentSessionTimeValue = 1;
  int _currentIntervalValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
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
        ),
        body: Column(
          children: [
            Divider(),
            Spacer(),
            PickerBlock(
              title: 'Session Time',
              currentValue: _currentSessionTimeValue,
              maxValue: 90,
              minValue: 1,
              valueSetter: _updateSessionTime,
            ),
            SizedBox(
              height: 50,
            ),
            PickerBlock(
              title: 'Interval Chime',
              currentValue: _currentIntervalValue,
              maxValue: 45,
              minValue: 0,
              valueSetter: _updateInterval,
              subtitle: _currentIntervalValue > 0 ? 'every' : '',
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Begin',
                  style: TextStyle(fontSize: 20.0),
                )),
            Spacer()
          ],
        ));
  }

  void _updateSessionTime(int value) {
    setState(() {
      _currentSessionTimeValue = value;
    });
  }

  void _updateInterval(int value) {
    setState(() {
      _currentIntervalValue = value;
    });
  }
}

class PickerBlock extends StatelessWidget {
  const PickerBlock(
      {Key? key,
      required this.title,
      required this.currentValue,
      required this.minValue,
      required this.maxValue,
      required this.valueSetter,
      this.subtitle = null})
      : super(key: key);

  final String title;
  final int currentValue;
  final int minValue;
  final int maxValue;
  final Function(int) valueSetter;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final String suffix;
    switch (currentValue) {
      case 0:
        suffix = '';
        break;
      case 1:
        suffix = 'min';
        break;
      default:
        suffix = 'mins';
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500),
          ),
        ),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              subtitle ?? '',
              style: TextStyle(fontSize: 18.0, color: Colors.black54),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: NumberPicker(
            value: currentValue,
            selectedTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.w400),
            textStyle: TextStyle(color: Colors.black54, fontSize: 24.0),
            minValue: minValue,
            maxValue: maxValue,
            step: 1,
            itemHeight: 45.0,
            itemWidth: 48.0,
            itemCount: 5,
            axis: Axis.horizontal,
            onChanged: valueSetter,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(
            suffix,
            style: TextStyle(fontSize: 18.0, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
