import 'dart:convert';
import 'package:stom_club/entities/review.dart';

class Reviews {
  Reviews({
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
  List<Review> results;

  factory Reviews.fromRawJson(String str) => Reviews.fromJson(json.decode(str));

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
        count: json["count"],
        pageCount: json["pageCount"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Review>.from(json["results"].map((x) => Review.fromJson(x))),
      );
}
