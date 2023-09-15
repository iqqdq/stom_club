import 'dart:convert';
import 'package:stom_club/entities/advertising.dart';

class Advertisings {
  Advertisings({
    required this.count,
    required this.pageCount,
    this.next,
    this.previous,
    this.results,
  });

  int count;
  int pageCount;
  String? next;
  String? previous;
  List<Advertising>? results;

  factory Advertisings.fromRawJson(String str) =>
      Advertisings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Advertisings.fromJson(Map<String, dynamic> json) => Advertisings(
        count: json["count"],
        pageCount: json["pageCount"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? null
            : List<Advertising>.from(
                json["results"].map((x) => Advertising.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "pageCount": pageCount,
        "next": next,
        "previous": previous,
        "results": results == null
            ? null
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}
