import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/components/close_button.dart';
import 'package:stom_club/components/default_button.dart';
import 'package:stom_club/components/device_detector.dart';
import 'package:stom_club/components/load_indicator_widget.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/sizes.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/components/selection_list_item.dart';
import 'package:stom_club/entities/profession.dart';
import 'package:stom_club/models/profession_view_model.dart';
import 'package:stom_club/services/loading_status.dart';
import 'package:stom_club/services/pagination.dart';

class ProfessionsScreenBodyWidget extends StatefulWidget {
  final Function(Profession) didReturnValue;

  const ProfessionsScreenBodyWidget({Key? key, required this.didReturnValue})
      : super(key: key);

  @override
  _ProfessionFilterScreenBodyState createState() =>
      _ProfessionFilterScreenBodyState();
}

class _ProfessionFilterScreenBodyState
    extends State<ProfessionsScreenBodyWidget> {
  final ScrollController _scrollController =
      ScrollController(keepScrollOffset: true);
  final Pagination _pagination = Pagination(number: 1, size: 50);
  bool _isRefresh = false;
  int _index = 0;

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
    final _professionsViewModel =
        Provider.of<ProfessionsViewModel>(context, listen: true);

    if (_isRefresh) {
      _isRefresh = !_isRefresh;
      _professionsViewModel.getProfessions(_pagination);
    }

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
                child: Stack(children: [
              SizedBox.expand(
                  child: Column(children: [
                /// APP BAR
                Container(
                  color: HexColors.background,
                  child: Padding(
                      padding: const EdgeInsets.only(
                          top: 2.0, left: 20.0, right: 20.0, bottom: 12.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// TITLE
                            Text(Titles.profession,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.0,
                                  color: HexColors.white,
                                )),

                            /// CLOSE BUTTON
                            CloseButtonWidget(
                                onTap: () => Navigator.pop(context))
                          ])),
                ),
                Expanded(
                    child: RefreshIndicator(
                        onRefresh: _onRefresh,
                        color: HexColors.selected,
                        backgroundColor: HexColors.background,
                        child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            padding: EdgeInsets.only(
                              top: 20.0,
                              left: 20.0,
                              right: 20.0,
                              bottom:
                                  70.0 + MediaQuery.of(context).padding.bottom,
                            ),
                            itemCount: _professionsViewModel.professions.length,
                            itemBuilder: (context, index) {
                              return SelectionListItemWidget(
                                  title: _professionsViewModel
                                      .professions[index].name,
                                  isSelected: _index == index,
                                  onTap: () => setState(() => _index = index));
                            }))),
              ])),

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
                              title: Titles.choose,
                              isEnabled: true,
                              onTap: () => {
                                    widget.didReturnValue(_professionsViewModel
                                        .professions[_index]),
                                    Navigator.pop(context)
                                  }))),

              /// INDICATOR
              _professionsViewModel.loadingStatus == LoadingStatus.searching
                  ? Container(
                      margin: EdgeInsets.only(top: Sizes.appBarHeight + 24.0),
                      child: const LoadIndicatorWidget())
                  : Container()
            ]))));
  }
}
