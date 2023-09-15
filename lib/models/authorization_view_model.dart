import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/entities/article.dart';
import 'package:stom_club/entities/auth_error.dart';
import 'package:stom_club/entities/authorization.dart';
import 'package:stom_club/repositories/authoriztion_repository.dart';
import 'package:stom_club/screens/article/article_screen.dart';
import 'package:stom_club/services/loading_status.dart';
import 'package:stom_club/services/user_service.dart';

class AuthorizationViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;
  Authorization? _authorization;
  AuthError _authError = AuthError(phone: []);

  Authorization? get authorization {
    return _authorization;
  }

  AuthError get authError {
    return _authError;
  }

  // MARK: -
  // MARK: - API CALL

  Future authorize(
      BuildContext context, TextEditingController textEditingController) async {
    loadingStatus = LoadingStatus.searching;

    notifyListeners();

    var formattedPhone =
        textEditingController.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (!formattedPhone.startsWith('+')) {
      formattedPhone = '+' + formattedPhone;
    }

    dynamic response = await AuthorizationRepository().auth(formattedPhone);

    try {
      _authorization = Authorization.fromJson(response);
      loadingStatus = LoadingStatus.completed;

      /// SAVE USER AUTH
      UserService().setAuth(_authorization!);
    } catch (e) {
      try {
        _authError = AuthError.fromJson(response);
      } catch (e) {
        _authError.phone = response.cast<String>();
      }

      UserService().clear();

      loadingStatus = LoadingStatus.error;
      textEditingController.text = '+7 ';

      showOkAlertDialog(
          title: Titles.error,
          message: _authError.phone.first,
          context: context);
    }

    notifyListeners();
  }

  // MARK: -
  // MARK: - ACTIONS

  void showVerifyScreen(BuildContext context, String phone) {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => ArticleScreenWidget(article: article)));
  }

  void showWebViewScreen(BuildContext context, Article article) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ArticleScreenWidget(article: article)));
  }
}
