import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_running.dart';

class RunningBloc extends Bloc<RunningEvent, RunningState> {
  RunningBloc() : super(RunningInitial());

  bool isPause = false;

  @override
  Stream<RunningState> mapEventToState(RunningEvent event) async* {
    if (event is PauseEvent) {
      try {
        yield RunningLoading();
        isPause = event.isPause;
        yield RunningSuccess(isPause: event.isPause);
      } catch (e) {
        yield RunningFailure(error: e.toString());
      }
    }
  }
}
