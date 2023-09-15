import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stom_club/components/action_sheet_widget.dart';
import 'package:stom_club/components/web_view_screen.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/entities/article.dart';
import 'package:stom_club/entities/product.dart';
import 'package:stom_club/entities/product_articles.dart';
import 'package:stom_club/entities/product_info.dart';
import 'package:stom_club/entities/review.dart';
import 'package:stom_club/entities/reviews.dart';
import 'package:stom_club/repositories/product_repository.dart';
import 'package:stom_club/repositories/review_repository.dart';
import 'package:stom_club/screens/article/article_screen.dart';
import 'package:stom_club/screens/review/review_screen.dart';
import 'package:stom_club/screens/reviews/reviews_screen.dart';
import 'package:stom_club/services/loading_status.dart';
import 'package:stom_club/services/user_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' as io;

class ProductViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;
  final BuildContext context;
  final Product product;
  ProductInfo? _productInfo;
  final List<Article> _articles = [];
  Review? _review;

  ProductInfo? get productInfo {
    return _productInfo;
  }

  List<Article> get articles {
    return _articles;
  }

  Review? get review {
    return _review;
  }

  ProductViewModel(this.context, this.product) {
    getProduct();
  }

  // MARK: -
  // MARK: - API CALL

  Future getProduct() async {
    loadingStatus = LoadingStatus.searching;

    await ProductRepository().getProduct(product.id).then((response) => {
          if (response is ProductInfo) _productInfo = response,
          getReviewList()
        });
  }

  Future getReviewList() async {
    loadingStatus = LoadingStatus.searching;

    await ReviewRepository().getReviews(product.id).then((response) => {
          if (response is Reviews)
            UserService().getAuth().then((authorization) => {
                  for (var review in response.results)
                    {
                      if (authorization != null)
                        if (review.createdBy.id == authorization.id)
                          _review = review
                    }
                }),
          loadingStatus = LoadingStatus.completed
        });

    notifyListeners();
  }

  Future sendReview(String advantages, String defects, double rating,
      String? filePath, String? fileName) async {
    loadingStatus = LoadingStatus.searching;

    await ReviewRepository()
        .postReview(product.id, advantages, defects, rating, filePath, fileName)
        .then((response) => {
              showOkAlertDialog(
                      context: context,
                      title: Titles.send_review_success,
                      message: Titles.reviews_destination)
                  .then((value) => getProduct())
            });
  }

  Future changeReview(int reviewId, String advantages, String defects,
      double rating, String? filePath, String? fileName) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await ReviewRepository()
        .putReview(product.id, reviewId, advantages, defects, rating, filePath,
            fileName)
        .then((response) => {
              showOkAlertDialog(
                      context: context,
                      title: Titles.change_review_success,
                      message: Titles.reviews_destination)
                  .then((value) => getProduct())
            });
  }

  Future removeReview(int reviewId) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await ReviewRepository().deleteReview(reviewId).then((response) => {
          showOkAlertDialog(
                  context: context,
                  title: Titles.warning,
                  message: Titles.delete_review_success)
              .then((value) => {_review = null, getProduct()})
        });
  }

  Future openFile(String url) async {
    if (Platform.isAndroid) {
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      String appDocumentsPath = appDocumentsDirectory.path;
      String fileName = url.substring(url.length - 8, url.length);
      String filePath = '$appDocumentsPath/$fileName';
      bool isFileExists = await io.File(filePath).exists();

      if (!isFileExists) {
        await Dio().download(url, filePath, onReceiveProgress: (count, total) {
          debugPrint('---Download----Rec: $count, Total: $total');
        });
      }

      OpenResult openResult = await OpenFilex.open(filePath);

      if (openResult.type == ResultType.noAppToOpen) {
        showOkAlertDialog(
            context: context,
            title: Titles.warning,
            message: Titles.no_open_file_app);
      }
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewScreenWidget(url: url)));
    }
  }

  // MARK: -
  // MARK: - ACTIONS

  void showArticleScreen(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ArticleScreenWidget(article: articles[index])));
  }

  void showProductArticleScreen(
      BuildContext context, ProductArticle productArticle) {
    if (_productInfo?.articles != null) {
      if (_productInfo?.articles.articles != null) {
        if (_productInfo!.articles.articles.isNotEmpty) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArticleScreenWidget(
                      article: Article(
                          id: productArticle.id,
                          title: productArticle.title,
                          createdAt: productArticle.createdAt,
                          category: productArticle.category,
                          images: productArticle.images))));
        }
      }
    }
  }

  void showReviewScreen(BuildContext context, Review? review) {
    showMaterialModalBottomSheet(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ReviewScreenWidget(
            rating: _productInfo?.rating ?? 0.0,
            product: product,
            review: review,
            onPop: (advantages, defects, rating, filePath, fileName) =>
                review == null
                    ? sendReview(
                        advantages, defects, rating, filePath, fileName)
                    : changeReview(review.id, advantages, defects, rating,
                        filePath, fileName)));
  }

  void showReviewsScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReviewsScreenWidget(
                context: context,
                product: product,
                onPop: () => getReviewList())));
  }

  void showAlert(BuildContext context, Review review) async {
    showMaterialModalBottomSheet(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ActionSheetWidget(
                actions: [
                  Titles.change,
                  Titles.delete,
                ],
                onIndexTap: (index) => index == 0
                    ? showReviewScreen(context, review)
                    : removeReview(review.id)));
  }

  void openVideoUrl(String url) {
    launchUrl(Uri.parse(url));
  }
}
