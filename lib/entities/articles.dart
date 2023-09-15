import 'dart:convert';

import 'package:stom_club/entities/article.dart';

class Articles {
  Articles({
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
  List<Article> results;

  factory Articles.fromRawJson(String str) =>
      Articles.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Articles.fromJson(Map<String, dynamic> json) => Articles(
        count: json["count"],
        pageCount: json["pageCount"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Article>.from(json["results"].map((x) => Article.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "pageCount": pageCount,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
