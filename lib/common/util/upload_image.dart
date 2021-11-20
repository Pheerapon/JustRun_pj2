import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_habit_run/common/constant/env.dart';

Future<String> uploadFile({Uint8List uint8list}) async {
  String image;
  final dataBuffer = FormData.fromMap(<String, dynamic>{
    'upload': MultipartFile.fromBytes(uint8list,
        filename: DateTime.now().toIso8601String()),
  });

  final Dio dio = Dio(BaseOptions(
    contentType: 'application/json',
  ));
  await dio
      .post<dynamic>(EnvValue.uploadImage, data: dataBuffer)
      .then((Response response) {
    if (response.data['files'].isNotEmpty) {
      image = response.data['files'].first['transforms'].first['location'];
    }
  });
  return image;
}
