import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_habit_run/common/graphql/config.dart';
import 'package:flutter_habit_run/common/graphql/mutations.dart';
import 'package:flutter_habit_run/common/graphql/queries.dart';
import 'package:flutter_habit_run/common/model/run_history_model.dart';
import 'package:flutter_habit_run/common/model/user_model.dart';
import 'package:flutter_habit_run/common/route/routes.dart';
import 'package:graphql/client.dart';

class ApiHelper {
  Future<UserModel> getInfoUser({List<RunHistoryModel> run7Histories}) async {
    UserModel userModel;
    final User user = FirebaseAuth.instance.currentUser;
    await user.getIdToken().then((token) async {
      await Config.initializeClient(token)
          .value
          .query(QueryOptions(
              document: gql(Queries.getInfoUser),
              variables: <String, dynamic>{'id': user.uid}))
          .then((value) {
        userModel = UserModel.fromJson(value.data['User'][0]);
        if (userModel.avatar == null) {
          Config.initializeClient(token)
              .value
              .mutate(MutationOptions(
                  document: gql(Mutations.updateAvatar()),
                  variables: <String, dynamic>{
                    'id': user.uid,
                    'avatar': user.photoURL
                  }))
              .then((value) {
            userModel =
                UserModel.fromJson(value.data['update_User']['returning'][0]);
          });
        }
      });
      await Config.initializeClient(token)
          .value
          .query(QueryOptions(
              document: gql(Queries.get7DaysHistories),
              variables: <String, dynamic>{
                'user_id': user.uid,
                'date': DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day - 7)
                    .toIso8601String()
              }))
          .then((value) {
        for (Map<String, dynamic> runHistory in value.data['RunHistory']) {
          run7Histories.add(RunHistoryModel.fromJson(runHistory));
        }
      });
    });
    return userModel;
  }

  void prepareRun(BuildContext context) {
    if (Platform.isAndroid) {
      AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.countDown, (route) => false);
        }
      });
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.countDown, (route) => false);
    }
  }

  Widget icon(double height, double width,
      {double padding = 0, String imageAsset = 'images/money-10000@3x.png'}) {
    return Padding(
      padding: EdgeInsets.only(right: padding),
      child: Image.asset(imageAsset, height: height, width: width),
    );
  }

  Widget createImage(double height, double width, int index) {
    Widget image;
    switch (index) {
      case 0:
        image = icon(height / 5, width / 5);
        break;
      case 1:
        image = Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          icon(height / 5, width / 5, padding: 8),
          icon(height / 5, width / 5)
        ]);
        break;
      case 2:
        image = Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            children: [
              icon(height / 5, width / 5),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                icon(height / 5, width / 5, padding: 8),
                icon(height / 5, width / 5)
              ]),
            ],
          ),
        );
        break;
      case 3:
        image = icon(height / 4, width / 18 * 5);
        break;
      case 4:
        image = Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          icon(height / 4, width / 18 * 5, padding: 4),
          icon(height / 4, width / 18 * 5)
        ]);
        break;
      case 5:
        image = icon(height / 4, width / 8 * 3,
            imageAsset: 'images/money-200000@3x.png');
        break;
    }
    return image;
  }
}
