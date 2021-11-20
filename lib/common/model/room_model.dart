import 'dart:convert';
import 'package:equatable/equatable.dart';

List<RoomModel> albumFromJson(String str) => List<RoomModel>.from(
    json.decode(str).map((dynamic x) => RoomModel.fromJson(x)));

String albumToJson(List<RoomModel> data) =>
    json.encode(List<dynamic>.from(data.map<dynamic>((x) => x.toJson())));

class RoomModel extends Equatable {
  const RoomModel({this.id, this.userId, this.nameGroup});

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
        id: json['id'], userId: json['user_id'], nameGroup: json['name_room']);
  }

  final int id;
  final String userId;
  final String nameGroup;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'user_id': userId,
        'name_room': nameGroup,
      };

  @override
  List<Object> get props => [id, userId, nameGroup];
}
