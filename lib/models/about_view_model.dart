import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:email_launcher/email_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stom_club/entities/companies.dart';
import 'package:stom_club/entities/company.dart';
import 'package:stom_club/repositories/company_repository.dart';
import 'package:stom_club/services/loading_status.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;
  Company? _company;

  Company? get company {
    return _company;
  }

  AboutViewModel() {
    getCompanyList();
  }

  // MARK: -
  // MARK: - API CALL

  Future getCompanyList() async {
    loadingStatus = LoadingStatus.searching;

    await CompanyRepository().getCompanies().then((response) => {
          if (response is Companies)
            if (response.results.isNotEmpty)
              {
                _company = response.results.first,
                loadingStatus = LoadingStatus.completed
              }
            else
              loadingStatus = LoadingStatus.error,
          notifyListeners()
        });
  }

  // MARK: -
  // MARK: - ACTIONS

  void showTelegram(BuildContext context, String url) async {
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

  void showVk(BuildContext context, String url) async {
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

  void sendMailToOwner(String address) async {
    final Email email = Email(cc: [], bcc: [address]);
    await EmailLauncher.launch(email);
  }

  void copyAddress(BuildContext context, String address) {
    Clipboard.setData(ClipboardData(text: address));
  }
}
