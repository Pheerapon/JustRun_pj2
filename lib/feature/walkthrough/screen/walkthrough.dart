import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/constant/env.dart';

import '../bloc/slider/bloc_slider.dart';
import '../widget/option_login.dart';
import '../widget/walkthrough_widget.dart';

class WalkThrough extends StatelessWidget {
  static Widget createFigure({double height, String image}) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Positioned(
            bottom: -26,
            child: ClipOval(
              child: Container(
                height: 18,
                width: 74,
                color: black.withOpacity(0.1),
              ),
            )),
        Positioned(
          bottom: -28,
          child: Image.asset(
            image,
            height: height,
          ),
        ),
      ],
    );
  }

  Widget landing(BuildContext context, {int index}) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Image.asset('images/walkthrough@3x.png'),
              Image.asset('gif/background_run.gif'),
              index == 0
                  ? Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [
                        Image.asset('gif/female_running_larger.gif'),
                        Positioned(
                          bottom: -24,
                          child: ClipOval(
                            child: Container(
                              height: 34,
                              width: 155,
                              color: black.withOpacity(0.1),
                            ),
                          ),
                        )
                      ],
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: constraints.maxWidth * 0.25,
                            ),
                            SizedBox(
                              width: constraints.maxWidth * 0.25,
                              child: createFigure(
                                  height: constraints.maxHeight * 1.15,
                                  image: 'gif/female_walking.gif'),
                            ),
                            SizedBox(
                              width: constraints.maxWidth * 0.25,
                              child: createFigure(
                                  height: constraints.maxHeight * 1.15,
                                  image: 'gif/male_walking.gif'),
                            ),
                            SizedBox(
                              width: constraints.maxWidth * 0.25,
                            ),
                          ],
                        );
                      },
                    )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Text(
            index == 0 ? 'Daily Running' : 'Run with friend',
            style: AppWidget.boldTextFieldStyle(
                fontSize: 20, height: 30, color: Theme.of(context).color8),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = AppWidget.getWidthScreen(context);
    final height = AppWidget.getHeightScreen(context);
    final SliderBloc sliderBloc = BlocProvider.of<SliderBloc>(context);
    return Scaffold(
      backgroundColor: white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container(
                  //     padding: const EdgeInsets.only(top: 48, left: 32),
                  //     alignment: Alignment.centerLeft,
                  //     child: Image.asset(
                  //       'images/logoDetail@3x.png',
                  //       fit: BoxFit.cover,
                  //       width: width / 2,
                  //     )),
                  Container(
                    height: height / 203 * 95,
                    padding: const EdgeInsets.only(top: 40),
                    child: BlocBuilder<SliderBloc, int>(
                      cubit: sliderBloc,
                      builder: (context, state) {
                        return PageView.builder(
                          itemCount: 2,
                          onPageChanged: (value) {
                            if (value > state) {
                              sliderBloc.add(SliderEvent.swipeRight);
                            } else {
                              sliderBloc.add(SliderEvent.swipeLeft);
                            }
                          },
                          itemBuilder: (context, index) {
                            return landing(context, index: index);
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: BlocBuilder<SliderBloc, int>(
                      cubit: sliderBloc,
                      builder: (context, state) {
                        return WalkThroughWidget.createIndicator(
                            lengthImage: 2, currentImage: state);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45),
                    child: OptionLogin(),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              EnvValue.version,
              style: AppWidget.simpleTextFieldStyle(
                  fontSize: 14, height: 21, color: grey600),
            ),
          )
        ],
      ),
    );
  }
}
