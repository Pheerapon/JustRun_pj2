import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/route/routes.dart';
import 'package:flutter_habit_run/feature/home/screen/home.dart';
import '../widget/item_ranking.dart';
import '../widget/member_avatar.dart';
import '../widget/menu_dialog_group.dart';

class RunWithFriends extends StatefulWidget {
  const RunWithFriends({Key key, this.nameGroup, this.roomId, this.ownerId})
      : super(key: key);
  final String nameGroup;
  final int roomId;
  final String ownerId;
  @override
  _RunWithFriendsState createState() => _RunWithFriendsState();
}

class _RunWithFriendsState extends State<RunWithFriends>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.keyboard_arrow_left,
            size: 24,
            color: Theme.of(context).color9,
          ),
        ),
        title: Text(
          widget.nameGroup,
          style: AppWidget.boldTextFieldStyle(
              fontSize: 20, height: 24, color: Theme.of(context).color7),
        ),
        centerTitle: true,
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 8),
        //     child:
        //         MenuDialogGroup(roomId: widget.roomId, ownerId: widget.ownerId),
        //   )
        // ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 16),
                  child: Text(
                    ' ',
                    style: AppWidget.simpleTextFieldStyle(
                        fontSize: 16,
                        height: 24,
                        color: Theme.of(context).color4),
                  ),
                ),
                MemberAvatar(
                    roomId: widget.roomId,
                    ownerId: widget.ownerId,
                    showInvite: true),
                // Padding(
                //   padding: const EdgeInsets.only(top: 26, bottom: 20),
                //   child: Row(
                //     children: [
                //       Image.asset('images/ranking_list@3x.png',
                //           width: 32, height: 32),
                //       Padding(
                //         padding: const EdgeInsets.only(left: 8),
                //         child: Text(
                //           'Ranking lists',
                //           style: AppWidget.boldTextFieldStyle(
                //               fontSize: 18,
                //               height: 28,
                //               color: Theme.of(context).color8),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                // Container(
                //   height: 40,
                //   decoration: BoxDecoration(
                //     color: ultramarineBlue.withOpacity(0.1),
                //     borderRadius: BorderRadius.circular(20),
                //   ),
                //   child: TabBar(
                //     indicator: BoxDecoration(
                //       borderRadius: BorderRadius.circular(20),
                //       color: ultramarineBlue,
                //     ),
                //     controller: _controller,
                //     labelColor: white,
                //     unselectedLabelColor: ultramarineBlue,
                //     labelStyle: AppWidget.simpleTextFieldStyle(
                //         fontSize: 14, height: 21, color: white),
                //     unselectedLabelStyle: AppWidget.simpleTextFieldStyle(
                //         fontSize: 14, height: 21, color: ultramarineBlue),
                //     tabs: const [
                //       Text('Day'),
                //       Text('Week'),
                //       Text('Month'),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(controller: _controller, children: [
              ItemRanking(
                  typeRank: TypeRank.Day,
                  roomId: widget.roomId,
                  ownerId: widget.ownerId),
              ItemRanking(
                  typeRank: TypeRank.Weak,
                  roomId: widget.roomId,
                  ownerId: widget.ownerId),
              ItemRanking(
                  typeRank: TypeRank.Month,
                  roomId: widget.roomId,
                  ownerId: widget.ownerId),
            ]),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
        child: AppWidget.typeButtonStartAction(
            input: 'Run Now',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.homeScreen, (route) => false,
                  arguments: const HomeScreen(currentIndex: 1));
            },
            bgColor: ultramarineBlue),
      ),
    );
  }
}
