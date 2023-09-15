import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:notification_center/notification_center.dart';
import 'package:stom_club/components/action_sheet_widget.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/entities/authorization.dart';
import 'package:stom_club/entities/requests/user_request.dart';
import 'package:stom_club/entities/user.dart';
import 'package:stom_club/repositories/user_repository.dart';
import 'package:stom_club/services/loading_status.dart';
import 'package:stom_club/services/user_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileViewModel with ChangeNotifier {
  final int userId;
  LoadingStatus loadingStatus = LoadingStatus.searching;
  User? _user;

  User? get user {
    return _user;
  }

  ProfileViewModel(this.userId) {
    getUserById(userId);
  }

  // MARK: -
  // MARK: - API CALL

  Future getUserById(int id) async {
    Authorization? authorization = await UserService().getAuth();

    await UserRepository().getUser(id).then((response) => {
          if (response is User)
            {
              _user = response,
              loadingStatus = LoadingStatus.completed,

              /// SAVE USER
              if (authorization != null)
                if (authorization.id == _user!.id) UserService().setUser(_user!)
            },
          notifyListeners()
        });
  }

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

      /// SAVE USER
      UserService().setUser(_user!);
    } else {
      loadingStatus = LoadingStatus.error;
    }

    notifyListeners();
  }

  Future deleteAccount(BuildContext context) async {
    loadingStatus = LoadingStatus.searching;

    notifyListeners();

    await UserRepository().deleteUser(userId).then((response) => {
          if (response)
            {
              loadingStatus = LoadingStatus.completed,
              UserService().clear(),
              _user = null,
            },

          /// SHOW DART NOTIFICATION CENTER ALERT
          NotificationCenter()
              .notify('show_account_delete_alert', data: response)
        });
  }

  // MARK: -
  // MARK: - ACTIONS

  void showVk(BuildContext context, String url) async {
    if (url.isNotEmpty) {
      if (Platform.isAndroid) {
        AndroidIntent intent =
            AndroidIntent(action: 'android.intent.action.VIEW', data: url);
        intent.launch();
      } else if (Platform.isIOS) {
        var telegramAppUrl = 'tg://resolve?user=' + url.substring(13);

        if (await canLaunchUrl(Uri.parse(telegramAppUrl))) {
          launchUrl(Uri.parse(telegramAppUrl));
        } else {
          launchUrl(Uri.parse(url));
        }
      }
    }
  }

  void showTelegram(BuildContext context, String url) async {
    if (url.isNotEmpty) {
      if (Platform.isAndroid) {
        AndroidIntent intent =
            AndroidIntent(action: 'android.intent.action.VIEW', data: url);
        intent.launch();
      } else if (Platform.isIOS) {
        var vkAppUrl = 'vk://vk.com/' + url.substring(15);

        if (await canLaunchUrl(Uri.parse(vkAppUrl))) {
          launchUrl(Uri.parse(vkAppUrl));
        } else {
          launchUrl(Uri.parse(url));
        }
      }
    }
  }

  void copyAddress(BuildContext context, String address) {
    Clipboard.setData(ClipboardData(text: address)).then((_) {});
  }

  void logout(BuildContext context) {
    showMaterialModalBottomSheet(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ActionSheetWidget(
            actions: [Titles.logout],
            onIndexTap: (index) => {
                  if (index == 0)
                    {UserService().clear(), Navigator.pop(context)}
                }));
  }

  void deleteMyAccount(BuildContext context) {
    showMaterialModalBottomSheet(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ActionSheetWidget(
            actions: [Titles.delete_account],
            onIndexTap: (index) => {
                  if (index == 0)
                    {Navigator.pop(context), deleteAccount(context)}
                }));
  }
}
