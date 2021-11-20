import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/constant/env.dart';
import 'package:flutter_habit_run/common/route/routes.dart';
import 'package:flutter_habit_run/common/util/authentication_facebook.dart';
import 'package:flutter_habit_run/common/util/authentication_google.dart';
import '../bloc/dark_mode/bloc_dark_mode.dart';
import '../widget/my_badges.dart';
import '../widget/profile_item.dart';
import '../widget/sliver_app_bar_custom.dart';

class Profile extends StatefulWidget {
  Profile({this.userBadges});
  final List<int> userBadges;
  final List<Map<String, dynamic>> profileItem = [
    <String, dynamic>{
      'image': 'images/star@3x.png',
      'title': 'All Badges',
      'subtitle': 'See all badges you can get',
    },
    <String, dynamic>{
      'image': 'images/edit_profile@3x.png',
      'title': 'Edit Profile',
    },
    <String, dynamic>{
      'image': 'images/notification@3x.png',
      'title': 'Notifications',
    },
    <String, dynamic>{
      'image': 'images/moon@3x.png',
      'title': 'Dark mode',
      'subtitle': 'Switch dark/light mode',
    },
  ];
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final height = AppWidget.getHeightScreen(context);
    final width = AppWidget.getWidthScreen(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width, height / 58 * 15),
        child: SliverAppBarCustom(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyBadges(
              userBadges: widget.userBadges,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: AppWidget.divider(context),
            ),
            ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 24, left: 32, right: 32),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ProfileItem(
                    item: widget.profileItem[index],
                    index: index,
                  );
                },
                separatorBuilder: (context, index) {
                  return AppWidget.divider(context);
                },
                itemCount: widget.profileItem.length),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 24),
            //   child: AppWidget.premium(context),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
              child: AppWidget.typeButtonStartAction(
                  onPressed: () async {
                    BlocProvider.of<DarkModeBloc>(context)
                        .add(const ChangeDarkMode(darkMode: false));
                    await FirebaseAuth.instance.signOut();
                    await AuthenticationFacebook.logOut(context: context);
                    await AuthenticationGoogle.signOut(context: context);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        Routes.walkThrough, (route) => false);
                  },
                  input: 'Logout',
                  bgColor: ultramarineBlue,
                  vertical: 12),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                EnvValue.version,
                style: AppWidget.simpleTextFieldStyle(
                    fontSize: 14, height: 21, color: grey600),
              ),
            )
          ],
        ),
      ),
    );
  }
}
