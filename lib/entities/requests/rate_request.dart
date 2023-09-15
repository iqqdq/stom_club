import 'dart:convert';

class RateRequest {
  RateRequest({required this.isLike, required this.id});

  bool isLike;
  int id;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {"isLike": isLike, "id": id};
}
