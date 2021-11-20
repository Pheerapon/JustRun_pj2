import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/graphql/config.dart';
import 'package:flutter_habit_run/common/graphql/queries.dart';
import 'package:flutter_habit_run/common/graphql/subscription.dart';
import 'package:flutter_habit_run/common/model/room_model.dart';
import 'package:flutter_habit_run/common/route/routes.dart';
import 'package:graphql/client.dart';

import '../bloc/get_room_member/bloc_get_room_member.dart';
import '../bloc/listen_list_group/bloc_listen_list_group.dart';
import '../bloc/search_name/bloc_search_name.dart';
import '../widget/member_avatar.dart';
import '../widget/menu_dialog_group.dart';
import 'run_with_friends.dart';

class ListGroup extends StatefulWidget {
  const ListGroup({Key key}) : super(key: key);
  @override
  State<ListGroup> createState() => _ListGroupState();
}

class _ListGroupState extends State<ListGroup> {
  GetRoomMemberBloc getRoomMemberBloc;
  SearchUserBloc searchNameBloc;
  ListenListGroupBloc listenListGroupBloc;
  List<RoomModel> groups = [];
  User user = FirebaseAuth.instance.currentUser;

  Future<void> getMembers(int roomId) async {
    AppWidget.showDialogCustom(context: context);
    await user.getIdToken().then((token) async {
      await Config.initializeClient(token)
          .value
          .query(QueryOptions(
              document: gql(Queries.getRoomMember),
              variables: <String, dynamic>{'room_id': roomId}))
          .then((value) {
        Navigator.of(context).pop();
        getRoomMemberBloc
            .add(GetRankingFriendEvent(members: value.data['RoomMember']));
      });
    });
  }

  Future<void> listenMember(int roomId) async {
    await user.getIdToken().then((token) async {
      Config.initializeClient(token)
          .value
          .subscribe(SubscriptionOptions(
              document: gql(Subscription.listenRoomMember),
              variables: <String, dynamic>{'room_id': roomId}))
          .listen((event) async {
        if (event.data['RoomMember'] != null) {
          getRoomMemberBloc
              .add(GetRankingFriendEvent(members: event.data['RoomMember']));
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    getRoomMemberBloc = BlocProvider.of<GetRoomMemberBloc>(context);
    searchNameBloc = BlocProvider.of<SearchUserBloc>(context);
    listenListGroupBloc = BlocProvider.of<ListenListGroupBloc>(context);
    super.didChangeDependencies();
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
          actions: [
            GestureDetector(
              onTap: () {
                searchNameBloc.add(ResetInviteEvent());
                Navigator.of(context).pushNamed(Routes.createGroup);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(
                      ' ', //create group
                      style: AppWidget.boldTextFieldStyle(
                          fontSize: 12, height: 18, color: ultramarineBlue),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Challenge',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            Expanded(
              child: BlocBuilder<ListenListGroupBloc, ListenListGroupState>(
                builder: (context, state) {
                  if (state is ListenListGroupSuccess) {
                    groups = state.groups;
                  }
                  return groups.isEmpty
                      ? Center(
                          child: Text(
                          "You don't have any groups yet",
                          style: AppWidget.simpleTextFieldStyle(
                              fontSize: 20,
                              height: 24,
                              color: Theme.of(context).color7),
                        ))
                      : ListView.separated(
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 20);
                          },
                          shrinkWrap: true,
                          itemCount: groups.length,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 24),
                          itemBuilder: (context, index) {
                            final RoomModel roomModel = groups[index];
                            return GestureDetector(
                              onTap: () async {
                                await getMembers(roomModel.id);
                                listenMember(roomModel.id);
                                Navigator.of(context).pushNamed(
                                    Routes.runWithFriends,
                                    arguments: RunWithFriends(
                                        ownerId: roomModel.userId,
                                        nameGroup: roomModel.nameGroup,
                                        roomId: roomModel.id));
                              },
                              child: Container(
                                height: 100,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Theme.of(context).color18)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(roomModel.nameGroup,
                                            style: AppWidget.boldTextFieldStyle(
                                                fontSize: 25,
                                                height: 28,
                                                color:
                                                    Theme.of(context).color7)),
                                        // MenuDialogGroup(
                                        //     roomId: roomModel.id,
                                        //     ownerId: roomModel.userId)
                                      ],
                                    ),
                                    // MemberAvatar(
                                    //     roomId: roomModel.id,
                                    //     ownerId: roomModel.userId,
                                    //     showInvite: false),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                },
              ),
            )
          ],
        ));
  }
}
