import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

class ReviewRequest {
  Future<FormData> getFormData(int product, int? id, String advantages,
      String defects, double rating, String? filePath, String? fileName) async {
    return dio.FormData.fromMap({
      "advantages": advantages,
      "defects": defects,
      "rating": rating,
      "product": product,
      "id": id,
      "attachment": filePath == null
          ? null
          : await MultipartFile.fromFile(filePath, filename: fileName)
    });
  }
}
