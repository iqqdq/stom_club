import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

class CommentRequest {
  Future<FormData> getFormData(int review, int? id, String comment,
      String? filePath, String? fileName) async {
    return dio.FormData.fromMap({
      "review": review,
      "id": id,
      "comment": comment,
      "attachment": filePath == null
          ? null
          : await MultipartFile.fromFile(filePath, filename: fileName)
    });
  }
}
