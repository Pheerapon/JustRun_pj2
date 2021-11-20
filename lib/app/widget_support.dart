import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/constant/env.dart';
import 'package:flutter_habit_run/common/graphql/config.dart';
import 'package:flutter_habit_run/common/graphql/mutations.dart';
import 'package:flutter_habit_run/common/graphql/queries.dart';
import 'package:flutter_habit_run/common/model/user_model.dart';
import 'package:flutter_habit_run/common/route/routes.dart';
import 'package:flutter_habit_run/feature/home/bloc/save_info_user/bloc_save_info_user.dart';
import 'package:flutter_habit_run/feature/home/screen/home.dart';
import 'package:flutter_habit_run/feature/run_with_friends/widget/dialog_invite.dart';
import 'package:graphql/client.dart';
import 'package:permission_handler/permission_handler.dart';

import 'opacity_clicked.dart';

mixin AppWidget {
  static double getHeightScreen(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getWidthScreen(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static Future<void> showDialogCustom({BuildContext context}) async {
    showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      barrierColor: black.withOpacity(0.1),
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: const CupertinoActivityIndicator(
              animating: true,
            ));
      },
    );
  }

  static Widget createSimpleAppBar(
      {BuildContext context,
      bool hasPop = true,
      bool hasBackground = false,
      bool hasLeading = true,
      String title,
      Function onTap}) {
    return AppBar(
      elevation: 0,
      backgroundColor: hasBackground ? Theme.of(context).color15 : null,
      leading: hasLeading
          ? OpacityClicked(
              child: GestureDetector(
                onTap: () {
                  if (hasPop) {
                    Navigator.of(context).pop();
                  }
                },
                child: Icon(
                  Icons.keyboard_arrow_left,
                  size: 24,
                  color: Theme.of(context).color9,
                ),
              ),
            )
          : const SizedBox(),
      centerTitle: true,
      title: title == null
          ? null
          : Text(
              title,
              style: AppWidget.simpleTextFieldStyle(
                  fontSize: 16, height: 18, color: black),
            ),
      actions: [
        onTap != null
            ? Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    OpacityClicked(
                      child: GestureDetector(
                        onTap: onTap,
                        child: Text(
                          'SKIP',
                          style: AppWidget.boldTextFieldStyle(
                              fontSize: 12, height: 18, color: ultramarineBlue),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : const SizedBox()
      ],
    );
  }

  static TextStyle simpleTextFieldStyle(
      {Color color,
      double fontSize,
      double height,
      FontStyle fontStyle,
      FontWeight fontWeight,
      String fontFamily = 'SFProDisplay',
      TextDecoration textDecoration}) {
    return TextStyle(
        color: color ?? white,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.w400,
        decoration: textDecoration ?? TextDecoration.none,
        height: height / fontSize,
        fontStyle: fontStyle ?? FontStyle.normal,
        fontFamily: fontFamily);
  }

  static TextStyle boldTextFieldStyle(
      {Color color,
      double fontSize,
      double height,
      FontStyle fontStyle,
      FontWeight fontWeight,
      String fontFamily = 'SFProDisplay',
      TextDecoration textDecoration}) {
    return TextStyle(
        color: color ?? white,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.w700,
        decoration: textDecoration ?? TextDecoration.none,
        height: height / fontSize,
        fontStyle: fontStyle ?? FontStyle.normal,
        fontFamily: fontFamily);
  }

  static Widget typeButtonStartAction(
      {double fontSize,
      double height,
      double vertical,
      double horizontal,
      Function onPressed,
      Color bgColor,
      double miniSizeHorizontal = double.infinity,
      Color textColor,
      String input,
      FontWeight fontWeight,
      double borderRadius = 16,
      double sizeAsset = 16,
      Color colorAsset,
      String icon}) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
            vertical: vertical ?? 13, horizontal: horizontal ?? 0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        backgroundColor: bgColor ?? ultramarineBlue,
        minimumSize: Size(miniSizeHorizontal, 0),
        primary: white,
      ),
      onPressed: onPressed,
      child: icon == null
          ? Text(
              input,
              textAlign: TextAlign.center,
              style: AppWidget.simpleTextFieldStyle(
                  fontSize: fontSize ?? 16,
                  color: textColor ?? white,
                  fontWeight: fontWeight ?? FontWeight.w500,
                  height: height ?? 24),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    SizedBox(
                        width: constraints.maxWidth * 0.3,
                        child: Image.asset(
                          icon,
                          width: sizeAsset,
                          height: sizeAsset,
                          color: colorAsset,
                        )),
                    Text(
                      input,
                      textAlign: TextAlign.center,
                      style: AppWidget.simpleTextFieldStyle(
                          fontSize: fontSize ?? 16,
                          color: textColor ?? white,
                          fontWeight: fontWeight ?? FontWeight.w500,
                          height: height ?? 24),
                    ),
                  ],
                );
              },
            ),
    );
  }

  static SnackBar customSnackBar({@required String content, Color color}) {
    return SnackBar(
      duration: const Duration(milliseconds: 700),
      backgroundColor: color ?? btnGoogle,
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: AppWidget.simpleTextFieldStyle(
            color: white, fontSize: 14, height: 21),
      ),
    );
  }

  static Widget divider(BuildContext context, {double vertical = 24}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical),
      child: Divider(
        thickness: 1,
        color: Theme.of(context).color16,
      ),
    );
  }

  // static Widget premium(BuildContext context) {
  //   UserModel userModel;
  //   return BlocBuilder<SaveInfoUserBloc, SaveInfoUserState>(
  //     builder: (context, state) {
  //       if (state is SaveInfoUserSuccess) {
  //         userModel = state.userModel;
  //       }
  //       return userModel.isPremium
  //           ? const SizedBox()
  //           : GestureDetector(
  //               onTap: () {
  //                 if (userModel.money < 10000) {
  //                   DialogInvite().showDialogInvite(
  //                       context: context,
  //                       pS: 'RUN NOW',
  //                       nS: 'OK,THANKS',
  //                       pF: () {
  //                         Navigator.pushNamedAndRemoveUntil(
  //                             context, Routes.homeScreen, (route) => false,
  //                             arguments: const HomeScreen(currentIndex: 1));
  //                       },
  //                       nF: () {
  //                         Navigator.of(context).pop(true);
  //                       },
  //                       content:
  //                           'You have ${userModel.money} Point and missing ${10000 - userModel.money} Point to exchange go premium');
  //                 } else {
  //                   DialogInvite().showDialogInvite(
  //                       context: context,
  //                       pS: 'ACCEPT',
  //                       nS: 'NO,THANKS',
  //                       pF: () {
  //                         final User user = FirebaseAuth.instance.currentUser;
  //                         user.getIdToken().then((token) async {
  //                           await Config.initializeClient(token)
  //                               .value
  //                               .mutate(MutationOptions(
  //                                   document: gql(Mutations.updatePremium()),
  //                                   variables: <String, dynamic>{
  //                                     'id': user.uid,
  //                                     'is_premium': true,
  //                                     'money': userModel.money - 10000
  //                                   }))
  //                               .then((value) {
  //                             Navigator.of(context).pop(true);
  //                             ScaffoldMessenger.of(context).showSnackBar(
  //                                 AppWidget.customSnackBar(
  //                                     content:
  //                                         'You registered Premium successfully',
  //                                     color: caribbeanGreen));
  //                           });
  //                           Config.initializeClient(token)
  //                               .value
  //                               .query(QueryOptions(
  //                                   document: gql(Queries.getInfoUser),
  //                                   variables: <String, dynamic>{
  //                                     'id': user.uid
  //                                   }))
  //                               .then((value) {
  //                             BlocProvider.of<SaveInfoUserBloc>(context).add(
  //                                 SaveInfoEvent(
  //                                     userModel: UserModel.fromJson(
  //                                         value.data['User'][0])));
  //                           });
  //                         });
  //                       },
  //                       nF: () {
  //                         Navigator.of(context).pop(true);
  //                       },
  //                       content:
  //                           'Do you want to exchange 10,000P to get go premium ?');
  //                 }
  //               },
  //               child: Container(
  //                   height: 98,
  //                   padding: const EdgeInsets.all(16),
  //                   margin: const EdgeInsets.symmetric(vertical: 16),
  //                   decoration: BoxDecoration(
  //                       color: caribbeanGreen,
  //                       borderRadius: BorderRadius.circular(16)),
  //                   alignment: Alignment.center,
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Row(
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Padding(
  //                                 padding: const EdgeInsets.only(right: 8),
  //                                 child: Image.asset('images/premium@3x.png',
  //                                     width: 28, height: 28),
  //                               ),
  //                               Text(
  //                                 'Go Premium',
  //                                 style: AppWidget.simpleTextFieldStyle(
  //                                     fontSize: 20,
  //                                     height: 23.87,
  //                                     color: white,
  //                                     fontWeight: FontWeight.w600),
  //                               )
  //                             ],
  //                           ),
  //                           Image.asset('images/arrow-right-o@3x.png',
  //                               width: 24, height: 24, color: white)
  //                         ],
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.only(top: 8),
  //                         child: Text('10,000 Point to Remove Ads',
  //                             style: AppWidget.simpleTextFieldStyle(
  //                                 fontSize: 16,
  //                                 height: 24,
  //                                 fontWeight: FontWeight.w600,
  //                                 color: white.withOpacity(0.7))),
  //                       )
  //                     ],
  //                   )),
  //             );
  //     },
  //   );
  // }

  static Future<void> showDialogSetting(BuildContext context,
      {String content}) async {
    await showDialog<dynamic>(
      context: context,
      builder: (context) {
        final height = AppWidget.getHeightScreen(context);
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: white,
          child: Container(
            padding: const EdgeInsets.all(30),
            height: height / 116 * 56,
            child: Column(
              children: [
                Expanded(child: Image.asset('images/group@3x.png')),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text(
                    content ?? EnvValue.requestLocation,
                    textAlign: TextAlign.center,
                    style: AppWidget.simpleTextFieldStyle(
                        fontSize: 16, height: 24, color: black),
                  ),
                ),
                AppWidget.typeButtonStartAction(
                    input: 'Go to Setting',
                    horizontal: 24,
                    miniSizeHorizontal: 0,
                    bgColor: ultramarineBlue,
                    onPressed: () async {
                      await openAppSettings();
                    })
              ],
            ),
          ),
        );
      },
    );
  }
}
