import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/entities/product.dart';
import 'package:stom_club/models/reviews_view_model.dart';
import 'package:stom_club/screens/reviews/reviews_screen_body.dart';

class ReviewsScreenWidget extends StatelessWidget {
  final BuildContext context;
  final Product product;
  final VoidCallback onPop;

  const ReviewsScreenWidget(
      {Key? key,
      required this.context,
      required this.product,
      required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ReviewsViewModel(context, product),
        child: ReviewsScreenBodyWidget(product: product, onPop: onPop));
  }
}
