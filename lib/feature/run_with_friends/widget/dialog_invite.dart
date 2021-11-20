import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/graphql/config.dart';
import 'package:flutter_habit_run/common/graphql/mutations.dart';
import 'package:graphql/client.dart';

class DialogInvite {
  Future<void> deleteInvite({int roomId}) async {
    final User user = FirebaseAuth.instance.currentUser;
    await user.getIdToken().then((token) {
      Config.initializeClient(token).value.mutate(MutationOptions(
              document: gql(Mutations.deleteInvite()),
              variables: <String, dynamic>{
                'guest_email': user.email,
                'room_id': roomId
              }));
    });
  }

  Future<void> insertMember({int roomId, String ownerGroupId}) async {
    final User user = FirebaseAuth.instance.currentUser;
    await user.getIdToken().then((token) {
      Config.initializeClient(token).value.mutate(MutationOptions(
              document: gql(Mutations.insertMember()),
              variables: <String, dynamic>{
                'owner_group_id': ownerGroupId,
                'name': user.displayName,
                'user_id': user.uid,
                'room_id': roomId,
                'avatar': user.photoURL
              }));
    });
  }

  void showDialogInvite(
      {BuildContext context,
      String content,
      String pS,
      String nS,
      Function pF,
      Function nF}) {
    showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
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
                    content,
                    textAlign: TextAlign.center,
                    style: AppWidget.simpleTextFieldStyle(
                        fontSize: 16, height: 24, color: black),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: nF,
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(48),
                            ),
                            side: BorderSide(color: ultramarineBlue)),
                        child: Text(nS,
                            textAlign: TextAlign.center,
                            style: AppWidget.simpleTextFieldStyle(
                                fontSize: 12,
                                color: ultramarineBlue,
                                fontWeight: FontWeight.w700,
                                height: 18)),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: AppWidget.typeButtonStartAction(
                          input: pS,
                          bgColor: ultramarineBlue,
                          miniSizeHorizontal: 0,
                          fontWeight: FontWeight.w700,
                          borderRadius: 48,
                          fontSize: 12,
                          height: 18,
                          vertical: 9,
                          onPressed: pF),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
