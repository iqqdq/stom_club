import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/components/back_button_widget.dart';
import 'package:stom_club/components/default_button.dart';
import 'package:stom_club/components/load_indicator_widget.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/sizes.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/entities/advertising.dart';
import 'package:stom_club/models/banner_view_model.dart';
import 'package:stom_club/services/loading_status.dart';

class BannerScreenBodyWidget extends StatefulWidget {
  final Advertising banner;

  const BannerScreenBodyWidget({Key? key, required this.banner})
      : super(key: key);

  @override
  _BannerScreenBodyState createState() => _BannerScreenBodyState();
}

class _BannerScreenBodyState extends State<BannerScreenBodyWidget> {
  @override
  Widget build(BuildContext context) {
    final _contentViewHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        Sizes.appBarHeight -
        Sizes.tabControllerHeight;
    final _slideshowHeight = _contentViewHeight / 3.0;

    final _bannerViewModel =
        Provider.of<BannerViewModel>(context, listen: true);

    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
          toolbarHeight: Sizes.appBarHeight,
          backgroundColor: HexColors.white,
          centerTitle: false,
          elevation: 0.0,
          leading: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: BackButtonWidget(
                  color: HexColors.white, onTap: () => Navigator.pop(context))),
          title: Text(widget.banner.title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 20.0,
                color: HexColors.black,
              )),
        ),
        body: SizedBox.expand(
            child: Stack(children: [
          _bannerViewModel.loadingStatus == LoadingStatus.searching
              ? Container()
              : ListView(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom == 0.0
                          ? 90.0
                          : MediaQuery.of(context).padding.bottom + 60.0),
                  children: [
                      /// IMAGE
                      Container(
                          height: _slideshowHeight,
                          color: HexColors.gray,
                          child: widget.banner.image == null
                              ? Container()
                              : CachedNetworkImage(
                                  imageUrl: widget.banner.image!,
                                  height: _slideshowHeight,
                                  fit: BoxFit.fitHeight)),

                      /// TEXT
                      widget.banner.text == null
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  top: 24.0, left: 24.0, right: 24.0),
                              child: Html(data: widget.banner.text))
                      // Text('widget.banner.text ?? ',
                      //         style: TextStyle(
                      //           fontFamily: 'Inter',
                      //           fontWeight: FontWeight.w400,
                      //           fontSize: 16.0,
                      //           height: 1.3,
                      //           color: HexColors.black,
                      //         )),
                      //   )
                    ]),

          /// SHOW PRODUCT BUTTON
          widget.banner.product == null
              ? Container()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: DefaultButtonWidget(
                            title: Titles.show_page,
                            onTap: () =>
                                _bannerViewModel.showArticleScreen(context))),
                    SizedBox(
                        height: MediaQuery.of(context).padding.bottom == 0.0
                            ? 12.0
                            : MediaQuery.of(context).padding.bottom)
                  ],
                ),

          /// INDICATOR
          widget.banner.product == null
              ? Container()
              : _bannerViewModel.loadingStatus == LoadingStatus.searching
                  ? Container(
                      margin: const EdgeInsets.only(bottom: 32.0),
                      child: const Center(
                          child: LoadIndicatorWidget(indicatorOnly: true)))
                  : Container(),
        ])));
  }
}
