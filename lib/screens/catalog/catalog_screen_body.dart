import 'dart:async';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:notification_center/notification_center.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stom_club/components/device_detector.dart';
import 'package:stom_club/components/list_item.dart';
import 'package:stom_club/components/load_indicator_widget.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/sizes.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/models/catalog_view_model.dart';
import 'package:stom_club/screens/catalog/components/catalog_app_bar.dart';
import 'package:stom_club/components/slideshow_list_item.dart';
import 'package:stom_club/services/loading_status.dart';

class CatalogScreenBodyWidget extends StatefulWidget {
  const CatalogScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _CatalogScreenBodyState createState() => _CatalogScreenBodyState();
}

class _CatalogScreenBodyState extends State<CatalogScreenBodyWidget>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _pageController = PageController();
  late Timer _timer;
  int _seconds = 5;

  @override
  void initState() {
    NotificationCenter().subscribe(
      'show_account_delete_alert',
      (bool isDeleted) {
        showOkAlertDialog(
            context: context,
            title: isDeleted ? Titles.warning : Titles.error,
            message: isDeleted
                ? Titles.delete_account_success
                : Titles.delete_account_error);
      },
    );

    _startTimer(0);

    super.initState();
  }

  @override
  void dispose() {
    NotificationCenter().unsubscribe('show_account_delete_alert');
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void _startTimer(int length) {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_seconds == 0) {
          if (_pageController.page == length - 1) {
            _pageController.animateToPage(0,
                duration: const Duration(milliseconds: 150),
                curve: Curves.linear);
          } else {
            _pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.linear);
          }

          _seconds = 5;
        } else {
          setState(() {
            _seconds--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final contentViewHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top +
            (DeviceDetector.isLarge(context) ? 0.0 : 12.0)) -
        Sizes.appBarHeight -
        Sizes.tabControllerHeight(context);
    final slideshowHeight = DeviceDetector.isLarge(context) ? 200.0 : 160.0;

    final catalogViewModel =
        Provider.of<CatalogViewModel>(context, listen: true);

    if (catalogViewModel.banners.isNotEmpty) {
      if (_timer.isActive) {
        _timer.cancel();
      }

      _startTimer(catalogViewModel.banners.length);
    }

    if (catalogViewModel.subcategories.isNotEmpty) {
      for (var subcategory in catalogViewModel.subcategories) {
        if (subcategory.name == Titles.newest) {
          catalogViewModel.subcategories
              .removeWhere((element) => element.id == subcategory.id);
          catalogViewModel.subcategories
              .insert(catalogViewModel.subcategories.length, subcategory);
        }
      }
    }

    final listHeight = contentViewHeight -
        slideshowHeight -
        Sizes.indicatorHeight(context) -
        12.0;

    return Scaffold(
        backgroundColor: HexColors.background,
        body: SizedBox.expand(
            child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top +
                        (DeviceDetector.isLarge(context) ? 0.0 : 12.0)),
                child: Stack(children: [
                  Column(children: [
                    /// APP BAR
                    CatalogAppBarWidget(
                        onSearchTap: () => {
                              _timer.cancel(),
                              catalogViewModel.showSearchScreen(context)
                            },
                        onProfileTap: () => {
                              _timer.cancel(),
                              catalogViewModel.showProfileScreen(context)
                            }),
                    Expanded(
                        child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 12.0),
                      children: [
                        /// IMAGE SLIDESHOW
                        catalogViewModel.loadingStatus ==
                                LoadingStatus.completed
                            ? Container(
                                margin: const EdgeInsets.only(top: 12.0),
                                height: slideshowHeight,
                                child: catalogViewModel.loadingStatus ==
                                        LoadingStatus.searching
                                    ? Container()
                                    : PageView.builder(
                                        controller: _pageController,
                                        itemCount:
                                            catalogViewModel.banners.length,
                                        itemBuilder: (_, index) {
                                          return SlideShowItemWidget(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                              height: slideshowHeight,
                                              title: catalogViewModel
                                                  .banners[index].title,
                                              url: catalogViewModel
                                                      .banners[index].image ??
                                                  '',
                                              onTap: () => {
                                                    _timer.cancel(),
                                                    catalogViewModel
                                                        .showBannerScreen(
                                                            context,
                                                            catalogViewModel
                                                                .banners[index])
                                                  });
                                        },
                                      ),
                              )
                            : Container(),

                        /// PAGE INDICATOR
                        catalogViewModel.loadingStatus ==
                                    LoadingStatus.searching ||
                                catalogViewModel.banners.isEmpty
                            ? Container()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: Sizes.indicatorHeight(context),
                                    child: SmoothPageIndicator(
                                        controller: _pageController,
                                        count: catalogViewModel.banners.length,
                                        effect: ExpandingDotsEffect(
                                          dotHeight: 8.0,
                                          dotWidth: 8.0,
                                          spacing: 16.0,
                                          activeDotColor: HexColors.white,
                                          dotColor: HexColors.white
                                              .withValues(alpha: 0.2),
                                        )),
                                  ),
                                ],
                              ),

                        /// TYPES
                        catalogViewModel.loadingStatus ==
                                    LoadingStatus.searching ||
                                catalogViewModel.subcategories.isEmpty
                            ? Container()
                            : TweenAnimationBuilder(
                                duration: const Duration(milliseconds: 300),
                                tween: Tween<double>(begin: 1.15, end: 1.0),
                                builder: (BuildContext context, dynamic value,
                                    Widget? child) {
                                  return Transform.scale(
                                      scale: value, child: child);
                                },
                                child: SizedBox(
                                    height: listHeight,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: catalogViewModel
                                                .subcategories.length +
                                            1,
                                        padding: const EdgeInsets.only(
                                            left: 20.0, right: 20.0),
                                        itemBuilder: (context, index) {
                                          return ListItemWidget(
                                              title: index == catalogViewModel.subcategories.length
                                                  ? Titles.newest
                                                  : catalogViewModel
                                                      .subcategories[index]
                                                      .name,
                                              color: index == catalogViewModel.subcategories.length
                                                  ? HexColors.newest
                                                  : HexColors.row,
                                              url: index == catalogViewModel.subcategories.length
                                                  ? ''
                                                  : catalogViewModel
                                                      .subcategories[index]
                                                      .image,
                                              fontSize:
                                                  DeviceDetector.isLarge(context)
                                                      ? 20.0
                                                      : 18.0,
                                              height: listHeight /
                                                      (catalogViewModel
                                                              .subcategories
                                                              .length +
                                                          1) -
                                                  (DeviceDetector.isLarge(context)
                                                      ? 16.0
                                                      : 10.0),
                                              onTap: () => index == catalogViewModel.subcategories.length
                                                  ? catalogViewModel.showProductsScreen(
                                                      context,
                                                      index == catalogViewModel.subcategories.length,
                                                      catalogViewModel.subcategories)
                                                  : catalogViewModel.showCategoryScreen(context, catalogViewModel.subcategories[index]));
                                        })))
                      ],
                    )),
                  ]),

                  /// INDICATOR
                  catalogViewModel.loadingStatus == LoadingStatus.searching
                      ? Center(
                          child: Padding(
                              padding:
                                  EdgeInsets.only(bottom: Sizes.appBarHeight),
                              child: const LoadIndicatorWidget()))
                      : Container(),
                ]))));
  }
}
