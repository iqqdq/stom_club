import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/components/close_button.dart';
import 'package:stom_club/components/default_button.dart';
import 'package:stom_club/components/device_detector.dart';
import 'package:stom_club/components/load_indicator_widget.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/entities/subcategory.dart';
import 'package:stom_club/models/article_filter_view_model.dart';
import 'package:stom_club/components/selection_list_item.dart';
import 'package:stom_club/services/loading_status.dart';

class ArticleFilterScreenBodyWidget extends StatefulWidget {
  final List<Subcategory> selectedSubcategories;
  final Function(List<Subcategory>) didReturnValue;

  const ArticleFilterScreenBodyWidget(
      {Key? key,
      required this.selectedSubcategories,
      required this.didReturnValue})
      : super(key: key);

  @override
  _ArticleFilterScreenBodyState createState() =>
      _ArticleFilterScreenBodyState();
}

class _ArticleFilterScreenBodyState
    extends State<ArticleFilterScreenBodyWidget> {
  @override
  Widget build(BuildContext context) {
    final articleFilterViewModel =
        Provider.of<ArticleFilterViewModel>(context, listen: true);

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top +
                    (DeviceDetector.isLarge(context) ? 0.0 : 12.0)),
            padding: const EdgeInsets.only(top: 16.0),
            decoration: BoxDecoration(
                color: HexColors.background,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0))),
            child: Stack(children: [
              SizedBox.expand(
                child: ListView.builder(
                    padding: const EdgeInsets.only(
                        top: 64.0, left: 20.0, bottom: 90.0, right: 20.0),
                    itemCount: articleFilterViewModel.subcategories.length,
                    itemBuilder: (context, index) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16.0),
                            Text(
                                articleFilterViewModel.subcategories[index]
                                        .subcategories.isEmpty
                                    ? ''
                                    : articleFilterViewModel
                                        .subcategories[index].name,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  color: HexColors.unselected,
                                )),
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(top: 20.0),
                                itemCount: articleFilterViewModel
                                    .subcategories[index].subcategories.length,
                                itemBuilder: (context, subcategoryIndex) {
                                  var isSelected = false;

                                  for (var manufacturer
                                      in articleFilterViewModel
                                          .selectedSubcategories) {
                                    if (manufacturer.id ==
                                        articleFilterViewModel
                                            .subcategories[index]
                                            .subcategories[subcategoryIndex]
                                            .id) {
                                      isSelected = true;
                                    }
                                  }

                                  return SelectionListItemWidget(
                                      title: articleFilterViewModel
                                          .subcategories[index]
                                          .subcategories[subcategoryIndex]
                                          .name,
                                      isSelected: isSelected,
                                      onTap: () => articleFilterViewModel
                                          .onItemSelect(articleFilterViewModel
                                                  .subcategories[index]
                                                  .subcategories[
                                              subcategoryIndex]));
                                })
                          ]);
                    }),
              ),

              /// APP BAR
              Container(
                color: HexColors.background,
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 2.0, left: 20.0, right: 20.0, bottom: 27.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// TITLE
                          Text(Titles.category,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 20.0,
                                color: HexColors.white,
                              )),

                          /// CLOSE BUTTON
                          CloseButtonWidget(onTap: () => Navigator.pop(context))
                        ])),
              ),

              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                          bottom: MediaQuery.of(context).padding.bottom == 0.0
                              ? 12.0
                              : MediaQuery.of(context).padding.bottom),
                      child:

                          /// APPLY BUTTON
                          DefaultButtonWidget(
                              title: articleFilterViewModel
                                      .selectedSubcategories.isEmpty
                                  ? Titles.apply
                                  : '${Titles.apply} (${articleFilterViewModel.selectedSubcategories.length})',
                              isEnabled: articleFilterViewModel
                                  .selectedSubcategories.isNotEmpty,
                              onTap: () => articleFilterViewModel.onApplyTap(
                                  context, widget.didReturnValue)))),

              /// INDICATOR
              articleFilterViewModel.loadingStatus == LoadingStatus.searching
                  ? Container(
                      margin: const EdgeInsets.only(bottom: 32.0),
                      child: const Center(child: LoadIndicatorWidget()))
                  : Container()
            ])));
  }
}
