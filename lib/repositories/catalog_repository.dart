import 'package:stom_club/constants/ulrs.dart';
import 'package:stom_club/entities/advertisings.dart';
import 'package:stom_club/entities/category.dart';
import 'package:stom_club/services/pagination.dart';
import 'package:stom_club/services/web_service.dart';

class CatalogRepository {
  Future<Object> getCategories(Pagination pagination) async {
    dynamic json = await WebService().get(
        URLs.categories_url +
            '?page=${pagination.number}&size=${pagination.size}',
        false);

    return Category.fromJson(json);
  }

  Future<Object> getCategoryById(int id) async {
    dynamic json =
        await WebService().get(URLs.categories_url + id.toString(), false);

    return Category.fromJson(json);
  }

  Future<Object> getBanners(Pagination pagination) async {
    dynamic json = await WebService().get(
        URLs.banners_url + '?page=${pagination.number}&size=${pagination.size}',
        false);

    return Advertisings.fromJson(json);
  }
}
