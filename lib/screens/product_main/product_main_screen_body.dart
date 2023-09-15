import 'dart:async';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stom_club/components/load_indicator_widget.dart';
import 'package:stom_club/components/separator.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/sizes.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/entities/auth_token.dart';
import 'package:stom_club/entities/authorization.dart';
import 'package:stom_club/entities/product.dart';
import 'package:stom_club/components/slideshow_list_item.dart';
import 'package:stom_club/models/product_view_model.dart';
import 'package:stom_club/screens/product_main/components/raiting_view_widget.dart';
import 'package:stom_club/screens/product_main/components/review_button.dart';
import 'package:stom_club/screens/product_main/components/params_list_item.dart';
import 'package:stom_club/screens/product_main/components/product_info.dart';
import 'package:stom_club/services/loading_status.dart';
import 'package:stom_club/services/user_service.dart';

class ProductMainScreenBodyWidget extends StatefulWidget {
  final Product product;
  final Function(Product)? didReturnValue;

  const ProductMainScreenBodyWidget(
      {Key? key, required this.product, this.didReturnValue})
      : super(key: key);

  @override
  _ProductMainScreenBodyState createState() => _ProductMainScreenBodyState();
}

class _ProductMainScreenBodyState extends State<ProductMainScreenBodyWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool _isAuthorized = false;
  final _pageController = PageController();
  late Timer _timer = Timer(const Duration(milliseconds: 1), () => {});
  int _seconds = 5;
  final List<int> _selectedIndexes = [];
  final _images = [];

  @override
  void initState() {
    super.initState();

    _startTimer();

    _getAuthorization();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void _getAuthorization() async {
    UserService userService = UserService();
    Authorization? authorization = await userService.getAuth();

    if (authorization != null) {
      if (authorization.isCreated == false) {
        AuthToken? authToken = await userService.getToken();
        if (authToken != null) {
          _isAuthorized = true;
        }
      }
    }

    setState(() {});
  }

  void _startTimer() {
    if (_images.length > 1) {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) {
          if (_seconds == 0) {
            if (_pageController.page == _images.length - 1) {
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
  }

  void _expand(int index) {
    setState(() {
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.remove(index);
      } else {
        _selectedIndexes.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final _contentViewHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        Sizes.appBarHeight -
        Sizes.tabControllerHeight;
    final _slideshowHeight = _contentViewHeight / 3.0;

    final _productViewModel =
        Provider.of<ProductViewModel>(context, listen: true);

    final _productInfo = _productViewModel.productInfo;

    if (_productInfo != null) {
      if (_productInfo.images.isNotEmpty) {
        if (_images.isEmpty) {
          for (var image in _productInfo.images) {
            _images.add(image.image);
          }

          if (_timer.isActive) {
            _timer.cancel();
          }

          _startTimer();
        }
      }
    }

    return Scaffold(
        backgroundColor: HexColors.white,
        body: Stack(children: [
          ListView(
              padding: EdgeInsets.only(bottom: Sizes.tabControllerHeight),
              children: [
                /// IMAGE SLIDESHOW
                _images.isEmpty
                    ? Container(
                        height: _slideshowHeight,
                        color: HexColors.gray,
                      )
                    : SizedBox(
                        height: _slideshowHeight,
                        width: MediaQuery.of(context).size.width,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _images.length,
                          itemBuilder: (_, index) {
                            return SlideShowItemWidget(
                                margin: EdgeInsets.zero,
                                borderRadius: 0.0,
                                height: _slideshowHeight,
                                url: _images[index],
                                onTap: () => {});
                          },
                        ),
                      ),

                /// INDICATOR
                _images.length < 2
                    ? const SizedBox(
                        height: 20.0,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: Sizes.indicatorHeight,
                            child: SmoothPageIndicator(
                                controller: _pageController,
                                count: _images.length,
                                effect: ExpandingDotsEffect(
                                  dotHeight: 8.0,
                                  dotWidth: 8.0,
                                  spacing: 16.0,
                                  activeDotColor:
                                      HexColors.background.withOpacity(0.9),
                                  dotColor:
                                      HexColors.unselected.withOpacity(0.4),
                                )),
                          ),
                        ],
                      ),

                /// RATING
                _productInfo == null
                    ? Container()
                    : RatingViewWidget(
                        commentCount: _productInfo.reviewsCount,
                        oneStar: _productInfo.oneStar,
                        twoStars: _productInfo.twoStars,
                        threeStars: _productInfo.threeStars,
                        fourStars: _productInfo.fourStars,
                        fiveStars: _productInfo.fiveStars,
                        rating: _productInfo.rating),

                /// COMMENT BUTTON
                _productInfo == null
                    ? Container()
                    : ReviewButton(
                        title: _productViewModel.review != null
                            ? Titles.change_feedback
                            : Titles.feedback,
                        onTap: () => _isAuthorized
                            ? _productViewModel.review == null
                                ? _productViewModel.showReviewScreen(
                                    context, _productViewModel.review)
                                : _productViewModel.showAlert(
                                    context, _productViewModel.review!)
                            : showOkAlertDialog(
                                context: context,
                                title: Titles.warning,
                                message: Titles.only_auth_review)),

                /// DESCRIPTION
                Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 30.0, top: 30.0),
                    child:
                        _productInfo == null || _productInfo.description.isEmpty
                            ? Container()
                            : Html(data: _productInfo.description)
                    //  Text(_productInfo.description,
                    //     style: TextStyle(
                    //       fontFamily: 'Inter',
                    //       fontWeight: FontWeight.w400,
                    //       fontSize: 16.0,
                    //       height: 1.3,
                    //       color: HexColors.black,
                    //     )),
                    ),

                /// CREATOR
                _productInfo == null || _productInfo.manufacturer == null
                    ? Container()
                    : ProuctInfoWidget(
                        title: Titles.creator,
                        value: _productInfo.manufacturer?.name ?? ''),

                /// FORM
                _productInfo == null || _productInfo.releaseForm.isEmpty
                    ? Container()
                    : ProuctInfoWidget(
                        title: Titles.form, value: _productInfo.releaseForm),
                const SeparatorWidget(),

                /// SPECIFICATIONS
                _productInfo == null
                    ? Container()
                    : _productInfo.specifications.isEmpty
                        ? Container()
                        : ParamsListItemWidget(
                            title: Titles.specifications,
                            text: _productInfo.specifications,
                            isExpanded: _selectedIndexes.contains(0),
                            onTap: () => _expand(0)),

                /// PROPERTIES
                _productInfo == null
                    ? Container()
                    : _productInfo.properties.isEmpty
                        ? Container()
                        : ParamsListItemWidget(
                            title: Titles.properties,
                            text: _productInfo.properties,
                            isExpanded: _selectedIndexes.contains(1),
                            onTap: () => _expand(1)),

                /// COMPOUND
                _productInfo == null
                    ? Container()
                    : _productInfo.compound.isEmpty
                        ? Container()
                        : ParamsListItemWidget(
                            title: Titles.compound,
                            text: _productInfo.compound,
                            isExpanded: _selectedIndexes.contains(2),
                            onTap: () => _expand(2)),

                /// PURPOSE
                _productInfo == null
                    ? Container()
                    : _productInfo.purpose.isEmpty
                        ? Container()
                        : ParamsListItemWidget(
                            title: Titles.purpose,
                            text: _productInfo.purpose,
                            isExpanded: _selectedIndexes.contains(3),
                            onTap: () => _expand(3)),

                /// NOTES
                _productInfo == null
                    ? Container()
                    : _productInfo.notes.isEmpty
                        ? Container()
                        : ParamsListItemWidget(
                            title: Titles.notes,
                            text: _productInfo.notes,
                            isExpanded: _selectedIndexes.contains(4),
                            onTap: () => _expand(4)),

                ///  CONTRAINDICATIONS
                _productInfo == null
                    ? Container()
                    : _productInfo.contraindications.isEmpty
                        ? Container()
                        : ParamsListItemWidget(
                            title: Titles.contraindications,
                            text: _productInfo.contraindications,
                            isExpanded: _selectedIndexes.contains(5),
                            onTap: () => _expand(5)),

                /// SIDE EFFECTS
                _productInfo == null
                    ? Container()
                    : _productInfo.sideEffects.isEmpty
                        ? Container()
                        : ParamsListItemWidget(
                            title: Titles.side_effects,
                            text: _productInfo.sideEffects,
                            isExpanded: _selectedIndexes.contains(6),
                            onTap: () => _expand(6)),

                /// TERMS
                _productInfo == null
                    ? Container()
                    : _productInfo.terms.isEmpty
                        ? Container()
                        : ParamsListItemWidget(
                            title: Titles.terms,
                            text: _productInfo.terms,
                            isExpanded: _selectedIndexes.contains(7),
                            onTap: () => _expand(7))
              ]),
          _productViewModel.loadingStatus == LoadingStatus.searching
              ? Container(
                  margin: EdgeInsets.only(top: Sizes.appBarHeight + 24.0),
                  child: const LoadIndicatorWidget(indicatorOnly: true))
              : Container(),
        ]));
  }
}
