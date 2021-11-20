import 'dart:convert';
import 'package:equatable/equatable.dart';

//ImageObjectModel
List<ImageModel> albumFromJson(String str) => List<ImageModel>.from(
    json.decode(str).map((dynamic x) => ImageModel.fromJson(x)));

String albumToJson(List<ImageModel> data) =>
    json.encode(List<dynamic>.from(data.map<dynamic>((x) => x.toJson())));

class ImageModel extends Equatable {
  const ImageModel({this.url});
  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      url: json['url'],
    );
  }

  final String url;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'url': url,
      };

  @override
  List<Object> get props => [url];
}
