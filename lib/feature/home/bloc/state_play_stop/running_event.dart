import 'package:equatable/equatable.dart';

abstract class RunningEvent extends Equatable {
  const RunningEvent();
}

class PauseEvent extends RunningEvent {
  const PauseEvent({this.isPause});
  final bool isPause;
  @override
  List<Object> get props => [isPause];
}
