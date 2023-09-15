import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/entities/review.dart';
import 'package:stom_club/models/comments_view_model.dart';
import 'package:stom_club/screens/comments/comments_screen_body.dart';

class CommentsScreenWidget extends StatelessWidget {
  final bool isMineReview;
  final Review review;
  final VoidCallback onPop;

  const CommentsScreenWidget(
      {Key? key,
      required this.isMineReview,
      required this.review,
      required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CommentsViewModel(review),
        child: CommentsScreenBodyWidget(
            isMineReview: isMineReview, review: review, onPop: onPop));
  }
}
