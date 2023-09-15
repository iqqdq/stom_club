import 'package:flutter/material.dart';
import 'package:stom_club/entities/product.dart';
import 'package:stom_club/entities/review.dart';
import 'package:stom_club/screens/review/review_screen_body.dart';

class ReviewScreenWidget extends StatelessWidget {
  final Product product;
  final double rating;
  final Function(String advantages, String defects, double rating,
      String? filePath, String? fileName) onPop;
  final Review? review;

  const ReviewScreenWidget(
      {Key? key,
      required this.product,
      required this.rating,
      required this.onPop,
      required this.review})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReviewScreenBodyWidget(
        product: product, rating: rating, onPop: onPop, review: review);
  }
}
