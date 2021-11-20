import 'package:equatable/equatable.dart';
import 'package:flutter_habit_run/common/model/user_model.dart';

// ignore: must_be_immutable
class InviteFriend extends Equatable {
  InviteFriend({this.userModel, this.statusInvite = false});
  final UserModel userModel;
  bool statusInvite;

  @override
  List<Object> get props => [userModel];
}
