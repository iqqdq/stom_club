import 'dart:convert';

class AuthorizationReuest {
  AuthorizationReuest({
    required this.phone,
  });

  String phone;

  factory AuthorizationReuest.fromRawJson(String str) =>
      AuthorizationReuest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthorizationReuest.fromJson(Map<String, dynamic> json) =>
      AuthorizationReuest(
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
      };
}
