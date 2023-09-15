import 'dart:convert';
import 'package:stom_club/entities/company.dart';

class Companies {
  Companies({
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
  List<Company> results;

  factory Companies.fromRawJson(String str) =>
      Companies.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Companies.fromJson(Map<String, dynamic> json) => Companies(
        count: json["count"],
        pageCount: json["pageCount"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Company>.from(json["results"].map((x) => Company.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "pageCount": pageCount,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
