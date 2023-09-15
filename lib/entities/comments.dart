import 'dart:convert';
import 'package:stom_club/entities/comment.dart';

class Comments {
  Comments({
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
  List<Comment> results;

  factory Comments.fromRawJson(String str) =>
      Comments.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Comments.fromJson(Map<String, dynamic> json) => Comments(
        count: json["count"],
        pageCount: json["pageCount"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Comment>.from(json["results"].map((x) => Comment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "pageCount": pageCount,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
