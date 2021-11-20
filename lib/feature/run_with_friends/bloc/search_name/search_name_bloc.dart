import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/graphql/config.dart';
import 'package:flutter_habit_run/common/graphql/queries.dart';
import 'package:flutter_habit_run/common/model/invite_friend_model.dart';
import 'package:flutter_habit_run/common/model/user_model.dart';
import 'package:graphql/client.dart';

import 'bloc_search_name.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  SearchUserBloc() : super(SearchUserInitial());

  final List<InviteFriend> memberRoom = [];
  final List<InviteFriend> listInvite = [];

  @override
  Stream<SearchUserState> mapEventToState(SearchUserEvent event) async* {
    if (event is SearchEmailEvent) {
      final List<String> emails =
          memberRoom.map((member) => member.userModel.email).toList();

      try {
        yield SearchUserLoading();
        if (!emails.contains(event.input)) {
          await getUsers(event.context, memberRoom, listInvite, event.input);
        }
        yield SearchUserSuccess(results: memberRoom, listInvite: listInvite);
      } catch (e) {
        yield SearchUserFailure(error: e.toString());
      }
    }
    if (event is ResetInviteEvent) {
      try {
        yield SearchUserLoading();
        listInvite.clear();
        memberRoom.clear();
        yield SearchUserSuccess(results: memberRoom, listInvite: listInvite);
      } catch (e) {
        yield SearchUserFailure(error: e.toString());
      }
    }
  }

  Future<void> getUsers(BuildContext context, List<InviteFriend> memberRoom,
      List<InviteFriend> listInvite, String input) async {
    UserModel userModel;
    final User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      AppWidget.showDialogCustom(context: context);
      await user.getIdToken().then((token) async {
        await Config.initializeClient(token)
            .value
            .query(QueryOptions(
                document: gql(Queries.getUserByEmail),
                variables: <String, dynamic>{'email': input}))
            .then((value) {
          if (value.data['User'].isNotEmpty) {
            userModel = UserModel.fromSearchInvite(value.data['User'][0]);
            memberRoom.add(InviteFriend(userModel: userModel));
            listInvite.add(InviteFriend(userModel: userModel));
          }
        });
      });
      Navigator.of(context).pop();
    }
  }
}
