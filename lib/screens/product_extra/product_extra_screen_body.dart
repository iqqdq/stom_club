import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/components/load_indicator_widget.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/sizes.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/entities/product.dart';
import 'package:stom_club/models/product_view_model.dart';
import 'package:stom_club/screens/product_extra/components/document_list_item.dart';
import 'package:stom_club/screens/product_extra/components/extra_list_item.dart';
import 'package:stom_club/screens/product_extra/components/reviews_button.dart';
import 'package:stom_club/services/loading_status.dart';

class ProductExtraScreenBodyWidget extends StatefulWidget {
  final Product product;

  const ProductExtraScreenBodyWidget({Key? key, required this.product})
      : super(key: key);

  @override
  _ProductExtraScreenBodyState createState() => _ProductExtraScreenBodyState();
}

class _ProductExtraScreenBodyState extends State<ProductExtraScreenBodyWidget> {
  @override
  Widget build(BuildContext context) {
    final _productViewModel =
        Provider.of<ProductViewModel>(context, listen: true);

    final _productInfo = _productViewModel.productInfo;

    return Scaffold(
        backgroundColor: HexColors.white,
        body: Stack(children: [
          ListView(
              padding: EdgeInsets.only(bottom: Sizes.tabControllerHeight),
              children: [
                const SizedBox(height: 14.0),
                ReviewsButton(
                    reviewCount:
                        _productViewModel.productInfo?.reviewsCount ?? 0,
                    rating: _productInfo?.rating ?? 0.0,
                    onTap: () => _productViewModel.showReviewsScreen(context)),

                /// ARTICLE LIST
                _productInfo == null
                    ? Container()
                    : _productInfo.articles.articles.isEmpty
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              top: 24.0,
                              bottom: 16.0,
                            ),
                            child: Text(Titles.articles,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.0,
                                  color: HexColors.black,
                                )),
                          ),

                /// ARTICLES
                _productInfo == null
                    ? Container()
                    : SizedBox(
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _productInfo.articles.articles.length,
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, bottom: 32.0),
                            itemBuilder: (context, index) {
                              return ExtraListItem(
                                  title: _productInfo
                                      .articles.articles[index].title,
                                  imageUrl: _productInfo.articles
                                          .articles[index].images.isEmpty
                                      ? ''
                                      : _productInfo.articles.articles[index]
                                          .images.first.image,
                                  dateTime:
                                      DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                          .parse(_productInfo.articles
                                              .articles[index].createdAt),
                                  onTap: () => _productViewModel
                                      .showProductArticleScreen(
                                          context,
                                          _productInfo
                                              .articles.articles[index]));
                            }),
                      ),

                /// VIDEOS TITLE
                _productInfo == null
                    ? Container()
                    : _productInfo.video.isEmpty
                        ? Container()
                        : Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, bottom: 16.0),
                            child: Text(Titles.video,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.0,
                                  color: HexColors.black,
                                )),
                          ),

                /// VIDEOS
                _productInfo == null
                    ? Container()
                    : _productInfo.video.isEmpty
                        ? Container()
                        : SizedBox(
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _productInfo.video.length,
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0, bottom: 32.0),
                                itemBuilder: (context, index) {
                                  return ExtraListItem(
                                      title: _productInfo.video[index].name,
                                      imageUrl:
                                          'https://img.youtube.com/vi/${_productInfo.video[index].videoUrl.substring(_productInfo.video[index].videoUrl.length - 11)}/0.jpg',
                                      dateTime: DateFormat(
                                              "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                          .parse(_productInfo
                                                  .video[index].createdAt ??
                                              ''),
                                      onTap: () => _productViewModel
                                          .openVideoUrl(_productInfo
                                              .video[index].videoUrl));
                                })),

                /// DOCUMENT TITLE
                _productInfo == null
                    ? Container()
                    : _productInfo.documents == null
                        ? Container()
                        : _productInfo.documents!.isEmpty
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0, bottom: 20.0),
                                child: Text(Titles.documents,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20.0,
                                      color: HexColors.black,
                                    )),
                              ),

                /// DOCUMENTS
                _productInfo == null
                    ? Container()
                    : _productInfo.documents == null
                        ? Container()
                        : _productInfo.documents!.isEmpty
                            ? Container()
                            : SizedBox(
                                child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: _productInfo.documents?.length,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    itemBuilder: (context, index) {
                                      var name =
                                          _productInfo.documents![index].name ==
                                                  null
                                              ? ''
                                              : _productInfo
                                                  .documents![index].name!;

                                      var fileType = _productInfo
                                                  .documents![index].fileType ==
                                              null
                                          ? ''
                                          : '.' +
                                              _productInfo
                                                  .documents![index].fileType!;

                                      var url =
                                          _productInfo.documents![index].file;

                                      return DocumentListItemWidget(
                                          name: name + fileType,
                                          onTap: () =>
                                              _productViewModel.openFile(url));
                                    }))
              ]),
          _productViewModel.loadingStatus == LoadingStatus.searching
              ? Container(
                  margin: EdgeInsets.only(top: Sizes.appBarHeight + 24.0),
                  child: const LoadIndicatorWidget(indicatorOnly: true))
              : Container(),
        ]));
  }
}
