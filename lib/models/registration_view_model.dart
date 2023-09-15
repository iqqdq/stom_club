import 'dart:io';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stom_club/entities/profession.dart';
import 'package:stom_club/entities/requests/user_request.dart';
import 'package:stom_club/entities/user.dart';
import 'package:stom_club/repositories/user_repository.dart';
import 'package:stom_club/screens/professions/professions_screen.dart';
import 'package:stom_club/services/loading_status.dart';
import 'package:stom_club/services/user_service.dart';

class RegistrationViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;
  User? _user;
  Profession? _profession;

  User? get user {
    return _user;
  }

  Profession? get profession {
    return _profession;
  }

  // MARK: -
  // MARK: - API CALL

  Future registerUser(String firstName, String lastName, int professionId,
      File? photo, String city, String vk, String telegram) async {
    loadingStatus = LoadingStatus.searching;

    notifyListeners();

    dynamic response = await UserRepository().registerUser(await UserRequest()
        .getUserFormData(
            firstName, lastName, professionId, photo, city, vk, telegram));

    if (response is User) {
      loadingStatus = LoadingStatus.completed;
      _user = response;

      UserService userService = UserService();

      /// SAVE USER
      userService.setUser(_user!);

      /// SAVE USER PROFESSION ID
      if (_profession != null) {
        userService.setProfessionId(_profession!.id);
      }

      /// SAVE USER PARAM 'isCreated'
      var authorization = await userService.getAuth();
      authorization!.isCreated = false;
      userService.setAuth(authorization);
    } else {
      loadingStatus = LoadingStatus.error;
    }

    notifyListeners();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void showSelectionScreen(BuildContext context) {
    showMaterialModalBottomSheet(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ProfessionsScreenWidget(
            didReturnValue: (profession) =>
                {_profession = profession, notifyListeners()}));
  }
}
