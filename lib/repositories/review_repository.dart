import 'package:dio/dio.dart';
import 'package:stom_club/constants/ulrs.dart';
import 'package:stom_club/entities/rate.dart';
import 'package:stom_club/entities/requests/rate_request.dart';
import 'package:stom_club/entities/requests/review_request.dart';
import 'package:stom_club/entities/review.dart';
import 'package:stom_club/entities/reviews.dart';
import 'package:stom_club/services/web_service.dart';

class ReviewRepository {
  Future<Object> getReviews(int productId) async {
    dynamic json = await WebService()
        .get(URLs.products_url + productId.toString() + '/reviews/', true);

    try {
      Reviews reviews = Reviews.fromJson(json);
      return reviews;
    } catch (e) {
      return Reviews(count: 0, pageCount: 0, results: []);
    }
  }

  Future<Object> postReview(int productId, String advantages, String defects,
      double rating, String? filePath, String? fileName) async {
    FormData formData = await ReviewRequest().getFormData(
        productId, null, advantages, defects, rating, filePath, fileName);

    dynamic json = await WebService()
        .postFormData(URLs.base_url + 'reviews/', formData, true);

    return Review.fromJson(json);
  }

  Future<Object> putReview(int productId, int reviewId, String advantages,
      String defects, double rating, String? filePath, String? fileName) async {
    FormData formData = await ReviewRequest().getFormData(
        productId, reviewId, advantages, defects, rating, filePath, fileName);

    dynamic json =
        await WebService().put(URLs.base_url + 'reviews/$reviewId/', formData);

    return Review.fromJson(json);
  }

  Future<void> deleteReview(int productId) async {
    await WebService().delete(URLs.base_url + 'reviews/$productId/');
  }

  Future<Object> likeReview(int reviewId, bool isLike) async {
    dynamic json = await WebService().post(
        URLs.base_url +
            'reviews/' +
            reviewId.toString() +
            '/rate/?isLike=$isLike',
        RateRequest(isLike: isLike, id: reviewId),
        true);

    return Rate.fromJson(json);
  }
}
