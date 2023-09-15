import 'package:dio/dio.dart';
import 'package:stom_club/constants/ulrs.dart';
import 'package:stom_club/entities/user.dart';
import 'package:stom_club/services/web_service.dart';

class UserRepository {
  Future<Object> registerUser(FormData formData) async {
    dynamic json = await WebService().put(URLs.users_url, formData);

    return User.fromJson(json);
  }

  Future<Object> getUser(int id) async {
    dynamic json = await WebService().get(URLs.users_url + '$id/', true);

    return json["code"] == null ? User.fromJson(json) : Object();
  }

  Future<bool> deleteUser(int id) async {
    bool isDeleted = await WebService().delete(URLs.users_url);

    return isDeleted;
  }
}
