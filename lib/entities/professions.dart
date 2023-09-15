import 'dart:convert';

import 'package:stom_club/entities/profession.dart';

class Professions {
  Professions({
    required this.count,
    required this.pageCount,
    this.next,
    this.previous,
    required this.results,
  });

  int count;
  int pageCount;
  String? next;
  String? previous;
  List<Profession> results;

  factory Professions.fromRawJson(String str) =>
      Professions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Professions.fromJson(Map<String, dynamic> json) => Professions(
        count: json["count"],
        pageCount: json["pageCount"],
        next: json["next"],
        previous: json["previous"],
        results: List<Profession>.from(
            json["results"].map((x) => Profession.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "pageCount": pageCount,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
