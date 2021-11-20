import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/model/user_model.dart';
import 'package:flutter_habit_run/common/util/format_time.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../bloc/save_info_user/save_info_user_bloc.dart';
import '../widget/home_widget.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({this.steps, this.distance, this.uint8list, this.avg});
  final String steps;
  final double distance;
  final Uint8List uint8list;
  final int avg;

  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  GlobalKey globalKey = GlobalKey();

  Future<void> screenShot() async {
    try {
      final RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      final directory = (await getApplicationDocumentsDirectory()).path;
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData.buffer.asUint8List();
      final File imgFile =
          File('$directory/${DateTime.now().toIso8601String()}.png');
      await imgFile.writeAsBytes(pngBytes).whenComplete(() {
        final RenderBox box = context.findRenderObject();
        Share.shareFiles([imgFile.path],
                subject: 'Screenshot + Share',
                text: 'Finish run picture',
                sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size)
            .whenComplete(() {
          Navigator.of(context).pop();
        });
      });
    } on PlatformException catch (e) {
      print('Exception while taking screenshot:' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = AppWidget.getWidthScreen(context);
    final height = AppWidget.getHeightScreen(context);
    final bool hasFemale =
        BlocProvider.of<SaveInfoUserBloc>(context).userModel.gender ==
            Gender.Female;
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: AppWidget.typeButtonStartAction(
            input: 'Share Now',
            textColor: ultramarineBlue,
            onPressed: () async {
              await screenShot();
            },
            bgColor: ultramarineBlue.withOpacity(0.1)),
      ),
      body: RepaintBoundary(
        key: globalKey,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: AppBar(
              elevation: 0,
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    size: 24,
                    color: Theme.of(context).color9,
                  )),
              flexibleSpace: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Image.asset(
                  hasFemale ? 'gif/female_running.gif' : 'gif/male_running.gif',
                  width: height / 203 * 30,
                  height: height / 203 * 30,
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              Image.memory(widget.uint8list, width: double.infinity),
              IgnorePointer(
                child: Container(
                  width: width,
                  height: height,
                  decoration:
                      BoxDecoration(gradient: Theme.of(context).colorGoogle),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 34),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(
                            text:
                                'Today, ${FormatTime.formatTime(format: Format.dMy)} ',
                            style: AppWidget.simpleTextFieldStyle(
                                fontSize: 14,
                                height: 21,
                                color: Theme.of(context).color8),
                            children: [
                          TextSpan(
                              text: '(AVG: ${widget.avg.toInt()}m/s)',
                              style: AppWidget.simpleTextFieldStyle(
                                  fontSize: 14, height: 21, color: azure))
                        ])),
                    Padding(
                      padding: const EdgeInsets.only(top: 1, bottom: 39),
                      child: HomeWidget.createDistance(
                          context: context,
                          amount: widget.distance,
                          title: 'Km'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HomeWidget.createGroupText(
                            context: context,
                            amount: widget.steps.toString(),
                            title: 'Step'),
                        HomeWidget.createGroupText(
                            context: context, title: 'Time'),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
