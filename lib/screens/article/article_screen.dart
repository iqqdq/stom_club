import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/entities/article.dart';
import 'package:stom_club/models/article_view_model.dart';
import 'package:stom_club/screens/article/article_screen_body.dart';

class ArticleScreenWidget extends StatelessWidget {
  final Article article;

  const ArticleScreenWidget({Key? key, required this.article})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ArticleViewModel(article.id),
        child: ArticleScreenBodyWidget(article: article));
  }
}
