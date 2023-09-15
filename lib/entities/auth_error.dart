import 'dart:convert';

class AuthError {
  AuthError({required this.phone});

  List<String> phone;

  factory AuthError.fromRawJson(String str) =>
      AuthError.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthError.fromJson(Map<String, dynamic> json) => AuthError(
        phone: List<String>.from(json["phone"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "phone": List<dynamic>.from(phone.map((x) => x)),
      };
}
