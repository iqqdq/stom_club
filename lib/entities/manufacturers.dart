import 'dart:convert';
import 'package:stom_club/entities/manufacturer.dart';
import 'package:stom_club/entities/product.dart';

class Manufacturers {
  Manufacturers({
    required this.count,
    required this.pageCount,
    this.next,
    this.previous,
    this.results,
  });

  int count;
  int pageCount;
  dynamic next;
  dynamic previous;
  List<Manufacturer>? results;

  factory Manufacturers.fromRawJson(String str) =>
      Manufacturers.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Manufacturers.fromJson(Map<String, dynamic> json) => Manufacturers(
        count: json["count"],
        pageCount: json["pageCount"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? null
            : List<Manufacturer>.from(
                json["results"].map((x) => Manufacturer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "pageCount": pageCount,
        "next": next,
        "previous": previous,
        "results": results == null
            ? null
            : List<Product>.from(results!.map((x) => x.toJson())),
      };
}
