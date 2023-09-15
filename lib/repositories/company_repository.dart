import 'package:stom_club/constants/ulrs.dart';
import 'package:stom_club/entities/companies.dart';
import 'package:stom_club/services/web_service.dart';

class CompanyRepository {
  Future<Object> getCompanies() async {
    dynamic json = await WebService().get(URLs.companies_url, false);

    return Companies.fromJson(json);
  }
}
