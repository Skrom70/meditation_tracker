part of 'session_timer_bloc.dart';

abstract class SessionTimerEvent {
  const SessionTimerEvent();
}

class SessionTimerInitialized extends SessionTimerEvent {
  const SessionTimerInitialized({required this.duration});
  final int duration;
}

class SessionTimerStarted extends SessionTimerEvent {
  const SessionTimerStarted();
}

class SessionTimerPaused extends SessionTimerEvent {
  const SessionTimerPaused();
}

class SessionTimerResumed extends SessionTimerEvent {
  const SessionTimerResumed();
}

class SessionTimerCompleted extends SessionTimerEvent {
  const SessionTimerCompleted();
}

class SessionTimerCanceled extends SessionTimerEvent {
  const SessionTimerCanceled();
}
