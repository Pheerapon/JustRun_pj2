import 'dart:convert';
import 'package:equatable/equatable.dart';

List<InviteModel> albumFromJson(String str) => List<InviteModel>.from(
    json.decode(str).map((dynamic x) => InviteModel.fromJson(x)));

String albumToJson(List<InviteModel> data) =>
    json.encode(List<dynamic>.from(data.map<dynamic>((x) => x.toJson())));

class InviteModel extends Equatable {
  const InviteModel(
      {this.userId, this.guestEmail, this.roomId, this.gender, this.ownerName});

  factory InviteModel.fromJson(Map<String, dynamic> json) {
    String gender;
    switch (json['gender']) {
      case 'Female':
        gender = 'her';
        break;
      case 'Male':
        gender = 'him';
        break;
    }
    return InviteModel(
      guestEmail: json['guest_email'],
      userId: json['user_id'],
      roomId: json['room_id'],
      ownerName: json['owner_name'],
      gender: gender,
    );
  }

  final String userId;
  final int roomId;
  final String guestEmail;
  final String ownerName;
  final String gender;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'guest_email': guestEmail,
        'user_id': userId,
        'room_id': roomId,
        'owner_name': ownerName,
        'gender': gender,
      };

  @override
  List<Object> get props => [userId, roomId, guestEmail, ownerName, gender];
}
