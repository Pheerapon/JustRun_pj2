import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/route/routes.dart';
import 'package:flutter_habit_run/feature/home/bloc/count_time/bloc_timer.dart';
import 'package:flutter_habit_run/feature/home/screen/running.dart';
import 'package:pedometer/pedometer.dart';

class CountDown extends StatefulWidget {
  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  int _currentPage = 0;
  PageController pageController = PageController(
    initialPage: 0,
  );
  Timer timerAudio;
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  Stream<StepCount> _stepCountStream;
  Stream<PedestrianStatus> _pedestrianStatusStream;
  int step = 0;
  void onStepCount(StepCount event) {
    setState(() {
      step = event.steps;
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
  }

  void onStepCountError(dynamic error) {
    print('onStepCountError: $error');
  }

  Future<void> initPlatformState() async {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream.listen(onPedestrianStatusChanged);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
    if (!mounted) {
      return;
    }
  }

  @override
  void initState() {
    initPlatformState().whenComplete(() {
      assetsAudioPlayer.open(Audio('sounds/countdown.mp3'), autoStart: false);
      timerAudio = Timer.periodic(const Duration(seconds: 2), (Timer t) {
        assetsAudioPlayer.play();
        if (_currentPage < 4) {
          _currentPage++;
        } else {
          assetsAudioPlayer.stop();
          BlocProvider.of<TimerBloc>(context)
              .add(const TimerStarted(duration: 0));
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.running, (route) => false,
              arguments: Running(
                oldStep: step ?? 0,
              ));
        }
        pageController.animateToPage(
          _currentPage,
          duration: const Duration(seconds: 1),
          curve: Curves.linearToEaseOut,
        );
      });
    });
    super.initState();
  }

  Widget createPage(String input) {
    return Center(
      child: Text(
        input,
        style: AppWidget.boldTextFieldStyle(
            fontSize: 160,
            height: 187.5,
            color: Theme.of(context).color8,
            fontFamily: 'Futura',
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic),
      ),
    );
  }

  @override
  void dispose() {
    timerAudio.cancel();
    assetsAudioPlayer.dispose();
    pageController.dispose();
    _stepCountStream.listen(onStepCount).cancel();
    _pedestrianStatusStream.listen(onPedestrianStatusChanged).cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        scrollDirection: Axis.vertical,
        allowImplicitScrolling: true,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          const SizedBox(),
          createPage('1'),
          createPage('2'),
          createPage('3'),
          Center(
            child: Text(
              'Run',
              style: AppWidget.boldTextFieldStyle(
                  fontSize: 120,
                  height: 140.63,
                  color: Theme.of(context).color8,
                  fontFamily: 'Futura',
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}
