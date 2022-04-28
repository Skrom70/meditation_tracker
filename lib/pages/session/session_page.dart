import 'package:flutter/material.dart';
import 'dart:math';
import 'package:meditation_tracker/common/date_formatter.dart';
import 'package:meditation_tracker/database/database_manader.dart';
import 'package:meditation_tracker/database/database_provider.dart';
import 'package:meditation_tracker/database/database_session.dart';
import 'package:meditation_tracker/pages/session/session_finish_page.dart';
import 'package:meditation_tracker/pages/session/session_start_page.dart';
import 'package:meditation_tracker/reuseble_widget/simple_snack_bar.dart';
import 'package:provider/provider.dart';

class SessionPage extends StatefulWidget {
  const SessionPage(
      {Key? key, required this.sessionMins, required this.intervalMins})
      : super(key: key);

  final int sessionMins;
  final int intervalMins;

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage>
    with TickerProviderStateMixin {
  late Animation<double> _prepareAnimation;
  late AnimationController _prepareController;
  late Animation<double> _sessionTimeAnimation;
  late AnimationController _sessionTimeController;
  late Animation<double> _intervalTimeAnimation;
  late AnimationController _intervalTimeController;
  late int _intervalCount;
  late int _intervalIndex = 0;
  bool _isPreparing = true;
  int _prepareDurationSeconds = 3;
  bool _isPause = false;

  @override
  void initState() {
    super.initState();

    _intervalCount = widget.intervalMins == 0
        ? 0
        : (widget.sessionMins ~/ widget.intervalMins);

    // Prepare Animation
    _prepareController = AnimationController(
        vsync: this, duration: Duration(seconds: _prepareDurationSeconds));

    Tween<double> _prepareDrawStep = Tween(begin: 1.0, end: 0.0);

    _prepareAnimation = _prepareDrawStep.animate(_prepareController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _isPreparing = false;
          _prepareController.stop();
        } else if (status == AnimationStatus.dismissed) {
          _prepareController.forward();
        }
      });

    _prepareController.forward();

    // Session Time Animation
    _sessionTimeController = AnimationController(
        vsync: this, duration: Duration(seconds: widget.sessionMins * 60));

    Tween<double> _sessinTimeDrawStep = Tween(begin: 1.0, end: 0.0);

    _sessionTimeAnimation = _sessinTimeDrawStep.animate(_sessionTimeController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _sessionTimeController.stop();
          _finishSession();
        } else if (status == AnimationStatus.dismissed) {
          _sessionTimeController.forward();
        }
      });

    // Interval Time Animation
    _intervalTimeController = AnimationController(
        vsync: this, duration: Duration(seconds: widget.intervalMins * 60));

    Tween<double> _intervalTimeDrawStep = Tween(begin: 1.0, end: 0.0);

    _intervalTimeAnimation =
        _intervalTimeDrawStep.animate(_intervalTimeController)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _intervalIndex++;
              if (_intervalIndex < _intervalCount) {
                _intervalTimeController.repeat();
              } else {
                _intervalTimeController.stop();
              }
            } else if (status == AnimationStatus.dismissed) {
              _intervalTimeController.forward();
            }
          });
  }

  @override
  void dispose() {
    [_prepareController, _sessionTimeController, _intervalTimeController]
        .forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('sdfsd')),
      body: SafeArea(
          child: Stack(children: [
        _buildSessionWidget(),
        _buildPrepareCircle(),
      ])),
    );
  }

  Widget _buildSessionWidget() {
    if (_prepareAnimation.value < 0.1) {
      if (!_sessionTimeController.isAnimating && !_isPause) {
        _sessionTimeController.forward();
        if (_intervalCount > 0) _intervalTimeController.forward();
      }
      return Column(
        children: [
          Spacer(),
          Stack(children: [
            Center(
              child: CustomPaint(
                size: Size(200, 200),
                painter: DownCounteCirclePainter(
                    index: _sessionTimeAnimation.value,
                    customPaint: Paint()
                      ..color = Colors.indigo
                      ..strokeWidth = 35
                      ..style = PaintingStyle.stroke
                      ..strokeCap = StrokeCap.butt),
              ),
            ),
            if (_intervalCount > 0)
              Center(
                child: CustomPaint(
                  size: Size(200, 200),
                  painter: DownCounteCirclePainter(
                      index: _intervalTimeAnimation.value,
                      customPaint: Paint()
                        ..color = Color.fromARGB(255, 192, 194, 202)
                        ..strokeWidth = 15
                        ..style = PaintingStyle.stroke
                        ..strokeCap = StrokeCap.butt),
                ),
              ),
            Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: Center(
                  child: Text(
                    _getDowncountSessionMinutes(),
                    style: TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ),
          ]),
          SizedBox(
            height: 70,
          ),
          _buildBottonBar(),
          Spacer()
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildPrepareCircle() {
    if (_isPreparing) {
      return Center(
          child: CustomPaint(
        size: Size(50, 50),
        painter: DownCounteCirclePainter(
            index: _prepareAnimation.value,
            customPaint: Paint()
              ..color = Color.fromARGB(255, 154, 168, 243)
                  .withOpacity(_prepareAnimation.value)
              ..strokeWidth = 12
              ..style = PaintingStyle.stroke
              ..strokeCap = StrokeCap.butt),
      ));
    } else {
      return Container();
    }
  }

  Widget _buildBottonBar() {
    if (_isPause) {
      return Row(
        children: [
          Spacer(),
          ElevatedButton(
              onPressed: _finishOnTapped,
              child: Text(
                'Finish',
                style: TextStyle(fontSize: 20.0),
              )),
          SizedBox(
            width: 10,
          ),
          ElevatedButton(
              onPressed: _resumeOnTapped,
              child: Text(
                'Resume',
                style: TextStyle(fontSize: 20.0),
              )),
          Spacer()
        ],
      );
    } else {
      return ElevatedButton(
          onPressed: _pauseOnTapped,
          child: Text(
            'Pause',
            style: TextStyle(fontSize: 20.0),
          ));
    }
  }

  String _getDowncountSessionMinutes() {
    double currentMins = (widget.sessionMins * _sessionTimeAnimation.value);
    return (currentMins + 1).toInt().toString();
  }

  void _pauseOnTapped() {
    setState(() {
      _sessionTimeController.stop();
      _intervalTimeController.stop();
      _isPause = true;
    });
  }

  void _resumeOnTapped() {
    setState(() {
      _sessionTimeController.forward();
      if (_intervalIndex < _intervalCount) {
        _intervalTimeController.forward();
      }
      _isPause = false;
    });
  }

  void _finishOnTapped() {
    _finishSession();
  }

  void _finishSession() {
    if (widget.sessionMins -
            (widget.sessionMins * _sessionTimeAnimation.value) >=
        1.0) {
      final durationMins = (widget.sessionMins -
              (widget.sessionMins * _sessionTimeAnimation.value))
          .toInt();
      final date = defaultDateFormatter.format(DateTime.now());
      final databaseSession =
          DatabaseSession(durationMins: durationMins, dateString: date);

      Provider.of<DatabaseProvider>(context, listen: false)
          .insert(databaseSession);
      Navigator.pushReplacement(context,
          SlideBottomRoute(page: SessionFinishPage(session: databaseSession)));
    } else {
      Navigator.of(context).pop();
    }
  }
}

class DownCounteCirclePainter extends CustomPainter {
  final double index;
  final Paint customPaint;

  DownCounteCirclePainter({required this.index, required this.customPaint});

  @override
  void paint(Canvas canvas, Size size) {
    double circumference = size.width * pi;
    double circumferencePart = (circumference / 1) * index;
    double sweepValue = (circumferencePart / size.width) * 2;

    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(size.height / 2, size.width / 2),
          width: size.width,
          height: size.height),
      -(pi / 2),
      -sweepValue,
      false,
      customPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
