import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meditation_tracker/database/database_session.dart';
import 'package:meditation_tracker/pages/session/session_finish_page.dart';
import 'package:meditation_tracker/pages/session/session_start_page.dart';
import 'dart:math';
import 'package:meditation_tracker/pages/session/session_timer/bloc/session_timer_bloc.dart';

class SessionNowPage extends StatefulWidget {
  SessionNowPage(
      {Key? key, required this.sessionMins, required this.intervalMins})
      : super(key: key);

  final int sessionMins;
  final int intervalMins;

  @override
  State<SessionNowPage> createState() => _SessionNowPageState();
}

class _SessionNowPageState extends State<SessionNowPage>
    with TickerProviderStateMixin {
  late Animation<double> _prepareAnimation;
  late AnimationController _prepareController;
  late Animation<double> _sessionTimeAnimation;
  late AnimationController _sessionTimeController;
  late Animation<double> _intervalTimeAnimation;
  late AnimationController _intervalTimeController;

  // late int _intervalCount;
  // late int _intervalIndex = 0;
  // bool _isPreparing = true;
  int _prepareDurationSeconds = 5;
  // bool _isStarted = false;
  // bool _isPlaying = false;
  // bool _isFinish = false;

  final AudioPlayer _audioPlayer = AudioPlayer();
  final _fullMantraPath = 'lib/assets/sounds/full_mantra.mp3';

  @override
  void initState() {
    super.initState();

    // _loadPlayer();

    // _intervalCount = widget.intervalMins == 0
    // ? 0
    // : (widget.sessionMins ~/ widget.intervalMins);

    // Prepare Animation
    _prepareController = AnimationController(
        vsync: this, duration: Duration(seconds: _prepareDurationSeconds));

    Tween<double> _prepareDrawStep = Tween(begin: 1.0, end: 0.0);

    _prepareAnimation = _prepareDrawStep.animate(_prepareController)
      ..addListener(() {
        setState(() {});
      });
    // ..addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     _isPreparing = false;
    //     _prepareController.stop();
    //   } else if (status == AnimationStatus.dismissed) {
    //     _prepareController.forward();
    //   }
    // });

    _prepareController.forward();

    // Session Time Animation
    _sessionTimeController = AnimationController(
        vsync: this, duration: Duration(minutes: widget.sessionMins));

    Tween<double> _sessinTimeDrawStep = Tween(begin: 1.0, end: 0.0);

    _sessionTimeAnimation = _sessinTimeDrawStep.animate(_sessionTimeController)
      ..addListener(() {
        setState(() {});
      });
    // ..addStatusListener((status) {
    //   if (status == AnimationStatus.dismissed) {
    //     _sessionTimeController.forward();
    //   }
    // });

    // Interval Time Animation
    // _intervalTimeController = AnimationController(
    //     vsync: this, duration: Duration(minutes: widget.intervalMins));

    // Tween<double> _intervalTimeDrawStep = Tween(begin: 1.0, end: 0.0);

    // _intervalTimeAnimation =
    //     _intervalTimeDrawStep.animate(_intervalTimeController)
    //       ..addListener(() {
    //         setState(() {});
    //       })
    //       ..addStatusListener((status) {
    //         if (status == AnimationStatus.completed) {
    //           _intervalIndex++;
    //           if (_intervalIndex < _intervalCount) {
    //             _intervalTimeController.repeat();
    //           } else {
    //             _intervalTimeController.stop();
    //           }
    //         } else if (status == AnimationStatus.dismissed) {
    //           _intervalTimeController.forward();
    //         }
    //       });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: BlocProvider(
          create: (context) => SessionTimerBloc(
              audioPlayer: AudioPlayerImplementation(widget.sessionMins)),
          child: BlocConsumer<SessionTimerBloc, SessionTimerState>(
            listener: (context, state) {
              if (state is SessionTimerRunInProgress) {
                if (!_sessionTimeController.isAnimating) {
                  _sessionTimeController.forward();
                }
              }
              if (state is SessionTimerRunPause) {
                if (_sessionTimeController.isAnimating) {
                  _sessionTimeController.stop(canceled: false);
                }
              }
              if (state is SessionTimerRunComplete) {
                Navigator.of(context).pushReplacement(SlideBottomRoute(
                    page: SessionFinishPage(
                        session: DatabaseSession(
                            dateString: 'fsdfds', durationMins: 3))));
              }
              if (state is SessionTimerRunCancel) {
                Navigator.of(context).pop();
              }
            },
            buildWhen: (previous, current) =>
                previous.runtimeType != current.runtimeType,
            builder: (context, state) {
              if (state is SessionTimerInitial) {
                return _buildPrepareCircleWidget(context);
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  Stack(
                    children: [
                      _buildSessionCircleWidget(),
                      _buildSessionDurationWidget()
                    ],
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  if (state is SessionTimerRunInProgress) ...[
                    ElevatedButton(
                        onPressed: () => context
                            .read<SessionTimerBloc>()
                            .add(SessionTimerPaused()),
                        child: Text(
                          'Pause',
                          style: TextStyle(fontSize: 20.0),
                        )),
                  ],
                  if (state is SessionTimerRunPause) ...[
                    Row(
                      children: [
                        Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              context
                                  .read<SessionTimerBloc>()
                                  .add(SessionTimerCompleted());
                            },
                            child: Text(
                              'Finish',
                              style: TextStyle(fontSize: 20.0),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () => context
                                .read<SessionTimerBloc>()
                                .add(SessionTimerResumed()),
                            child: Text(
                              'Resume',
                              style: TextStyle(fontSize: 20.0),
                            )),
                        Spacer()
                      ],
                    ),
                  ],
                  Spacer()
                ],
              );
            },
          )),
    ));
  }

  Widget _buildSessionCircleWidget() {
    if (_sessionTimeController.isCompleted) {
      context.read<SessionTimerBloc>().add(SessionTimerCompleted());
    }
    return Center(
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
    );
  }

  Widget _buildSessionDurationWidget() {
    return Center(
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
    );
  }

  Widget _buildPrepareCircleWidget(BuildContext context) {
    if (_prepareAnimation.isCompleted) {
      context.read<SessionTimerBloc>().add(SessionTimerStarted());
    }
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
  }

  String _getDowncountSessionMinutes() {
    double currentMins = (widget.sessionMins * _sessionTimeAnimation.value);
    return (currentMins + 1).toInt().toString();
  }

  // void _pauseOnTapped() {
  //   _audioPlayer.pause();
  // }

  // void _resumeOnTapped() {
  //   _audioPlayer.play();
  // }

  // void _finishOnTapped() {
  //   _finishSession();
  // }

  // void _finishSession() {
  //   if (widget.sessionMins -
  //           (widget.sessionMins * _sessionTimeAnimation.value) >=
  //       1.0) {
  //     final durationMins = (widget.sessionMins -
  //             (widget.sessionMins * _sessionTimeAnimation.value))
  //         .toInt();
  //     final date = defaultDateFormatter.format(DateTime.now());
  //     final databaseSession =
  //         DatabaseSession(durationMins: durationMins, dateString: date);
  //     if (!_isFinish) {
  //       _isFinish = true;
  //       Provider.of<DatabaseProvider>(context, listen: false)
  //           .insert(databaseSession);
  //     }
  //     Navigator.pushReplacement(context,
  //         SlideBottomRoute(page: SessionFinishPage(session: databaseSession)));
  //   } else {
  //     Navigator.of(context).pop();
  //   }
  //   _audioPlayer.stop();
  // }
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
