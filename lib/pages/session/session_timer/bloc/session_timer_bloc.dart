import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

part 'session_timer_event.dart';
part 'session_timer_state.dart';

class SessionTimerBloc extends Bloc<SessionTimerEvent, SessionTimerState> {
  SessionTimerBloc({required this.audioPlayer}) : super(SessionTimerInitial()) {
    on<SessionTimerStarted>(_onStarted);
    on<SessionTimerPaused>(_onPaused);
    on<SessionTimerResumed>(_onResumed);
    on<SessionTimerCompleted>(_onCompleted);
    on<SessionTimerCanceled>(_onCanceled);
  }

  final AudioPlayerPanel audioPlayer;

  void _onStarted(
      SessionTimerStarted event, Emitter<SessionTimerState> emit) async {
    audioPlayer.play();
    emit(SessionTimerRunInProgress(state.durationMins));
  }

  void _onPaused(SessionTimerPaused event, Emitter<SessionTimerState> emit) {
    if (state is SessionTimerRunInProgress) {
      audioPlayer.pause();
      emit(SessionTimerRunPause(state.durationMins));
    }
  }

  void _onResumed(SessionTimerResumed resume, Emitter<SessionTimerState> emit) {
    if (state is SessionTimerRunPause) {
      audioPlayer.play();
      emit(SessionTimerRunInProgress(state.durationMins));
    }
  }

  void _onCompleted(
      SessionTimerCompleted event, Emitter<SessionTimerState> emit) {
    audioPlayer.stop();
    if (state is SessionTimerRunPause) {
      emit(SessionTimerRunComplete(
          actualSessionDurationMins:
              audioPlayer.durationMins - state.durationMins));
    }
    if (state is SessionTimerRunInProgress) {
      emit(SessionTimerRunComplete(
          actualSessionDurationMins: audioPlayer.durationMins));
    }
  }

  void _onCanceled(
      SessionTimerCanceled event, Emitter<SessionTimerState> emit) {
    audioPlayer.stop();
    if (state is SessionTimerRunPause) {
      emit(SessionTimerRunCancel());
    }
  }

  // late int _intervalCount;
  // late int _intervalIndex = 0;
  // int _prepareDurationSeconds = 3;
  // bool _isPreparing = true;
  // bool _isStarted = false;
  // bool _isPlaying = false;
  // bool _isFinish = false;

  @override
  Future<void> close() {
    // _audioPlayer.dispose();
    return super.close();
  }
}

// -------------------------------------------------------------------------------------------

abstract class AudioPlayerPanel {
  AudioPlayerPanel(this.durationMins);
  final int durationMins;
  void play();
  void pause();
  void stop();
}

class AudioPlayerImplementation extends AudioPlayerPanel {
  AudioPlayerImplementation(super.durationMins);

  final AudioPlayer _audioPlayer = AudioPlayer();
  final _fullMantraPath = 'asset:///lib/assets/sounds/full_mantra.mp3';

  void play() {
    _loadAudioSource(_fullMantraPath, 'Om mantra');
    _audioPlayer.play();
  }

  void pause() => _audioPlayer.pause();

  void stop() => _audioPlayer.stop();

  Future<void> _loadAudioSource(String sourcePath, String title) async {
    if (_audioPlayer.audioSource == null) {
      await _audioPlayer.setAudioSource(ClippingAudioSource(
        end: Duration(minutes: durationMins),
        tag: MediaItem(
          id: title + DateTime.now.toString(),
          title: title,
        ),
        child: AudioSource.uri(
          Uri.parse(sourcePath),
        ),
      ));
    }
  }
}
