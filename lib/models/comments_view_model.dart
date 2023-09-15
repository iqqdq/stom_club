// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stom_club/components/web_view_screen.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/entities/comment.dart';
import 'package:stom_club/entities/comments.dart';
import 'package:stom_club/entities/review.dart';
import 'package:stom_club/repositories/comment_repository.dart';
import 'package:stom_club/screens/profile/profile_screen.dart';
import 'package:stom_club/services/loading_status.dart';
import 'package:stom_club/services/pagination.dart';
import 'dart:io' as io;

class CommentsViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;
  final Review review;
  final List<Comment> _comments = [];

  List<Comment> get comments {
    return _comments;
  }

  CommentsViewModel(this.review) {
    getCommentList(Pagination(number: 1, size: 50));
  }

  // MARK: -
  // MARK: - API CALL

  Future getCommentList(Pagination pagination) async {
    if (pagination.number == 1) {
      loadingStatus = LoadingStatus.searching;
      _comments.clear();
    }

    await CommentRepository()
        .getComments(pagination, review.id)
        .then((response) => {
              if (response is Comments)
                {
                  if (_comments.isEmpty)
                    {
                      response.results.forEach((comment) {
                        _comments.add(comment);
                      })
                    }
                  else
                    {
                      response.results.forEach((newComment) {
                        bool found = false;

                        for (var comment in _comments) {
                          if (comment.id == newComment.id) {
                            found = true;
                          }
                        }

                        if (!found) {
                          _comments.add(newComment);
                        }
                      })
                    }
                }
            });

    loadingStatus = LoadingStatus.completed;
    notifyListeners();
  }

  Future sendComment(String comment, String? filePath, String? fileName) async {
    loadingStatus = LoadingStatus.searching;

    notifyListeners();

    await CommentRepository()
        .postComment(review.id, comment, filePath, fileName)
        .then((response) => {
              if (response is Comment) _comments.add(response),
              loadingStatus = LoadingStatus.completed,
              notifyListeners()
            });
  }

  Future changeComment(Pagination pagination, int commentId, String comment,
      String? filePath, String? fileName) async {
    loadingStatus = LoadingStatus.searching;

    notifyListeners();

    await CommentRepository()
        .putComment(review.id, commentId, comment, filePath, fileName)
        .then((response) => {
              if (response is Comment)
                {
                  _comments.removeWhere((element) => element.id == response.id),
                  _comments.add(response)
                },
              loadingStatus = LoadingStatus.completed,
              notifyListeners()
            });
  }

  Future removeComment(int commentId) async {
    loadingStatus = LoadingStatus.searching;

    notifyListeners();

    await CommentRepository().deleteComment(commentId).then((response) => {
          _comments.removeWhere((element) => element.id == commentId),
          loadingStatus = LoadingStatus.completed,
          notifyListeners()
        });
  }

  //   Future setLikeToReview(Review review, bool isLike) async {
  //   await ReviewRepository()
  //       .likeReview(review.id, isLike)
  //       .then((response) => {if (response is Rate) getReviewList()});
  // }

  // MARK: -
  // MARK: - ACTIONS

  void showProfileScreen(BuildContext context, int userId) {
    showMaterialModalBottomSheet(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ProfileScreenWidget(userId: userId));
  }

  Future openFile(BuildContext context, String url) async {
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
}
