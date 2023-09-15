import 'package:flutter/material.dart';
import 'package:stom_club/entities/article.dart';
import 'package:stom_club/repositories/article_repository.dart';
import 'package:stom_club/screens/article/article_screen.dart';
import 'package:stom_club/services/loading_status.dart';

class ArticleViewModel with ChangeNotifier {
  final int articleId;
  LoadingStatus loadingStatus = LoadingStatus.empty;
  Article? _article;

  Article? get article {
    return _article;
  }

  ArticleViewModel(this.articleId) {
    getArticleById(articleId);
  }

  // MARK: -
  // MARK: - API CALL

  Future getArticleById(int id) async {
    loadingStatus = LoadingStatus.searching;

    await ArticleRepository().getArticle(id).then((response) => {
          if (response is Article)
            {_article = response, loadingStatus = LoadingStatus.completed}
          else
            loadingStatus = LoadingStatus.error,
          notifyListeners()
        });
  }

  // MARK: -
  // MARK: - ACTIONS

  void showArticleScreen(BuildContext context, Article article) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ArticleScreenWidget(article: article)));
  }

  void showWebViewScreen(BuildContext context, Article article) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ArticleScreenWidget(article: article)));
  }
}
