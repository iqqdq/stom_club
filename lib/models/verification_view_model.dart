import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/entities/auth_error.dart';
import 'package:stom_club/entities/auth_token.dart';
import 'package:stom_club/entities/authorization.dart';
import 'package:stom_club/repositories/authoriztion_repository.dart';
import 'package:stom_club/services/loading_status.dart';
import 'package:stom_club/services/user_service.dart';

class VerificationViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;
  Authorization? _authorization;
  AuthToken? _authToken;
  AuthError _authError = AuthError(phone: []);

  Authorization? get authorization {
    return _authorization;
  }

  AuthToken? get authToken {
    return _authToken;
  }

  AuthError get authError {
    return _authError;
  }

  VerificationViewModel() {
    UserService()
        .getAuth()
        .then((authorization) => _authorization = authorization);

    notifyListeners();
  }

  // MARK: -
  // MARK: - API CALL

  Future resend(BuildContext context) async {
    Authorization? authorization = await UserService().getAuth();
    String phone = authorization?.phone ?? '';
    if (phone.isNotEmpty) {
      loadingStatus = LoadingStatus.searching;

      notifyListeners();

      dynamic response = await AuthorizationRepository().auth(phone);

      try {
        _authorization = Authorization.fromJson(response);
        loadingStatus = LoadingStatus.completed;
      } catch (e) {
        try {
          _authError = AuthError.fromJson(response);
        } catch (e) {
          _authError.phone = response.cast<String>();
        }

        loadingStatus = LoadingStatus.error;

        showOkAlertDialog(
            title: Titles.error,
            message: _authError.phone.first,
            context: context);
      }

      notifyListeners();
    }
  }

  Future verify(
      BuildContext context, TextEditingController textEditingController) async {
    loadingStatus = LoadingStatus.searching;

    notifyListeners();

    if (_authorization != null) {
      await AuthorizationRepository()
          .verify(_authorization!.id, textEditingController.text)
          .then((dynamic response) => {
                if (response is List)
                  {
                    if (response.length == 1)
                      {
                        loadingStatus = LoadingStatus.error,
                        textEditingController.clear(),
                        showOkAlertDialog(
                            title: Titles.error,
                            message: response.first,
                            context: context)
                      }
                  }
                else
                  {
                    loadingStatus = LoadingStatus.completed,
                    _authToken = AuthToken.fromJson(response),
                    UserService().setTokenDate(DateTime.now()),
                    UserService().setToken(_authToken!),
                  },
                notifyListeners()
              });
    }
  }
}
