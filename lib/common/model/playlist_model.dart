import 'dart:convert';
import 'package:equatable/equatable.dart';

import 'image_playlist_model.dart';

//PlaylistObjectModel
List<PlaylistModel> albumFromJson(String str) => List<PlaylistModel>.from(
    json.decode(str).map((dynamic x) => PlaylistModel.fromJson(x)));

String albumToJson(List<PlaylistModel> data) =>
    json.encode(List<dynamic>.from(data.map<dynamic>((x) => x.toJson())));

class PlaylistModel extends Equatable {
  const PlaylistModel({this.uri, this.images, this.name});

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    final List<ImageModel> images = [];
    for (var image in json['images']) {
      images.add(ImageModel.fromJson(image));
    }
    return PlaylistModel(
      images: images,
      uri: json['uri'],
      name: json['name'],
    );
  }

  final String uri;
  final String name;
  final List<ImageModel> images;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'images': images,
        'uri': uri,
        'name': name,
      };

  @override
  List<Object> get props => [uri, name, images];
}
