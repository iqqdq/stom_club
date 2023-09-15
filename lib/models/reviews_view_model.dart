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
import 'package:stom_club/entities/product.dart';
import 'package:stom_club/entities/rate.dart';
import 'package:stom_club/entities/review.dart';
import 'package:stom_club/entities/reviews.dart';
import 'package:stom_club/repositories/review_repository.dart';
import 'package:stom_club/screens/comments/comments_screen.dart';
import 'package:stom_club/screens/profile/profile_screen.dart';
import 'package:stom_club/screens/review/review_screen.dart';
import 'package:stom_club/services/loading_status.dart';
import 'package:stom_club/services/pagination.dart';
import 'package:stom_club/services/user_service.dart';
import 'dart:io' as io;

class ReviewsViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;
  final BuildContext context;
  final Product product;
  List<Review> _reviews = [];

  List<Review> get reviews {
    return _reviews;
  }

  ReviewsViewModel(this.context, this.product) {
    getReviewList(Pagination(number: 1, size: 50));
  }

  // MARK: -
  // MARK: - API CALL

  Future getReviewList(Pagination pagination) async {
    if (pagination.number == 1) {
      loadingStatus = LoadingStatus.searching;
      _reviews.clear();
    }

    await ReviewRepository().getReviews(product.id).then((response) => {
          if (response is Reviews) _reviews = response.results,
          UserService().getAuth().then((authorization) => {
                for (var review in _reviews)
                  {
                    if (authorization != null)
                      if (review.createdBy.id == authorization.id)
                        {
                          _reviews.removeWhere(
                              (element) => element.id == review.id),
                          _reviews.insert(0, review)
                        }
                  }
              }),
        });

    loadingStatus = LoadingStatus.completed;
    notifyListeners();
  }

  Future sendReview(Pagination pagination, String advantages, String defects,
      double rating, String? filePath, String? fileName) async {
    loadingStatus = LoadingStatus.searching;

    notifyListeners();

    await ReviewRepository()
        .postReview(product.id, advantages, defects, rating, filePath, fileName)
        .then((response) => {
              if (response is Review)
                {
                  _reviews.insert(0, response),
                  loadingStatus = LoadingStatus.completed,
                  showOkAlertDialog(
                      context: context,
                      title: Titles.warning,
                      message: Titles.send_review_success),
                }
              else
                {
                  loadingStatus = LoadingStatus.empty,
                },
              notifyListeners()
            });
  }

  Future changeReview(Pagination pagination, int reviewId, String advantages,
      String defects, double rating, String? fileName, String? filePath) async {
    loadingStatus = LoadingStatus.searching;

    notifyListeners();

    await ReviewRepository()
        .putReview(product.id, reviewId, advantages, defects, rating, fileName,
            filePath)
        .then((response) => {
              if (response is Review)
                {
                  _reviews.removeWhere((element) => element.id == response.id),
                  _reviews.add(response),
                  loadingStatus = LoadingStatus.completed,
                  showOkAlertDialog(
                      context: context,
                      title: Titles.warning,
                      message: Titles.change_review_success),
                }
              else
                {
                  loadingStatus = LoadingStatus.empty,
                },
              notifyListeners()
            });
  }

  Future removeReview(int reviewId) async {
    loadingStatus = LoadingStatus.searching;

    notifyListeners();

    await ReviewRepository().deleteReview(reviewId).then((response) => {
          _reviews.removeWhere((element) => element.id == reviewId),
          showOkAlertDialog(
              context: context,
              title: Titles.warning,
              message: Titles.delete_review_success),
          loadingStatus = LoadingStatus.completed,
          notifyListeners()
        });
  }

  Future setLikeToReview(Pagination pagination, int index, bool isLike) async {
    await ReviewRepository()
        .likeReview(_reviews[index].id, isLike)
        .then((response) => {if (response is Rate) getReviewList(pagination)});
  }

  // MARK: -
  // MARK: - ACTIONS

  void showReviewScreen(Pagination pagination, Review? review) {
    showMaterialModalBottomSheet(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ReviewScreenWidget(
            product: product,
            review: review,
            rating: review?.rating.toDouble() ?? 0.0,
            onPop: (advantages, defects, rating, filePath, fileName) =>
                review == null
                    ? sendReview(pagination, advantages, defects, rating,
                        filePath, fileName)
                    : changeReview(pagination, review.id, advantages, defects,
                        rating, filePath, fileName)));
  }

  void showCommentsScreen(BuildContext context, Pagination pagination,
      bool isMineReview, Review review) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CommentsScreenWidget(
                isMineReview: isMineReview,
                review: review,
                onPop: () => getReviewList(pagination))));
  }

  void showAlert(
      BuildContext context, Pagination pagination, Review review) async {
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
                    ? showReviewScreen(pagination, review)
                    : removeReview(review.id)));
  }

  void showProfileScreen(BuildContext context, int userId) {
    showMaterialModalBottomSheet(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ProfileScreenWidget(userId: userId));
  }

  Future openFile(String url) async {
    if (url.isNotEmpty) {
      if (Platform.isAndroid) {
        Directory appDocumentsDirectory =
            await getApplicationDocumentsDirectory();
        String appDocumentsPath = appDocumentsDirectory.path;
        String fileName = url.substring(url.length - 8, url.length);
        String filePath = '$appDocumentsPath/$fileName';
        bool isFileExists = await io.File(filePath).exists();

        if (!isFileExists) {
          await Dio().download(url, filePath,
              onReceiveProgress: (count, total) {
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
  }
}
