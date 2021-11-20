import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/constant/env.dart';
import 'package:flutter_habit_run/common/graphql/config.dart';
import 'package:flutter_habit_run/common/graphql/mutations.dart';
import 'package:flutter_habit_run/common/graphql/queries.dart';
import 'package:flutter_habit_run/common/model/item_rank_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:graphql/client.dart';

import '../bloc/get_room_member/bloc_get_room_member.dart';

enum TypeRank { Day, Weak, Month }

class ItemRanking extends StatefulWidget {
  const ItemRanking({Key key, this.typeRank, this.roomId, this.ownerId})
      : super(key: key);
  final TypeRank typeRank;
  final int roomId;
  final String ownerId;
  @override
  _ItemRankingState createState() => _ItemRankingState();
}

class _ItemRankingState extends State<ItemRanking> {
  User user = FirebaseAuth.instance.currentUser;
  DateTime dateNow = DateTime.now();
  GetRoomMemberBloc getRoomMemberBloc;

  Future<List<ItemRankModel>> getSumDistanceAndSteps({String date}) async {
    final List<ItemRankModel> listRank = [];
    if (user != null) {
      await user.getIdToken().then((token) async {
        for (var member in getRoomMemberBloc.roomMembers) {
          await Config.initializeClient(token)
              .value
              .query(QueryOptions(
                  document: gql(Queries.getSumDistanceAndSteps),
                  variables: <String, dynamic>{
                    'user_id': member.userId,
                    'date': date
                  }))
              .then((value) {
            listRank.add(ItemRankModel.fromJson(
                value.data['RunHistory_aggregate']['aggregate']['sum'],
                member.name,
                member.avatar,
                member.userId));
          });
        }
      });
    }
    return listRank;
  }

  Future<List<ItemRankModel>> checkType(TypeRank typeRank) async {
    List<ItemRankModel> listRank = [];
    switch (typeRank) {
      case TypeRank.Day:
        listRank = await getSumDistanceAndSteps(
            date: DateTime(dateNow.year, dateNow.month, dateNow.day)
                .toIso8601String());
        break;
      case TypeRank.Weak:
        listRank = await getSumDistanceAndSteps(
            date: DateTime(dateNow.year, dateNow.month, dateNow.day - 7)
                .toIso8601String());
        break;
      case TypeRank.Month:
        listRank = await getSumDistanceAndSteps(
            date: DateTime(dateNow.year, dateNow.month - 1, dateNow.day)
                .toIso8601String());
        break;
    }
    listRank.sort((a, b) => b.distance.compareTo(a.distance));
    return listRank;
  }

  Future<void> deleteRoomMember({String idFriend}) async {
    setState(() {
      getRoomMemberBloc.add(DeleteRankingFriendEvent(idFriend: idFriend));
    });
    await user.getIdToken().then((token) {
      Config.initializeClient(token).value.mutate(MutationOptions(
              document: gql(Mutations.deleteRoomMember()),
              variables: <String, dynamic>{
                'user_id': idFriend,
                'room_id': widget.roomId,
              }));
    });
  }

  @override
  void initState() {
    checkType(widget.typeRank);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getRoomMemberBloc = BlocProvider.of<GetRoomMemberBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ItemRankModel>>(
      future: checkType(widget.typeRank),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 32),
            separatorBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Divider(
                  thickness: 1,
                  color: Theme.of(context).color16,
                ),
              );
            },
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              // String image;
              // if (index == 0) {
              //   image = 'images/trophy_1@3x.png';
              // } else if (index == 1) {
              //   image = 'images/trophy_2@3x.png';
              // } else if (index == 2) {
              //   image = 'images/trophy_3@3x.png';
              // } else {
              //   image = 'images/fi_star@3x.png';
              // }
              return Slidable(
                actionPane: const SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                secondaryActions: (widget.ownerId != user.uid ||
                        snapshot.data[index].idFriend == user.uid)
                    ? []
                    : [
                        IconSlideAction(
                          color: redSalsa,
                          iconWidget: Text(
                            'Remove',
                            style: AppWidget.boldTextFieldStyle(
                                fontSize: 16, height: 24, color: white),
                          ),
                          onTap: () {
                            deleteRoomMember(
                                idFriend: snapshot.data[index].idFriend);
                          },
                        ),
                      ],
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Image.asset(image, width: 16, height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: snapshot.data[index].avatar != null
                                ? CircleAvatar(
                                    radius: 24,
                                    backgroundImage: NetworkImage(
                                        snapshot.data[index].avatar),
                                  )
                                : CircleAvatar(
                                    radius: 24,
                                    backgroundColor: AdHelper().colorAvt[
                                        Random().nextInt(
                                            AdHelper().colorAvt.length)],
                                    child: Image.asset('images/face@3x.png'),
                                  ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data[index].name,
                                style: AppWidget.simpleTextFieldStyle(
                                    fontSize: 16,
                                    height: 24,
                                    color: Theme.of(context).color8,
                                    fontWeight: FontWeight.w600),
                              ),
                              // Text(
                              //   '${snapshot.data[index].steps} step',
                              //   style: AppWidget.simpleTextFieldStyle(
                              //       fontSize: 14, height: 21, color: grey600),
                              // )
                            ],
                          ),
                        ],
                      ),
                      Text(
                        '${snapshot.data[index].distance.toStringAsFixed(2)} km',
                        style: AppWidget.simpleTextFieldStyle(
                            fontSize: 16,
                            height: 24,
                            color: ultramarineBlue,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const CupertinoActivityIndicator(animating: true);
      },
    );
  }
}
