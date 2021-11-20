import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/constant/env.dart';
import 'package:flutter_habit_run/common/route/routes.dart';
import 'package:flutter_habit_run/common/util/format_time.dart';
import 'package:flutter_habit_run/feature/home/bloc/state_play_stop/bloc_running.dart';
import 'package:flutter_habit_run/feature/home/screen/camera.dart';
import 'package:flutter_habit_run/feature/home/screen/home.dart';
import 'package:permission_handler/permission_handler.dart';
import '../bloc/count_time/bloc_timer.dart';

import '../screen/finish_run.dart';
import 'home_widget.dart';

class ButtonControlWidget extends StatefulWidget {
  const ButtonControlWidget({this.newStep, this.oldStep});
  final int newStep;
  final int oldStep;

  @override
  _ButtonControlWidgetState createState() => _ButtonControlWidgetState();
}

class _ButtonControlWidgetState extends State<ButtonControlWidget> {
  TimerBloc timerBloc;
  RunningBloc runningBloc;
  Map<Permission, PermissionStatus> statuses;

  Future<void> askPermission(
      {BuildContext context, int steps, double distance, String time}) async {
    if (Platform.isIOS) {
      statuses = await [Permission.camera, Permission.photos].request();
      if (statuses[Permission.camera] == PermissionStatus.granted &&
          statuses[Permission.photos] == PermissionStatus.granted) {
        Navigator.of(context).pushNamed(Routes.camera,
            arguments: Camera(
              steps: steps,
              distance: distance,
              time: time,
            ));
      } else {
        await AppWidget.showDialogSetting(context,
            content: EnvValue.requestCamera);
      }
    } else {
      statuses = await [Permission.camera, Permission.storage].request();
      if (statuses[Permission.camera] == PermissionStatus.granted &&
          statuses[Permission.storage] == PermissionStatus.granted) {
        Navigator.of(context).pushNamed(Routes.camera,
            arguments: Camera(
              steps: steps,
              distance: distance,
              time: time,
            ));
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          askPermission(
              context: context, distance: distance, steps: steps, time: time);
        });
      }
    }
  }

  @override
  void initState() {
    BlocProvider.of<RunningBloc>(context).add(const PauseEvent(isPause: false));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    timerBloc = BlocProvider.of<TimerBloc>(context);
    runningBloc = BlocProvider.of<RunningBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    int steps = 0;
    double avg = 0.0;
    if (widget.newStep >= 0 && widget.oldStep >= 0) {
      steps = widget.newStep - widget.oldStep;
      if (!Platform.isIOS) {
        timerBloc.listen((value) {
          if (value.duration > 10) {
            avg = (steps * 78 / 100) / value.duration;
            if (avg > 3.892) {
              timerBloc.add(const TimerStop());
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.homeScreen, (route) => false,
                  arguments: const HomeScreen());
              AwesomeDialog(
                context: context,
                dialogType: DialogType.WARNING,
                animType: AnimType.SCALE,
                title: 'Warning',
                desc: 'You run too fast',
              )..show();
            }
          }
        });
      }
    }
    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                  left: 34,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeWidget.createGroupText(
                          context: context, amount: '$steps', title: 'Step'),
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: HomeWidget.createGroupText(
                            context: context, title: 'Time'),
                      ),
                    ],
                  )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: BlocBuilder<TimerBloc, TimerState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (state is TimerRunPause) ...[
                    GestureDetector(
                        onTap: () async {
                          timerBloc.add(const TimerStop());
                          Navigator.pushNamedAndRemoveUntil(
                              context, Routes.finishRun, (route) => false,
                              arguments: FinishRun(
                                steps: steps,
                                distance: steps * 78 / 100000,
                                time: state.duration,
                              ));
                        },
                        child: HomeWidget.createBtnIcon(redSalsa,
                            size: 80,
                            radius: 99,
                            child: Icon(Icons.stop, size: 30, color: white))),
                    GestureDetector(
                        onTap: () async {
                          BlocProvider.of<TimerBloc>(context)
                              .add(const TimerResumed());
                          runningBloc.add(const PauseEvent(isPause: false));
                        },
                        child: HomeWidget.createBtnIcon(sandyBrown,
                            size: 80,
                            radius: 99,
                            child: Icon(Icons.play_arrow,
                                size: 30, color: white))),
                  ],
                  if (state is TimerRunInProgress) ...[
                    GestureDetector(
                      onTap: () async {
                        await askPermission(
                            time: FormatTime.convertTime(state.duration),
                            steps: steps,
                            distance: steps * 78 / 100000,
                            context: context);
                      },
                      child: Image.asset(
                        'images/primary@3x.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        timerBloc.add(const TimerPaused());
                        runningBloc.add(const PauseEvent(isPause: true));
                      },
                      child: HomeWidget.createBtnIcon(azure,
                          size: 80,
                          radius: 99,
                          child: Icon(Icons.pause, size: 30, color: white)),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
