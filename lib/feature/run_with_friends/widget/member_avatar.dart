import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/constant/env.dart';
import 'package:flutter_habit_run/common/graphql/config.dart';
import 'package:flutter_habit_run/common/graphql/queries.dart';
import 'package:flutter_habit_run/common/graphql/subscription.dart';
import 'package:flutter_habit_run/common/model/room_member_model.dart';
import 'package:flutter_habit_run/common/route/routes.dart';
import 'package:graphql/client.dart';

import '../screen/invite_friends.dart';

class MemberAvatar extends StatefulWidget {
  const MemberAvatar({Key key, this.roomId, this.ownerId, this.showInvite})
      : super(key: key);
  final int roomId;
  final String ownerId;
  final bool showInvite;
  @override
  State<MemberAvatar> createState() => _MemberAvatarState();
}

class _MemberAvatarState extends State<MemberAvatar> {
  User user = FirebaseAuth.instance.currentUser;

  Future<List<RoomMemberModel>> getMembers() async {
    final List<RoomMemberModel> roomMembers = [];
    await user.getIdToken().then((token) async {
      await Config.initializeClient(token)
          .value
          .query(QueryOptions(
              document: gql(Queries.getRoomMember),
              variables: <String, dynamic>{'room_id': widget.roomId}))
          .then((value) {
        for (var member in value.data['RoomMember']) {
          roomMembers.add(RoomMemberModel.fromJson(member));
        }
      });
    });
    return roomMembers;
  }

  Future<void> listenMember() async {
    await user.getIdToken().then((token) async {
      Config.initializeClient(token)
          .value
          .subscribe(SubscriptionOptions(
              document: gql(Subscription.listenRoomMember),
              variables: <String, dynamic>{'room_id': widget.roomId}))
          .listen((event) async {
        if (mounted) {
          setState(() {
            getMembers();
          });
        }
      });
    });
  }

  Widget listAvatar(RoomMemberModel roomMemberModel) {
    return Align(
      widthFactor: roomMemberModel.avatar != null ? 1.2 : 0.8,
      child: Stack(clipBehavior: Clip.none, children: [
        roomMemberModel.avatar != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(roomMemberModel.avatar))
            : CircleAvatar(
                radius: 24,
                backgroundColor: AdHelper()
                    .colorAvt[Random().nextInt(AdHelper().colorAvt.length)],
                child: Image.asset('images/face@3x.png'),
              ),
        roomMemberModel.userId == roomMemberModel.ownerGroupId
            ? Positioned(
                bottom: 0,
                right: roomMemberModel.avatar != null ? -2 : 8,
                child: Image.asset('images/owner_room@3x.png',
                    width: 16, height: 16),
              )
            : const SizedBox()
      ]),
    );
  }

  @override
  void initState() {
    getMembers();
    listenMember();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = AppWidget.getWidthScreen(context);
    return FutureBuilder<List<RoomMemberModel>>(
      future: getMembers(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return SizedBox(
            height: 32,
            width: width / 2,
            child: snapshot.data.length <= 3
                ? Row(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            final RoomMemberModel roomMemberModel =
                                snapshot.data[index];
                            return listAvatar(roomMemberModel);
                          }),
                      widget.showInvite
                          ? (widget.ownerId == user.uid
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        Routes.inviteFriends,
                                        arguments: InviteFriends(
                                            roomId: widget.roomId));
                                  },
                                  child: Image.asset(
                                      'images/fi_plus-circle@3x.png',
                                      width: 24,
                                      height: 24),
                                )
                              : const SizedBox())
                          : const SizedBox()
                    ],
                  )
                : Row(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            final RoomMemberModel roomMemberModel =
                                snapshot.data[index];
                            return listAvatar(roomMemberModel);
                          }),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Theme.of(context).color15,
                        child: Text(
                          '+ ${snapshot.data.length - 3}',
                          style: AppWidget.boldTextFieldStyle(
                              fontSize: 14, height: 21, color: ultramarineBlue),
                        ),
                      ),
                      widget.showInvite
                          ? (widget.ownerId == user.uid
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        Routes.inviteFriends,
                                        arguments: const InviteFriends());
                                  },
                                  child: Image.asset(
                                      'images/fi_plus-circle@3x.png',
                                      width: 24,
                                      height: 24),
                                )
                              : const SizedBox())
                          : const SizedBox()
                    ],
                  ),
          );
        }
        return const CupertinoActivityIndicator(animating: true);
      },
    );
  }
}
