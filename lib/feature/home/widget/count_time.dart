import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/util/format_time.dart';
import 'package:flutter_habit_run/feature/home/bloc/state_play_stop/bloc_running.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/count_time/timer_bloc.dart';

class TimerText extends StatefulWidget {
  @override
  State<TimerText> createState() => _TimerTextState();
}

class _TimerTextState extends State<TimerText> with WidgetsBindingObserver {
  SharedPreferences sharedPreferences;
  RunningBloc runningBloc;
  int time = 0;
  Duration timeNow;
  DateTime timeOld;
  bool statusRun = false;

  Future<void> saveTimeNow() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('timeNow', DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> getTimeNow() async {
    sharedPreferences = await SharedPreferences.getInstance();
    timeOld = DateTime.fromMillisecondsSinceEpoch(
        sharedPreferences.getInt('timeNow'));
    timeNow = DateTime.now().difference(timeOld);
    time = timeNow.inHours * 3600 + timeNow.inMinutes * 60 + timeNow.inSeconds;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!runningBloc.isPause) {
      if (state == AppLifecycleState.resumed) {
        getTimeNow();
      }
      if (state == AppLifecycleState.paused) {
        saveTimeNow();
      }
    }
  }

  @override
  void didChangeDependencies() {
    runningBloc = BlocProvider.of<RunningBloc>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int duration =
        context.select((TimerBloc bloc) => bloc.state.duration);
    return BlocBuilder<RunningBloc, RunningState>(
      builder: (context, state) {
        if (state is RunningSuccess) {
          statusRun = state.isPause;
        }
        return Text(
          FormatTime.convertTime(!statusRun
              ? (Platform.isIOS ? (duration + time) : duration)
              : duration),
          style: AppWidget.boldTextFieldStyle(
              fontSize: 32,
              height: 37.5,
              color: Theme.of(context).color10,
              fontFamily: 'Futura',
              fontStyle: FontStyle.italic),
        );
      },
    );
  }
}
