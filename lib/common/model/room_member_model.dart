import 'dart:convert';
import 'package:equatable/equatable.dart';

List<RoomMemberModel> albumFromJson(String str) => List<RoomMemberModel>.from(
    json.decode(str).map((dynamic x) => RoomMemberModel.fromJson(x)));

String albumToJson(List<RoomMemberModel> data) =>
    json.encode(List<dynamic>.from(data.map<dynamic>((x) => x.toJson())));

class RoomMemberModel extends Equatable {
  const RoomMemberModel(
      {this.id,
      this.userId,
      this.roomId,
      this.name,
      this.avatar,
      this.ownerGroupId});

  factory RoomMemberModel.fromJson(Map<String, dynamic> json) {
    return RoomMemberModel(
        id: json['id'],
        userId: json['user_id'],
        roomId: json['room_id'],
        name: json['name'],
        avatar: json['avatar'],
        ownerGroupId: json['owner_group_id']);
  }

  final int id;
  final String userId;
  final int roomId;
  final String name;
  final String avatar;
  final String ownerGroupId;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'user_id': userId,
        'room_id': roomId,
        'name': name,
        'avatar': avatar,
        'owner_group_id': ownerGroupId
      };

  @override
  List<Object> get props => [id, userId, roomId, name, avatar, ownerGroupId];
}
