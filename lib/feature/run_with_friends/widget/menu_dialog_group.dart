import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/graphql/config.dart';
import 'package:flutter_habit_run/common/graphql/mutations.dart';
import 'package:graphql/client.dart';

import 'dialog_invite.dart';

class MenuDialogGroup extends StatefulWidget {
  const MenuDialogGroup({this.roomId, this.ownerId});
  final int roomId;
  final String ownerId;
  @override
  _MenuDialogGroupState createState() => _MenuDialogGroupState();
}

class _MenuDialogGroupState extends State<MenuDialogGroup> {
  GlobalKey menuKey = GlobalKey();
  User user = FirebaseAuth.instance.currentUser;

  Future<void> deleteGroup(int roomId) async {
    user.getIdToken().then((token) async {
      await Config.initializeClient(token).value.mutate(MutationOptions(
              document: gql(Mutations.deleteRoom()),
              variables: <String, dynamic>{
                'id': roomId,
              }));
    });
  }

  Future<void> leaveGroup(int roomId) async {
    user.getIdToken().then((token) async {
      await Config.initializeClient(token).value.mutate(MutationOptions(
              document: gql(Mutations.deleteRoomMember()),
              variables: <String, dynamic>{
                'room_id': roomId,
                'user_id': user.uid,
              }));
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool checkOwner = widget.ownerId == user.uid;
    final buttonMenu = PopupMenuButton<String>(
      color: grey200,
      key: menuKey,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      itemBuilder: (BuildContext context) {
        return List.generate(1, (index) {
          return PopupMenuItem<String>(
              child: GestureDetector(
                  onTap: () {
                    DialogInvite().showDialogInvite(
                        context: context,
                        content: checkOwner
                            ? 'Do you want to delete this group ?'
                            : 'Do you want to leave this group ?',
                        nS: 'No',
                        pS: 'Yes',
                        nF: () {
                          Navigator.of(context).pop();
                        },
                        pF: () {
                          checkOwner
                              ? deleteGroup(widget.roomId)
                              : leaveGroup(widget.roomId);
                          Navigator.of(context).pop();
                        });
                  },
                  child: Center(
                    child: Text(
                      checkOwner ? 'Delete Groups' : 'Leave Groups',
                      style: AppWidget.boldTextFieldStyle(
                          color: ultramarineBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          height: 24),
                    ),
                  )));
        });
      },
      child: Icon(Icons.more_vert, color: grey600),
    );
    return GestureDetector(
        onTap: () {
          final dynamic state = menuKey.currentState;
          state.showButtonMenu();
        },
        child: buttonMenu);
  }
}
