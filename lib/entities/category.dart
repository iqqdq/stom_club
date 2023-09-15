// ignore_for_file: unnecessary_null_in_if_null_operators

import 'dart:convert';
import 'package:stom_club/entities/subcategory.dart';

class Category {
  Category({
    required this.count,
    this.pageCount,
    this.next,
    this.previous,
    this.results,
  });

  int count;
  int? pageCount;
  dynamic next;
  dynamic previous;
  List<Subcategory>? results;

  factory Category.fromRawJson(String str) =>
      Category.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        count: json["count"],
        pageCount: json["pageCount"] ?? null,
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? null
            : List<Subcategory>.from(
                json["results"].map((x) => Subcategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "pageCount": pageCount ?? null,
        "next": next,
        "previous": previous,
        "results": results == null
            ? null
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}
