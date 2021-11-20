import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/common/model/room_member_model.dart';
import 'bloc_get_room_member.dart';

class GetRoomMemberBloc
    extends Bloc<GetRoomMemberEvent, GetRoomMemberState> {
  GetRoomMemberBloc() : super(GetRoomMemberInitial());

  List<RoomMemberModel> roomMembers = [];

  @override
  Stream<GetRoomMemberState> mapEventToState(
      GetRoomMemberEvent event) async* {
    if (event is GetRankingFriendEvent) {
      final List<RoomMemberModel> members = [];
      try {
        yield GetRoomMemberLoading();
         for (var member in event.members) {
          members.add(RoomMemberModel.fromJson(member));
        }
        roomMembers = members;
        yield GetRoomMemberSuccess(members: members);
      } catch (e) {
        yield GetRoomMemberFailure(error: e.toString());
      }
    }
    if (event is DeleteRankingFriendEvent) {
      List<RoomMemberModel> members = [];
      try {
        yield GetRoomMemberLoading();
        roomMembers.removeWhere((element) => element.userId == event.idFriend);
        members = roomMembers;
        yield GetRoomMemberSuccess(members: members);
      } catch (e) {
        yield GetRoomMemberFailure(error: e.toString());
      }
    }
  }
}
