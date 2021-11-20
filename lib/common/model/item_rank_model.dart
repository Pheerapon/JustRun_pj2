import 'dart:convert';
import 'package:equatable/equatable.dart';

String albumToJson(List<ItemRankModel> data) =>
    json.encode(List<dynamic>.from(data.map<dynamic>((x) => x.toJson())));

class ItemRankModel extends Equatable {
  const ItemRankModel(
      {this.name, this.steps, this.distance, this.avatar, this.idFriend});

  factory ItemRankModel.fromJson(
      Map<String, dynamic> json, String name, String avatar, String idFriend) {
    return ItemRankModel(
        idFriend: idFriend,
        steps: json['steps'] ?? 0,
        name: name,
        distance: double.tryParse(json['distance'].toString()) ?? 0,
        avatar: avatar);
  }
  final String idFriend;
  final String name;
  final int steps;
  final double distance;
  final String avatar;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'user_id': idFriend,
        'name': name,
        'steps': steps,
        'distance': distance,
        'avatar': avatar
      };

  @override
  List<Object> get props => [idFriend, name, steps, distance, avatar];
}
