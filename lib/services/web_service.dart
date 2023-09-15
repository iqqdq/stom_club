// ignore: import_of_legacy_library_into_null_safe
// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:stom_club/entities/auth_token.dart';
import 'dart:convert';
import 'package:stom_club/services/user_service.dart';

class WebService {
  final _dio = Dio();

  Future<Options> _options() async {
    AuthToken? authToken = await UserService().getToken();

    return Options(
      headers: authToken != null
          ? {
              'accept': 'application/json',
              'Authorization': 'JWT ${authToken.access}'
            }
          : {
              'accept': 'application/json',
            },
      followRedirects: false,
    );
  }

  Future<dynamic> get(String url, bool options) async {
    try {
      Response response = await _dio.get(url,
          options: options == false ? null : await _options());

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      if (e is DioError) {
        return e.response?.data;
      }
    }
  }

  Future<dynamic> post(String url, Object object, bool options) async {
    try {
      Response response = await _dio.post(url,
          data: jsonEncode(object),
          options: options == false ? null : await _options());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
    } catch (e) {
      if (e is DioError) {
        return e.response?.data;
      }
    }
  }

  Future<dynamic> postFormData(String url, Object object, bool options) async {
    try {
      Response response = await _dio.post(url,
          data: object, options: options == false ? null : await _options());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
    } catch (e) {
      if (e is DioError) {
        return e.response?.data;
      }
    }
  }

  Future<dynamic> put(String url, FormData formData) async {
    try {
      Response response =
          await _dio.put(url, data: formData, options: await _options());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
    } catch (e) {
      if (e is DioError) {
        return e.response?.data;
      }
    }
  }

  Future<bool> delete(String url) async {
    try {
      Response response = await _dio.delete(url, options: await _options());

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      }
    } catch (e) {
      if (e is DioError) {
        print(e.response?.data);
      }
    }

    return false;
  }

  Future<dynamic> upload(FormData formData, String url) async {
    try {
      Response response =
          await _dio.post(url, data: formData, options: await _options());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
    } catch (e) {
      if (e is DioError) {
        return e.response?.data;
      }
    }
  }
}
