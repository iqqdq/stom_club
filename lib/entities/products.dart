import 'dart:convert';

import 'package:stom_club/entities/product.dart';

class Products {
  Products({
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
  List<Product>? results;

  factory Products.fromRawJson(String str) =>
      Products.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        count: json["count"],
        pageCount: json["pageCount"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? null
            : List<Product>.from(
                json["results"].map((x) => Product.fromJson(x))),
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
