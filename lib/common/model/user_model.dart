import 'dart:convert';
import 'package:equatable/equatable.dart';

enum Gender { Female, Male }

List<UserModel> albumFromJson(String str) => List<UserModel>.from(
    json.decode(str).map((dynamic x) => UserModel.fromJson(x)));

String albumToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map<dynamic>((x) => x.toJson())));

class UserModel extends Equatable {
  const UserModel(
      {this.id,
      this.name,
      this.email,
      this.gender,
      this.money,
      this.userSkinId,
      this.badges,
      this.isPremium,
      this.avatar});
  factory UserModel.fromJson(Map<String, dynamic> json) {
    Gender gender;
    if (json['gender'] != null) {
      switch (json['gender'].trim()) {
        case 'Female':
          gender = Gender.Female;
          break;
        case 'Male':
          gender = Gender.Male;
          break;
      }
    } else {
      gender = null;
    }

    return UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        gender: gender,
        money: json['money'],
        userSkinId: json['userSkinId'],
        badges: json['badges'] == null ? [] : json['badges'].cast<int>(),
        isPremium: json['is_premium'],
        avatar: json['avatar']);
  }

  factory UserModel.fromSearchInvite(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        avatar: json['avatar']);
  }

  final String id;
  final String name;
  final String email;
  final Gender gender;
  final int money;
  final int userSkinId;
  final List<int> badges;
  final bool isPremium;
  final String avatar;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'email': email,
        'gender': gender,
        'money': money,
        'userSkinId': userSkinId,
        'badges': badges,
        'is_premium': isPremium,
        'avatar': avatar
      };

  @override
  List<Object> get props =>
      [id, name, email, gender, money, userSkinId, badges, isPremium, avatar];
}
