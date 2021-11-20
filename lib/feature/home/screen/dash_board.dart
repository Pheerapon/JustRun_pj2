import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/route/routes.dart';
import 'package:flutter_habit_run/common/util/format_time.dart';
// import 'package:flutter_habit_run/feature/home/widget/ads_native.dart';
import 'package:flutter_habit_run/feature/home/widget/get_reward.dart';

import '../bloc/get_data_chart/bloc_get_data_chart.dart';
import '../widget/chart.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<List<int>> runHistory7Day = [];
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Today, ${FormatTime.formatTime(format: Format.Mdy)}',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: BlocBuilder<GetDataChartBloc, GetDataChartState>(
                builder: (context, state) {
                  if (state is GetDataChartSuccess) {
                    runHistory7Day = state.runHistory7Day;
                  }
                  return RichText(
                    text: TextSpan(
                      text: runHistory7Day.last.isNotEmpty
                          ? runHistory7Day.last
                              .reduce((value, element) => value + element)
                              .toString()
                          : '0',
                      style: AppWidget.boldTextFieldStyle(
                          fontSize: 32,
                          height: 37.5,
                          color: Theme.of(context).color10,
                          fontFamily: 'Futura',
                          fontStyle: FontStyle.italic),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Steps',
                            style: Theme.of(context).textTheme.bodyText1),
                      ],
                    ),
                  );
                },
              ),
            ),
            GetReward(),
            Chart(),
            Container(
                height: 72,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: caribbeanGreen,
                    borderRadius: BorderRadius.circular(16)),
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.listGroup);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Run with friends ',
                        style: AppWidget.simpleTextFieldStyle(
                            fontSize: 20,
                            height: 23.87,
                            color: white,
                            fontWeight: FontWeight.w600),
                      ),
                      Image.asset('images/arrow-right-o@3x.png',
                          width: 24, height: 24, color: white)
                    ],
                  ),
                )),
            // const AdsNative()
          ],
        ),
      ),
    );
  }
}
