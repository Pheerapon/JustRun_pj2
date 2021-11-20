import 'dart:convert';
import 'package:equatable/equatable.dart';

List<RankingFriendsModel> albumFromJson(String str) =>
    List<RankingFriendsModel>.from(
        json.decode(str).map((dynamic x) => RankingFriendsModel.fromJson(x)));

String albumToJson(List<RankingFriendsModel> data) =>
    json.encode(List<dynamic>.from(data.map<dynamic>((x) => x.toJson())));

class RankingFriendsModel extends Equatable {
  const RankingFriendsModel(
      {this.id, this.userId, this.ownerTeam, this.name, this.avatar});

  factory RankingFriendsModel.fromJson(Map<String, dynamic> json) {
    return RankingFriendsModel(
        id: json['id'],
        userId: json['user_id'],
        ownerTeam: json['owner_team'],
        name: json['name'],
        avatar: json['avatar']);
  }

  final int id;
  final String userId;
  final String ownerTeam;
  final String name;
  final String avatar;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'user_id': userId,
        'owner_team': ownerTeam,
        'name': name,
        'avatar': avatar
      };

  @override
  List<Object> get props => [id, userId, ownerTeam, name, avatar];
}
