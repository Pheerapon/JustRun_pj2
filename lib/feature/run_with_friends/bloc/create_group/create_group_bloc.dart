import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/graphql/config.dart';
import 'package:flutter_habit_run/common/graphql/mutations.dart';
import 'package:flutter_habit_run/common/route/routes.dart';
import 'package:flutter_habit_run/feature/run_with_friends/screen/invite_friends.dart';
import 'package:graphql/client.dart';

import 'create_group_event.dart';
import 'create_group_state.dart';

class CreateGroupBloc extends Bloc<CreateGroupEvent, CreateGroupState> {
  CreateGroupBloc() : super(CreateGroupInitial());

  int roomId;

  Future<void> createGroup({BuildContext context, String nameGroup}) async {
    AppWidget.showDialogCustom(context: context);
    final User user = FirebaseAuth.instance.currentUser;
    user.getIdToken().then((token) async {
      await Config.initializeClient(token)
          .value
          .mutate(MutationOptions(
              document: gql(Mutations.createRoom()),
              variables: <String, dynamic>{
                'user_id': user.uid,
                'name_room': nameGroup
              }))
          .then((value) {
        Navigator.of(context).pop();
        if (value.data != null) {
          Config.initializeClient(token).value.mutate(MutationOptions(
                  document: gql(Mutations.insertMember()),
                  variables: <String, dynamic>{
                    'user_id': user.uid,
                    'owner_group_id': user.uid,
                    'room_id': value.data['insert_Room']['returning'][0]['id'],
                    'name': user.displayName,
                    'avatar': user.photoURL
                  }));
          dialogSuccessed(context);
          roomId = value.data['insert_Room']['returning'][0]['id'];
          Navigator.of(context).pushNamed(Routes.inviteFriends,
              arguments: InviteFriends(
                  roomId: value.data['insert_Room']['returning'][0]['id']));
        } else {
          dialogFaild(context);
        }
      });
    });
  }

  @override
  Stream<CreateGroupState> mapEventToState(CreateGroupEvent event) async* {
    if (event is CreatePressed) {
      try {
        yield CreateGroupLoading();
        if (_nameGroupError(event.nameGroup) == null) {
          createGroup(nameGroup: event.nameGroup, context: event.context);
          yield CreateGroupSuccess();
        }
        if (_nameGroupError(event.nameGroup) != null) {
          yield CreateGroupFailure(
              errorNameGroup: _nameGroupError(event.nameGroup));
        }
      } catch (error) {
        yield CreateGroupFailure(errorNameGroup: error.toString());
      }
    }
  }

  Future<void> dialogSuccessed(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      AppWidget.customSnackBar(
        color: caribbeanGreen,
        content: 'Create Challenge success',
      ),
    );
  }

  Future<void> dialogFaild(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      AppWidget.customSnackBar(
        color: caribbeanGreen,
        content: 'Challenge name already exists',
      ),
    );
  }

  String _nameGroupError(String nameGroupString) {
    if (nameGroupString.isEmpty) {
      return "Challenge name can't empty";
    } else {
      return null;
    }
  }
}
