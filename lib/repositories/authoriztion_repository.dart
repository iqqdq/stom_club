import 'package:stom_club/constants/ulrs.dart';
import 'package:stom_club/entities/auth_token.dart';
import 'package:stom_club/entities/requests/authorization_request.dart';
import 'package:stom_club/entities/requests/refresh_request.dart';
import 'package:stom_club/entities/requests/verification_request.dart';
import 'package:stom_club/services/web_service.dart';

class AuthorizationRepository {
  Future<Object> auth(String phone) async {
    dynamic json = await WebService()
        .post(URLs.auth_url, AuthorizationReuest(phone: phone), false);

    return json;
  }

  Future<Object> verify(int id, String code) async {
    dynamic json = await WebService().post(
        URLs.users_url + '$id/phone_confirm/',
        VerificationReuest(id: id, code: code),
        false);

    return json;
  }

  Future<AuthToken> refreshToken(String refresh) async {
    dynamic json = await WebService()
        .post(URLs.refresh_url, RefreshRequest(refresh: refresh), true);

    return AuthToken.fromJson(json);
  }
}
