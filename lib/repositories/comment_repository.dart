import 'package:dio/dio.dart';
import 'package:stom_club/constants/ulrs.dart';
import 'package:stom_club/entities/comment.dart';
import 'package:stom_club/entities/comments.dart';
import 'package:stom_club/entities/requests/comment_request.dart';
import 'package:stom_club/services/pagination.dart';
import 'package:stom_club/services/web_service.dart';

class CommentRepository {
  Future<Object> getComments(Pagination pagination, int reviewId) async {
    dynamic json = await WebService().get(
        URLs.base_url +
            'reviews/$reviewId/comments/?page=${pagination.number}&size=${pagination.size}',
        true);

    try {
      Comments comments = Comments.fromJson(json);
      return comments;
    } catch (e) {
      return Comments(count: 0, pageCount: 0, results: []);
    }
  }

  Future<Object> postComment(
      int reviewId, String comment, String? filePath, String? fileName) async {
    FormData formData = await CommentRequest()
        .getFormData(reviewId, null, comment, filePath, fileName);

    dynamic json = await WebService()
        .postFormData(URLs.base_url + 'comments/', formData, true);

    return Comment.fromJson(json);
  }

  Future<Object> putComment(int reviewId, int commentId, String comment,
      String? filePath, String? fileName) async {
    dynamic json = await WebService().put(
        URLs.base_url + 'comments/$commentId/',
        await CommentRequest()
            .getFormData(reviewId, null, comment, filePath, fileName));

    return Comment.fromJson(json);
  }

  Future<void> deleteComment(int commentId) async {
    await WebService().delete(URLs.base_url + 'comments/$commentId/');
  }
}
