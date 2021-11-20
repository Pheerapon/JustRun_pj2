import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class TimerStarted extends TimerEvent {
  const TimerStarted({@required this.duration});
  final int duration;
}

class TimerPaused extends TimerEvent {
  const TimerPaused();
}

class TimerResumed extends TimerEvent {
  const TimerResumed();
}

class TimerStop extends TimerEvent {
  const TimerStop();
}

class TimerTicked extends TimerEvent {
  const TimerTicked({@required this.duration});
  final int duration;

  @override
  List<Object> get props => [duration];
}