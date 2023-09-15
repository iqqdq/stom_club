import 'package:stom_club/constants/ulrs.dart';
import 'package:stom_club/entities/professions.dart';
import 'package:stom_club/services/pagination.dart';
import 'package:stom_club/services/web_service.dart';

class ProfessionRepository {
  Future<Object> getProfessions(Pagination pagination) async {
    var url = URLs.professions_url +
        '?page=${pagination.number}&size=${pagination.size}';

    dynamic json = await WebService().get(url, false);

    return Professions.fromJson(json);
  }
}
