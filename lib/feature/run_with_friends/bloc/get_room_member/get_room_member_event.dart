import 'package:equatable/equatable.dart';

abstract class GetRoomMemberEvent extends Equatable {
  const GetRoomMemberEvent();
}

class GetRankingFriendEvent extends GetRoomMemberEvent {
  const GetRankingFriendEvent({this.members});
  final List<dynamic> members;
  @override
  List<Object> get props => [members];
}

class DeleteRankingFriendEvent extends GetRoomMemberEvent {
  const DeleteRankingFriendEvent({this.idFriend});
  final String idFriend;
  @override
  List<Object> get props => [idFriend];
}
