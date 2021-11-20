import 'package:equatable/equatable.dart';
import 'package:flutter_habit_run/common/model/room_member_model.dart';

abstract class GetRoomMemberState extends Equatable {
  const GetRoomMemberState();
}

class GetRoomMemberInitial extends GetRoomMemberState {
  @override
  List<Object> get props => [];
}

class GetRoomMemberLoading extends GetRoomMemberState {
  @override
  List<Object> get props => [];
}

class GetRoomMemberSuccess extends GetRoomMemberState {
  const GetRoomMemberSuccess({this.members});
  final List<RoomMemberModel> members;
  @override
  List<Object> get props => [members];
}

class GetRoomMemberFailure extends GetRoomMemberState {
  const GetRoomMemberFailure({this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
