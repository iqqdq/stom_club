import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stom_club/components/device_detector.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/screens/avatar/avatar_screen.dart';
import 'package:stom_club/screens/phone/phone_screen.dart';
import 'package:stom_club/screens/privacy_policy/privacy_policy_screen.dart';
import 'package:stom_club/screens/registration/registration_screen.dart';
import 'package:stom_club/screens/social/social_screen.dart';
import 'package:stom_club/screens/verification/verification_screen.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

class AuthorizationScreenBodyWidget extends StatefulWidget {
  const AuthorizationScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _AuthorizationScreenBodyState createState() =>
      _AuthorizationScreenBodyState();
}

class _AuthorizationScreenBodyState
    extends State<AuthorizationScreenBodyWidget> {
  final _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();

    _checkTrackingAuthorization();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void _checkTrackingAuthorization() async {
    if (Platform.isIOS) {
      if (await AppTrackingTransparency.trackingAuthorizationStatus ==
          TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    }
  }

  void showPage(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastLinearToSlowEaseIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top +
                    (DeviceDetector().isLarge() ? 0.0 : 12.0)),
            padding: const EdgeInsets.only(top: 16.0),
            decoration: BoxDecoration(
                color: HexColors.background,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0))),
            child: SizedBox.expand(
                child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: [
                  PhoneScreenWidget(onUpdate: (page) => showPage(page)),
                  VerificationScreenWidget(onUpdate: (page) => showPage(page)),
                  PrivacyPolicyScreenWidget(onUpdate: (page) => showPage(page)),
                  RegistrationScreenWidget(onUpdate: (page) => showPage(page)),
                  SocialScreenWidget(onUpdate: (page) => showPage(page)),
                  AvatarScreenWidget(onUpdate: (page) => showPage(page)),
                ]))));
  }
}
