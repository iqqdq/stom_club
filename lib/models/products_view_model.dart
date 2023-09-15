import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stom_club/entities/article.dart';
import 'package:stom_club/entities/manufacturer.dart';
import 'package:stom_club/entities/product.dart';
import 'package:stom_club/entities/products.dart';
import 'package:stom_club/entities/subcategory.dart';
import 'package:stom_club/repositories/product_repository.dart';
import 'package:stom_club/screens/article/article_screen.dart';
import 'package:stom_club/screens/article_filter/article_filter_screen.dart';
import 'package:stom_club/screens/manufacturer_filter/manufacturer_filter_screen.dart';
import 'package:stom_club/screens/product/product_screen.dart';
import 'package:stom_club/services/loading_status.dart';
import 'package:stom_club/services/pagination.dart';

class ProductsViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;
  final bool isNew;
  final List<Subcategory> subcategories;

  List<Subcategory> _selectedSubcategories = [];
  final List<Product> _products = [];
  List<Manufacturer> _manufacturers = [];

  List<Product> get products {
    return _products;
  }

  List<Manufacturer> get manufacturers {
    return _manufacturers;
  }

  List<Subcategory> get selectedSubcategories {
    return _selectedSubcategories;
  }

  ProductsViewModel(this.isNew, this.subcategories) {
    getProductList(true, Pagination(number: 1, size: 50), '');
  }

  /// MARK: -
  /// MARK: - API CALL

  Future getProductList(
      bool showIndicator, Pagination pagination, String? search) async {
    if (showIndicator && pagination.number == 1) {
      loadingStatus = LoadingStatus.searching;
      _products.clear();
    }

    List<Subcategory> childSubcategories = [];
    for (var subcategory in _selectedSubcategories) {
      childSubcategories.addAll(subcategory.subcategories);
    }

    await ProductRepository()
        .getProducts(
            pagination,
            isNew,
            search,
            childSubcategories.isNotEmpty
                ? childSubcategories
                : isNew
                    ? []
                    : subcategories,
            _manufacturers)
        .then((response) => {
              if (response is Products)
                {
                  if (_products.isEmpty)
                    {
                      response.results?.forEach((product) {
                        _products.add(product);
                      })
                    }
                  else
                    {
                      response.results?.forEach((newProduct) {
                        bool found = false;

                        for (var product in _products) {
                          if (product.id == newProduct.id) {
                            found = true;
                          }
                        }

                        if (!found) {
                          _products.add(newProduct);
                        }
                      })
                    }
                }
            });

    loadingStatus = LoadingStatus.completed;
    notifyListeners();
  }

  /// MARK: -
  /// MARK: - ACTIONS

  void showProductScreen(BuildContext context, Product product) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductScreenWidget(product: product)));
  }

  void showArticleScreen(BuildContext context, Article article) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ArticleScreenWidget(article: article)));
  }

  void showManufacturerFilterScreen(
      BuildContext context, Pagination pagination, String search) {
    showMaterialModalBottomSheet(
        enableDrag: false,
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ManufacturerFilterScreenWidget(
            selectedManufactures: _manufacturers,
            didReturnValue: (items) => {
                  _manufacturers = items,
                  getProductList(true, pagination, search)
                }));
  }

  void showCategoryFilterScreen(
      BuildContext context, Pagination pagination, String search) {
    showMaterialModalBottomSheet(
        enableDrag: false,
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ArticleFilterScreenWidget(
            selectedSubcategories: _selectedSubcategories,
            didReturnValue: (items) => {
                  _selectedSubcategories = items,
                  getProductList(true, pagination, search)
                }));
  }

  void removeManufacturer(
      Pagination pagination, int manufacturerId, String search) {
    _manufacturers.removeWhere((element) => element.id == manufacturerId);

    getProductList(true, pagination, search);
  }

  void removeCategory(Pagination pagination, int subcategoryId, String search) {
    _selectedSubcategories
        .removeWhere((element) => element.id == subcategoryId);

    getProductList(true, pagination, search);
  }
}
