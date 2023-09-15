// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stom_club/entities/article.dart';
import 'package:stom_club/entities/articles.dart';
import 'package:stom_club/entities/subcategory.dart';
import 'package:stom_club/repositories/article_repository.dart';
import 'package:stom_club/screens/article/article_screen.dart';
import 'package:stom_club/screens/article_filter/article_filter_screen.dart';
import 'package:stom_club/services/loading_status.dart';
import 'package:stom_club/services/pagination.dart';

class ArticlesViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;
  final List<Article> _articles = [];
  List<Subcategory> _subcategories = [];

  List<Article> get articles {
    return _articles;
  }

  List<Subcategory> get subcategories {
    return _subcategories;
  }

  ArticlesViewModel() {
    getArticleList(Pagination(number: 1, size: 50), '', '', _subcategories);
  }

  // MARK: -
  // MARK: - API CALL

  Future getArticleList(
    Pagination pagination,
    String search,
    String ordering,
    List<Subcategory> subcategories,
  ) async {
    if (pagination.number == 1) {
      loadingStatus = LoadingStatus.searching;
      _articles.clear();
    }

    await ArticleRepository()
        .getArticles(pagination, search, ordering, subcategories)
        .then((response) => {
              if (response is Articles)
                {
                  if (_articles.isEmpty)
                    {
                      response.results.forEach((article) {
                        _articles.add(article);
                      })
                    }
                  else
                    {
                      if (search.isNotEmpty || _subcategories.isNotEmpty)
                        {_articles.clear()},
                      response.results.forEach((newArticle) {
                        bool found = false;

                        for (var article in _articles) {
                          if (article.id == newArticle.id) {
                            found = true;
                          }
                        }

                        if (!found) {
                          _articles.add(newArticle);
                        }
                      })
                    },
                  loadingStatus = LoadingStatus.completed
                }
              else
                {loadingStatus = LoadingStatus.error},
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

  void showFilterScreen(BuildContext context, Pagination pagination,
      String search, List<Subcategory> subcategories) {
    showMaterialModalBottomSheet(
        enableDrag: false,
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ArticleFilterScreenWidget(
            selectedSubcategories: subcategories,
            didReturnValue: (items) => {
                  _subcategories = items,
                  getArticleList(pagination, search, '', _subcategories)
                }));
  }

  void removeSubcategory(
      Pagination pagination, int subcategoryId, String search) {
    _subcategories.removeWhere((element) => element.id == subcategoryId);

    getArticleList(pagination, search, '', _subcategories);
  }
}
