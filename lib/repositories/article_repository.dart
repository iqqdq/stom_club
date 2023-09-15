import 'package:stom_club/constants/ulrs.dart';
import 'package:stom_club/entities/article.dart';
import 'package:stom_club/entities/articles.dart';
import 'package:stom_club/entities/subcategory.dart';
import 'package:stom_club/services/pagination.dart';
import 'package:stom_club/services/web_service.dart';

class ArticleRepository {
  Future<Object> getArticles(Pagination pagination, String search,
      String ordering, List<Subcategory>? subcategories) async {
    // var url = URLs.articles_url + '?search=$search&ordering=$ordering';
    var url = URLs.articles_url + '?search=$search&ordering=-created_at';

    if (subcategories != null) {
      for (var subcategory in subcategories) {
        url += '&category=${subcategory.id}';
      }
    }

    url += '&page=${pagination.number}&size=${pagination.size}';

    dynamic json = await WebService().get(url, false);

    return Articles.fromJson(json);
  }

  Future<Object> getArticle(int id) async {
    dynamic json = await WebService().get(URLs.articles_url + '$id/', false);

    return Article.fromJson(json);
  }
}
