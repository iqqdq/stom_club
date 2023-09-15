import 'package:stom_club/constants/ulrs.dart';
import 'package:stom_club/entities/manufacturer.dart';
import 'package:stom_club/entities/manufacturers.dart';
import 'package:stom_club/entities/product_info.dart';
import 'package:stom_club/entities/products.dart';
import 'package:stom_club/entities/subcategory.dart';
import 'package:stom_club/services/pagination.dart';
import 'package:stom_club/services/web_service.dart';

class ProductRepository {
  Future<Object> getProducts(
      Pagination pagination,
      bool isNew,
      String? search,
      List<Subcategory>? subcategories,
      List<Manufacturer>? manufacturers) async {
    var url = URLs.products_url + '?search=$search';

    if (isNew) {
      url += '&ordering=-created_at&is_new=$isNew';
    }

    if (subcategories != null) {
      for (var subcategory in subcategories) {
        url += '&category=${subcategory.id}';
      }
    }

    if (manufacturers != null) {
      for (var manufacruter in manufacturers) {
        url += '&manufacturer=${manufacruter.id}';
      }
    }

    url += '&page=${pagination.number}&size=${pagination.size}';

    dynamic json = await WebService().get(url, false);

    try {
      Products products = Products.fromJson(json);
      return products;
    } catch (e) {
      return Products(count: 0, pageCount: 0);
    }
  }

  Future<Object> getManufacturers(Pagination pagination) async {
    dynamic json = await WebService().get(
        URLs.manufacturers_url +
            '?page=${pagination.number}&size=${pagination.size}',
        false);

    return Manufacturers.fromJson(json);
  }

  Future<Object> getProduct(int id) async {
    dynamic json = await WebService().get(URLs.products_url + '$id/', false);

    return ProductInfo.fromJson(json);
  }
}
