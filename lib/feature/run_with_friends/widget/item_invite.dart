import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/constant/env.dart';
import 'package:flutter_habit_run/common/graphql/config.dart';
import 'package:flutter_habit_run/common/graphql/mutations.dart';
import 'package:flutter_habit_run/common/graphql/subscription.dart';
import 'package:flutter_habit_run/common/model/invite_friend_model.dart';
import 'package:flutter_habit_run/common/model/user_model.dart';
import 'package:flutter_habit_run/feature/home/bloc/save_info_user/bloc_save_info_user.dart';
import 'package:flutter_habit_run/feature/run_with_friends/bloc/create_group/bloc_create_group.dart';
import 'package:graphql/client.dart';

import '../bloc/get_room_member/bloc_get_room_member.dart';

class ItemInvite extends StatefulWidget {
  const ItemInvite(
      {Key key,
      this.name,
      this.guestEmail,
      this.avatar,
      this.inviteFriend,
      this.roomId})
      : super(key: key);
  final String name;
  final String guestEmail;
  final String avatar;
  final InviteFriend inviteFriend;
  final int roomId;
  @override
  _ItemInviteState createState() => _ItemInviteState();
}

class _ItemInviteState extends State<ItemInvite> {
  GetRoomMemberBloc getRoomMemberBloc;
  CreateGroupBloc createGroupBloc;

  Future<void> invite(BuildContext context, String guestEmail) async {
    final UserModel userModel =
        BlocProvider.of<SaveInfoUserBloc>(context).userModel;
    final User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.getIdToken().then((token) async {
        await Config.initializeClient(token).value.mutate(MutationOptions(
                document: gql(Mutations.insertInvite()),
                variables: <String, dynamic>{
                  'guest_email': guestEmail,
                  'room_id': widget.roomId ?? createGroupBloc.roomId,
                  'owner_name': user.displayName,
                  'user_id': user.uid,
                  'gender': userModel.gender == Gender.Male ? 'Male' : 'Female'
                }));
      });
    }
  }

  Future<void> listenInvite() async {
    final User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.getIdToken().then((token) {
        Config.initializeClient(token)
            .value
            .subscribe(SubscriptionOptions(
                document: gql(Subscription.inviteAdded),
                variables: <String, dynamic>{
                  'guest_email': widget.guestEmail,
                  'room_id': widget.roomId
                }))
            .listen((event) {
          if (event.data['Invite'].isNotEmpty) {
            if (mounted) {
              setState(() {
                widget.inviteFriend.statusInvite = true;
              });
            }
          } else {
            if (mounted) {
              setState(() {
                widget.inviteFriend.statusInvite = false;
              });
            }
          }
        });
      });
    }
  }

  @override
  void initState() {
    listenInvite();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getRoomMemberBloc = BlocProvider.of<GetRoomMemberBloc>(context);
    createGroupBloc = BlocProvider.of<CreateGroupBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              widget.avatar != null
                  ? CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(widget.avatar),
                    )
                  : CircleAvatar(
                      radius: 24,
                      backgroundColor: AdHelper().colorAvt[
                          Random().nextInt(AdHelper().colorAvt.length)],
                      child: Image.asset('images/face@3x.png')),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  widget.name,
                  style: AppWidget.simpleTextFieldStyle(
                      fontSize: 16,
                      height: 24,
                      color: Theme.of(context).color8),
                ),
              )
            ],
          ),
          AppWidget.typeButtonStartAction(
              input: widget.inviteFriend.statusInvite ? 'SENT' : 'INVITE',
              bgColor: widget.inviteFriend.statusInvite
                  ? Theme.of(context).color18
                  : ultramarineBlue,
              miniSizeHorizontal: 0,
              fontWeight: FontWeight.w700,
              borderRadius: 48,
              fontSize: 12,
              height: 18,
              vertical: 7,
              horizontal: 20,
              onPressed: widget.inviteFriend.statusInvite
                  ? () {}
                  : () {
                      final User user = FirebaseAuth.instance.currentUser;
                      if (widget.guestEmail == user.email) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            AppWidget.customSnackBar(
                                content: "Can't invite myself"));
                      } else {
                        if (getRoomMemberBloc.roomMembers
                            .where((member) =>
                                member.userId ==
                                widget.inviteFriend.userModel.id)
                            .isEmpty) {
                          setState(() {
                            widget.inviteFriend.statusInvite = true;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              AppWidget.customSnackBar(
                                  content: 'Invite successful',
                                  color: caribbeanGreen));
                          invite(context, widget.guestEmail);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              AppWidget.customSnackBar(
                                  content:
                                      'This person is already in the challenge',
                                  color: caribbeanGreen));
                        }
                      }
                    })
        ],
      ),
    );
  }
}
