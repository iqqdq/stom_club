import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/components/device_detector.dart';
import 'package:stom_club/components/filter_button.dart';
import 'package:stom_club/components/filter_list_item.dart';
import 'package:stom_club/components/load_indicator_widget.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/sizes.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/models/articles_view_model.dart';
import 'package:stom_club/screens/articles/components/article_list_item.dart';
import 'package:stom_club/services/loading_status.dart';
import 'package:stom_club/services/pagination.dart';

class ArticlesScreenBodyWidget extends StatefulWidget {
  const ArticlesScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _ArticlesScreenBodyState createState() => _ArticlesScreenBodyState();
}

class _ArticlesScreenBodyState extends State<ArticlesScreenBodyWidget>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController =
      ScrollController(keepScrollOffset: true);
  final Pagination _pagination = Pagination(number: 1, size: 50);
  bool _isRefresh = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.number++;
        setState(() => _isRefresh = !_isRefresh);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future<void> _onRefresh() async {
    _pagination.number = 1;
    setState(() => _isRefresh = !_isRefresh);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final _articlesViewModel =
        Provider.of<ArticlesViewModel>(context, listen: true);

    if (_isRefresh) {
      _isRefresh = !_isRefresh;
      _articlesViewModel.getArticleList(
          _pagination, '', '', _articlesViewModel.subcategories);
    }

    return Scaffold(
        backgroundColor: HexColors.background,
        body: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top +
                    (DeviceDetector().isLarge() ? 0.0 : 12.0),
                bottom: Sizes.tabControllerHeight),
            child: SizedBox.expand(
                child: Stack(children: [
              Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 20.0),
                          Image.asset('assets/ic_tooth.png',
                              width: 18.0, height: 22.0),
                          const SizedBox(width: 10.0),
                          Image.asset('assets/ic_stom_club.png',
                              width: 88.0, height: 18.0)
                        ],
                      ),

                      /// FILTER BUTTON
                      FilterButtonWidget(
                          title: Titles.filter,
                          onTap: () => _articlesViewModel.showFilterScreen(
                              context,
                              Pagination(number: 1, size: 40),
                              '',
                              _articlesViewModel.subcategories)),
                    ]),

                const SizedBox(height: 12.0),

                /// HORIZONTAL LIST
                Container(
                    margin: EdgeInsets.only(
                        bottom: _articlesViewModel.subcategories.isEmpty
                            ? 0.0
                            : 4.0),
                    height:
                        _articlesViewModel.subcategories.isEmpty ? 0.0 : 38.0,
                    child: ListView.builder(
                        padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                        scrollDirection: Axis.horizontal,
                        itemCount: _articlesViewModel.subcategories.length,
                        itemBuilder: (context, index) {
                          return FilterListItemWidget(
                              title:
                                  _articlesViewModel.subcategories[index].name,
                              onTap: () => {},
                              onRemoveTap: () =>
                                  _articlesViewModel.removeSubcategory(
                                      Pagination(number: 1, size: 40),
                                      _articlesViewModel
                                          .subcategories[index].id,
                                      ''));
                        })),
                Expanded(
                    child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: HexColors.selected,
                  backgroundColor: HexColors.background,
                  child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      itemCount: _articlesViewModel.articles.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return ArticleListItem(
                            url: _articlesViewModel.articles[index].images ==
                                    null
                                ? ''
                                : _articlesViewModel
                                        .articles[index].images!.isEmpty
                                    ? ''
                                    : _articlesViewModel
                                        .articles[index].images!.first.image,
                            title: _articlesViewModel.articles[index].title,
                            dateTime: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                .parse(_articlesViewModel
                                    .articles[index].createdAt),
                            onTap: () => _articlesViewModel.showArticleScreen(
                                context, _articlesViewModel.articles[index]));
                      }),
                )),
              ]),

              /// NO DATA LABEL
              _articlesViewModel.loadingStatus == LoadingStatus.completed &&
                      _articlesViewModel.articles.isEmpty
                  ? Center(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(Titles.no_results,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16.0,
                                  color: HexColors.unselected))))
                  : Container(),

              /// INDICATOR
              _articlesViewModel.loadingStatus == LoadingStatus.searching
                  ? const Center(child: LoadIndicatorWidget())
                  : Container(),
            ]))));
  }
}
