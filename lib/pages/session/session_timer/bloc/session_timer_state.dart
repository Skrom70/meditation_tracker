part of 'session_timer_bloc.dart';

abstract class SessionTimerState extends Equatable {
  const SessionTimerState(this.durationMins);
  final int durationMins;

  @override
  List<Object> get props => [durationMins];
}

class SessionTimerInitial extends SessionTimerState {
  const SessionTimerInitial() : super(0);

  @override
  String toString() => 'SessionTimerInitial';
}

class SessionTimerRunPause extends SessionTimerState {
  const SessionTimerRunPause(super.durationMins);

  @override
  String toString() => 'SessionTimerRunPause { duration: $durationMins}';
}

class SessionTimerRunInProgress extends SessionTimerState {
  const SessionTimerRunInProgress(super.durationMins);

  @override
  String toString() => 'SessionTimerRunInProgress { duration: $durationMins}';
}

class SessionTimerRunComplete extends SessionTimerState {
  final int actualSessionDurationMins;

  const SessionTimerRunComplete({required this.actualSessionDurationMins})
      : super(0);

  @override
  String toString() =>
      'SessionTimerRunComplete { actualSessionDuration: $actualSessionDurationMins }';
}

class SessionTimerRunCancel extends SessionTimerState {
  const SessionTimerRunCancel() : super(0);

  @override
  String toString() => 'SessionTimerRunCancel';
}
