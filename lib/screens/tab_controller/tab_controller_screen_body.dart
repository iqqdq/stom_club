import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/sizes.dart';
import 'package:stom_club/screens/about/about_screen.dart';
import 'package:stom_club/screens/articles/articles_screen.dart';
import 'package:stom_club/screens/authorization/authorization_screen.dart';
import 'package:stom_club/screens/catalog/catalog_screen.dart';
import 'package:stom_club/screens/tab_controller/components/tab_button.dart';
import 'package:stom_club/services/user_service.dart';

class TabControllerScreenBodyWidget extends StatefulWidget {
  const TabControllerScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _TabControllerScreenBodyState createState() =>
      _TabControllerScreenBodyState();
}

class _TabControllerScreenBodyState
    extends State<TabControllerScreenBodyWidget> {
  final _pageController = PageController(initialPage: 0);
  int _index = 0;

  @override
  void initState() {
    super.initState();

    showAuthorizationScreen();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void showAuthorizationScreen() async {
    ///  CHECK IS FIRST APP START
    UserService userService = UserService();
    userService.getAppStatus().then((appStatus) => {
          if (!appStatus)
            {
              /// SET FIRST APP START STATUS
              userService.setAppStatus(true),

              /// SHOW AUTH SCREEN
              Future.delayed(
                  const Duration(seconds: 1),
                  () => showMaterialModalBottomSheet(
                      enableDrag: false,
                      barrierColor: Colors.black.withOpacity(0.5),
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const AuthorizationScreenWidget()))
            }
        });
  }

  void showPage(int page) {
    setState(() {
      _index = page;
      _pageController.animateToPage(page,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColors.background,
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: Platform.isAndroid ? 8.0 : 0.0,
          backgroundColor: HexColors.background,
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _index = index);
                },
                children: const [
                  CatalogScreenWidget(),
                  ArticlesScreenWidget(),
                  AboutScreenWidget()
                ]),

            /// TAB BAR
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: Sizes.tabControllerHeight,
                  decoration: BoxDecoration(
                      color: HexColors.row,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0))),
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 8),
                          child: Row(
                            children: [
                              TabButtonWidget(
                                  index: 0,
                                  imagePath: 'assets/ic_catalog.png',
                                  isSelected: _index == 0,
                                  didReturnIndex: (index) => showPage(0)),
                              TabButtonWidget(
                                  index: 1,
                                  imagePath: 'assets/ic_articles.png',
                                  isSelected: _index == 1,
                                  didReturnIndex: (index) => showPage(1)),
                              TabButtonWidget(
                                  index: 2,
                                  imagePath: 'assets/ic_about.png',
                                  isSelected: _index == 2,
                                  didReturnIndex: (index) => showPage(2)),
                            ],
                          ))
                    ],
                  ),
                )),
          ],
        ));
  }
}
