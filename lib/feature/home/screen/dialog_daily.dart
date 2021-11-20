import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/graphql/config.dart';
import 'package:flutter_habit_run/common/graphql/mutations.dart';
import 'package:flutter_habit_run/common/graphql/queries.dart';
import 'package:flutter_habit_run/common/model/daily_reward_model.dart';
import 'package:flutter_habit_run/common/model/user_model.dart';
// import 'package:flutter_habit_run/feature/home/widget/ads_banner.dart';
import 'package:graphql/client.dart';

import '../bloc/get_reward_daily/bloc_get_reward_daily.dart';
import '../bloc/save_info_user/bloc_save_info_user.dart';
import '../widget/home_widget.dart';

class DailyDialog extends StatefulWidget {
  @override
  _DailyDialogState createState() => _DailyDialogState();
}

class _DailyDialogState extends State<DailyDialog>
    with SingleTickerProviderStateMixin {
  SaveInfoUserBloc saveInfoUserBloc;
  bool finishAds = false;
  UserModel userModel;
  int daysInRow;
  Animation<double> animation;
  AnimationController controller;
  GetRewardDailyBloc getRewardDailyBloc;

  Widget itemDay(int index, int daysinRow, bool checked) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${(daysInRow ~/ 5) * 5 + index + 1}',
            style: AppWidget.simpleTextFieldStyle(
                fontSize: 12,
                height: 14.06,
                fontFamily: 'Roboto',
                color: checked
                    ? white.withOpacity(0.5)
                    : grey600.withOpacity(0.5)),
          ),
        ),
        Image.asset('images/icon_money@3x.png', width: 16, height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'x100',
            style: AppWidget.boldTextFieldStyle(
                fontSize: 14,
                height: 16.41,
                fontFamily: 'Roboto',
                fontStyle: FontStyle.italic,
                color: checked ? white : grey1000),
          ),
        )
      ],
    );
  }

  Future<void> updateDailyReward(BuildContext context, int daysInRow) async {
    final User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.getIdToken().then((token) async {
        setState(() {
          finishAds = true;
        });
        getRewardDailyBloc.add(SaveStateGetRewardDaily(
            dailyRewardModel: DailyRewardModel(
                daysInRow: daysInRow,
                currentDaily: DateTime.now()
                    .subtract(const Duration(days: 1))
                    .toIso8601String())));
        checkIn(controller);
        await Config.initializeClient(token).value.mutate(MutationOptions(
                document: gql(Mutations.updateRewardDaily()),
                variables: <String, dynamic>{
                  'user_id': user.uid,
                  'days_row': daysInRow,
                  'current_daily': DateTime.now().toIso8601String()
                }));
        await Config.initializeClient(token).value.mutate(MutationOptions(
                document: gql(Mutations.updateMoney()),
                variables: <String, dynamic>{
                  'user_id': user.uid,
                  'money': saveInfoUserBloc.userModel.money + 100
                }));
        Config.initializeClient(token)
            .value
            .query(QueryOptions(
                document: gql(Queries.getInfoUser),
                variables: <String, dynamic>{'id': user.uid}))
            .then((value) {
          saveInfoUserBloc.add(SaveInfoEvent(
              userModel: UserModel.fromJson(value.data['User'][0])));
        });
      });
    }
  }

  Future<void> checkDaysInRow(int daysInRow, List<int> badges) async {
    switch (daysInRow) {
      case 3:
        if (!badges.contains(6)) {
          badges.add(6);
          await updateBadges(badges);
        }
        break;
      case 7:
        if (!badges.contains(7)) {
          badges.add(7);
          await updateBadges(badges);
        }
        break;
      case 15:
        if (!badges.contains(8)) {
          badges.add(8);
          await updateBadges(badges);
        }
        break;
      case 30:
        if (!badges.contains(9)) {
          badges.add(9);
          await updateBadges(badges);
        }
        break;
      case 66:
        if (!badges.contains(12)) {
          badges.add(12);
          await updateBadges(badges);
        }
        break;
      case 100:
        if (!badges.contains(13)) {
          badges.add(13);
          await updateBadges(badges);
        }
        break;
    }
  }

  Future<void> updateBadges(List<int> badges) async {
    final User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.getIdToken().then((token) async {
        await Config.initializeClient(token).value.mutate(MutationOptions(
                document: gql(Mutations.updateBadges()),
                variables: <String, dynamic>{
                  'id': user.uid,
                  'badges': badges.toSet().toString()
                }));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    animation = Tween<double>(begin: 1, end: 1.2).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));
  }

  void checkIn(AnimationController controller) {
    setState(() {
      controller.forward();
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    saveInfoUserBloc = BlocProvider.of<SaveInfoUserBloc>(context);
    getRewardDailyBloc = BlocProvider.of<GetRewardDailyBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(true);
                },
                child: Icon(Icons.close,
                    color: Theme.of(context).color9, size: 24),
              ),
              Row(
                children: [
                  BlocBuilder<SaveInfoUserBloc, SaveInfoUserState>(
                    builder: (context, state) {
                      if (state is SaveInfoUserSuccess) {
                        userModel = state.userModel;
                      }
                      return userModel == null
                          ? const SizedBox()
                          : Row(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Image.asset(
                                        'images/icon_money@3x.png',
                                        width: 16,
                                        height: 24)),
                                HomeWidget.money(
                                    context: context,
                                    amount: userModel.money
                                        .toString()
                                        .replaceAllMapped(HomeWidget.reg,
                                            HomeWidget.mathFunc))
                              ],
                            );
                    },
                  )
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Check in and',
                  style: Theme.of(context).textTheme.headline1,
                ),
                Text(
                  'Get Points',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ],
            ),
          ),
          Center(
              child: Image.asset('gif/giphy.gif',
                  width: 56, height: 66, fit: BoxFit.cover)),
          BlocBuilder<GetRewardDailyBloc, GetRewardDailyState>(
            builder: (context, state) {
              if (state is GetRewardDailySuccess) {
                daysInRow = state.dailyRewardModel.daysInRow;
              }
              return Column(
                children: [
                  Text(
                    '$daysInRow days steak!',
                    style: AppWidget.boldTextFieldStyle(
                        fontSize: 32, height: 42, color: ultramarineBlue),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List<Widget>.generate(5, (index) {
                        final bool checked = daysInRow % 5 > index;
                        return (daysInRow % 5 - 1) == index
                            ? Expanded(
                                child: ScaleTransition(
                                  scale: animation,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 24, horizontal: 4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: checked
                                                ? ultramarineBlue
                                                : Theme.of(context).color18),
                                        color:
                                            checked ? ultramarineBlue : white),
                                    child: itemDay(index, daysInRow, checked),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 24, horizontal: 4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: checked
                                              ? ultramarineBlue
                                              : Theme.of(context).color18),
                                      color: checked ? ultramarineBlue : white),
                                  child: itemDay(index, daysInRow, checked),
                                ),
                              );
                      })),
                  finishAds
                      ? AppWidget.typeButtonStartAction(
                          input: 'Checkin', bgColor: grey500, onPressed: () {})
                      : AppWidget.typeButtonStartAction(
                          input: 'Checkin',
                          bgColor: ultramarineBlue,
                          onPressed: () {
                            updateDailyReward(context, daysInRow + 1);
                            checkDaysInRow(daysInRow + 1,
                                saveInfoUserBloc.userModel.badges);
                          }),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 8),
                  //   child: AppWidget.premium(context),
                  // )
                ],
              );
            },
          ),
          const Expanded(child: SizedBox()),
          // const AdsBanner()
        ],
      ),
    ));
  }
}
