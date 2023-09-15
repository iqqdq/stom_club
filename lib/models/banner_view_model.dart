import 'package:flutter/material.dart';
import 'package:stom_club/entities/product.dart';
import 'package:stom_club/entities/product_info.dart';
import 'package:stom_club/repositories/product_repository.dart';
import 'package:stom_club/screens/product/product_screen.dart';
import 'package:stom_club/services/loading_status.dart';

class BannerViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;
  int? productId;
  Product? _product;

  Product? get product {
    return _product;
  }

  BannerViewModel(this.productId) {
    if (productId != null) {
      getProductById(productId!);
    }
  }

  // MARK: -
  // MARK: - API CALL

  Future getProductById(int id) async {
    loadingStatus = LoadingStatus.searching;

    await ProductRepository().getProduct(id).then((response) => {
          if (response is ProductInfo)
            {
              _product = Product(
                  id: response.id,
                  isNew: response.isNew,
                  name: response.name,
                  reviewsCount: response.reviewsCount,
                  rating: response.rating.toDouble(),
                  images: []),
              loadingStatus = LoadingStatus.completed
            }
          else
            loadingStatus = LoadingStatus.error,
          notifyListeners()
        });
  }

  // MARK: -
  // MARK: - ACTIONS

  void showArticleScreen(BuildContext context) {
    if (_product != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductScreenWidget(product: _product!)));
    }
  }
}
