import 'dart:convert';

class AuthToken {
  AuthToken({
    required this.refresh,
    required this.access,
  });

  String refresh;
  String access;

  factory AuthToken.fromRawJson(String str) =>
      AuthToken.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthToken.fromJson(Map<String, dynamic> json) => AuthToken(
        refresh: json["refresh"],
        access: json["access"],
      );

  Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "access": access,
      };
}
