import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/constant/env.dart';
import 'package:flutter_habit_run/common/graphql/config.dart';
import 'package:flutter_habit_run/common/graphql/mutations.dart';
import 'package:flutter_habit_run/common/graphql/queries.dart';
import 'package:flutter_habit_run/common/graphql/subscription.dart';
import 'package:flutter_habit_run/common/model/daily_reward_model.dart';
import 'package:flutter_habit_run/common/model/goal_model.dart';
import 'package:flutter_habit_run/common/model/invite_model.dart';
import 'package:flutter_habit_run/common/model/room_model.dart';

import 'package:flutter_habit_run/common/model/run_history_model.dart';
import 'package:flutter_habit_run/common/route/routes.dart';
import 'package:flutter_habit_run/feature/home/api_helper.dart';
import 'package:flutter_habit_run/feature/home/screen/dialog_daily.dart';
import 'package:flutter_habit_run/feature/home/screen/run_history.dart';
import 'package:flutter_habit_run/feature/run_with_friends/bloc/listen_list_group/bloc_listen_list_group.dart';
import 'package:flutter_habit_run/feature/run_with_friends/widget/dialog_invite.dart';
import 'package:graphql/client.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../profile/screen/profile.dart';
import '../bloc/get_data_chart/bloc_get_data_chart.dart';
import '../bloc/get_reward_daily/bloc_get_reward_daily.dart';
import '../bloc/save_goal/bloc_save_goal.dart';
import '../bloc/save_info_user/bloc_save_info_user.dart';
import '../update_widget.dart';
import '../widget/app_bar_home.dart';
import '../widget/home_widget.dart';
import 'dash_board.dart';
import 'runner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({this.currentIndex = 0});
  final int currentIndex;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  List<String> listPathIcon = [];
  List<Widget> listWidget = [];
  int _currentIndex = 0;
  List<RunHistoryModel> run7Histories = [];
  PermissionStatus status;

  GetDataChartBloc getDataChartBloc;
  SaveInfoUserBloc saveInfoUserBloc;
  GetRewardDailyBloc getRewardDailyBloc;
  SaveGoalBloc saveGoalBloc;
  ListenListGroupBloc listenListGroupBloc;

  Future<void> getGoal() async {
    double distance;
    int steps = 0;
    GoalModel goalModel;
    DailyRewardModel dailyRewardModel;
    final User user = FirebaseAuth.instance.currentUser;
    await user.getIdToken().then((token) async {
      await Config.initializeClient(token)
          .value
          .query(QueryOptions(
              document: gql(Queries.getGoal),
              variables: <String, dynamic>{'user_id': user.uid}))
          .then((value) {
        goalModel = GoalModel.fromJson(value.data['Goal'][0]);
        saveGoalBloc.add(SaveGoal(goalModel: goalModel));
      });
      await Config.initializeClient(token)
          .value
          .query(QueryOptions(
              document: gql(Queries.getRewardDaily),
              variables: <String, dynamic>{'user_id': user.uid}))
          .then((value) async {
        if ((value.data['DailyReward'] as List).isNotEmpty) {
          dailyRewardModel =
              DailyRewardModel.fromJson(value.data['DailyReward'][0]);
        } else {
          await Config.initializeClient(token).value.mutate(MutationOptions(
                  document: gql(Mutations.insertRewardDaily()),
                  variables: <String, dynamic>{
                    'user_id': user.uid,
                    'current_daily': DateTime.now()
                        .subtract(const Duration(days: 2))
                        .toIso8601String()
                  }));
          dailyRewardModel = DailyRewardModel(
              daysInRow: 0,
              currentDaily: DateTime.now()
                  .subtract(const Duration(days: 2))
                  .toIso8601String());
        }
        getRewardDailyBloc
            .add(SaveStateGetRewardDaily(dailyRewardModel: dailyRewardModel));
      });
      await Config.initializeClient(token)
          .value
          .query(QueryOptions(
              document: gql(Queries.getSumDistanceToday),
              variables: <String, dynamic>{
                'user_id': user.uid,
                'date': DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day)
                    .toIso8601String()
              }))
          .then((value) {
        distance = double.tryParse(value.data['RunHistory_aggregate']
                    ['aggregate']['sum']['distance']
                .toString()) ??
            0.0;
        steps = value.data['RunHistory_aggregate']['aggregate']['sum']
                ['steps'] ??
            0;
        updateHomeWidget('Today', distance.toStringAsFixed(2),
            (steps / goalModel.step * 100).toInt());
      });
    });
  }

  Future<void> requestActivity() async {
    if (Platform.isAndroid) {
      status = await Permission.activityRecognition.request();
    } else if (Platform.isIOS) {
      status = await Permission.sensors.request();
    }
    if (status.isDenied) {
      if (Platform.isIOS) {
        await AppWidget.showDialogSetting(context, content: EnvValue.requestAR);
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          requestActivity();
        });
      }
    } else if (status.isPermanentlyDenied) {
      await AppWidget.showDialogSetting(context, content: EnvValue.requestAR);
    } else {
      setState(() {});
    }
  }

  Future<void> listenInvite() async {
    final User user = FirebaseAuth.instance.currentUser;
    await user.getIdToken().then((token) {
      Config.initializeClient(token)
          .value
          .subscribe(SubscriptionOptions(
              document: gql(Subscription.listenInvite),
              variables: <String, dynamic>{'guest_email': user.email}))
          .listen((event) {
        if (event.data['Invite'].isNotEmpty) {
          final InviteModel inviteModel =
              InviteModel.fromJson(event.data['Invite'][0]);
          DialogInvite().showDialogInvite(
              context: context,
              pS: 'ACCEPT',
              nS: 'NO,THANKS',
              pF: () async {
                DialogInvite().insertMember(
                    roomId: inviteModel.roomId,
                    ownerGroupId: inviteModel.userId);
                DialogInvite().deleteInvite(roomId: inviteModel.roomId);
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.homeScreen, (route) => false,
                    arguments: const HomeScreen());
              },
              nF: () {
                DialogInvite().deleteInvite(roomId: inviteModel.roomId);
                Navigator.of(context).pop(true);
              },
              content:
                  '${inviteModel.ownerName} invited you to join the running team with ${inviteModel.gender}');
        }
      });
    });
  }

  Future<void> listenListGroup() async {
    final User user = FirebaseAuth.instance.currentUser;
    await user.getIdToken().then((token) async {
      Config.initializeClient(token)
          .value
          .subscribe(SubscriptionOptions(
              document: gql(Subscription.listenListGroup),
              variables: <String, dynamic>{'user_id': user.uid}))
          .listen((event) {
        final List<RoomModel> groups = [];
        if (event.data['RoomMember'].isNotEmpty) {
          for (var room in event.data['RoomMember']) {
            Config.initializeClient(token)
                .value
                .query(QueryOptions(
                    document: gql(Queries.getGroup),
                    variables: <String, dynamic>{'id': room['room_id']}))
                .then((value) {
              if (value.data['Room'].isNotEmpty) {
                groups.add(RoomModel.fromJson(value.data['Room'][0]));
                listenListGroupBloc.add(GetListGroupEvent(groups: groups));
              }
            });
          }
        } else {
          listenListGroupBloc.add(GetListGroupEvent(groups: groups));
        }
      });
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    getDataChartBloc = BlocProvider.of<GetDataChartBloc>(context);
    saveGoalBloc = BlocProvider.of<SaveGoalBloc>(context);
    saveInfoUserBloc = BlocProvider.of<SaveInfoUserBloc>(context);
    getRewardDailyBloc = BlocProvider.of<GetRewardDailyBloc>(context);
    listenListGroupBloc = BlocProvider.of<ListenListGroupBloc>(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    listPathIcon = [
      'images/fi_home@3x.png',
      'images/runner@3x.png',
      'images/fi_bar-chart-2@3x.png',
      'images/profile@3x.png',
    ];
    requestActivity().whenComplete(() {
      _currentIndex = widget.currentIndex;
      listenInvite();
      listenListGroup();
      getGoal().whenComplete(() {
        if (status.isGranted) {
          if (getRewardDailyBloc.showDialog) {
            Future.delayed(const Duration(seconds: 3), () {
              showGeneralDialog(
                  context: context,
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: DailyDialog()),
                  transitionBuilder: (context, anim1, anim2, child) {
                    return child;
                  });
            });
          }
        }
      });
      ApiHelper().getInfoUser(run7Histories: run7Histories).then((value) {
        if (mounted) {
          setState(() {
            listWidget = [
              DashBoard(),
              Runner(),
              RunHistory(),
              Profile(
                userBadges: value.badges,
              ),
            ];
            getDataChartBloc.add(GetDataEvent(runHistories: run7Histories));
            saveInfoUserBloc.add(SaveInfoEvent(userModel: value));
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final width = AppWidget.getWidthScreen(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: status.isGranted
          ? Scaffold(
              appBar: (_currentIndex == 2 || _currentIndex == 3)
                  ? null
                  : AppBarHome().createAppBar(context: context, width: width),
              body: listWidget.isEmpty
                  ? const Center(
                      child: CupertinoActivityIndicator(animating: true))
                  : listWidget.elementAt(_currentIndex),
              bottomNavigationBar: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  onTap: (value) {
                    setState(() {
                      _currentIndex = value;
                    });
                  },
                  items: [
                    HomeWidget.createItemNav(
                        context: context,
                        pathIcon: listPathIcon[0],
                        label: 'DashBoard'),
                    HomeWidget.createItemNav(
                        context: context,
                        pathIcon: listPathIcon[1],
                        label: 'Runner'),
                    HomeWidget.createItemNav(
                        context: context,
                        pathIcon: listPathIcon[2],
                        label: 'History'),
                    HomeWidget.createItemNav(
                        context: context,
                        pathIcon: listPathIcon[3],
                        label: 'Profile'),
                  ],
                ),
              ),
            )
          : Scaffold(
              body: Center(
                  child: AppWidget.typeButtonStartAction(
                      input: 'Go to Setting',
                      horizontal: 24,
                      miniSizeHorizontal: 0,
                      bgColor: ultramarineBlue,
                      onPressed: () async {
                        await AppWidget.showDialogSetting(context,
                            content: EnvValue.requestAR);
                      })),
            ),
    );
  }
}
