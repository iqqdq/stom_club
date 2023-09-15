import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

class UserRequest {
  Future<FormData> getUserFormData(
      String firstName,
      String lastName,
      int professionId,
      File? photo,
      String city,
      String vk,
      String telegram) async {
    return photo == null
        ? dio.FormData.fromMap({
            "firstName": firstName,
            "lastName": lastName,
            "profession": professionId,
            "city": city,
            "vkUrl": vk,
            "telegramUrl": telegram
          })
        : dio.FormData.fromMap({
            "firstName": firstName,
            "lastName": lastName,
            "profession": professionId,
            "city": city,
            "vkUrl": vk,
            "telegramUrl": telegram,
            "photo": await MultipartFile.fromFile(photo.path,
                filename: photo.path
                    .substring(photo.path.length - 8, photo.path.length)),
          });
  }
}
