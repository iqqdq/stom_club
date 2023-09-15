import 'package:flutter/material.dart';
import 'package:stom_club/components/close_button.dart';
import 'package:stom_club/components/default_button.dart';
import 'package:stom_club/components/device_detector.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/entities/subcategory.dart';
import 'package:stom_club/components/selection_list_item.dart';

class CategoryFilterScreenBodyWidget extends StatefulWidget {
  final List<Subcategory> subcategories;
  final Function(List<Subcategory>) didReturnValue;

  const CategoryFilterScreenBodyWidget(
      {Key? key, required this.subcategories, required this.didReturnValue})
      : super(key: key);

  @override
  _CategoryFilterScreenBodyState createState() =>
      _CategoryFilterScreenBodyState();
}

class _CategoryFilterScreenBodyState
    extends State<CategoryFilterScreenBodyWidget> {
  final List<Subcategory> _selectedSubcategories = [];

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
            child: Column(children: [
              /// APP BAR
              Container(
                color: HexColors.background,
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 2.0, left: 20.0, right: 20.0, bottom: 18.0),
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
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(
                        top: 18.0, left: 20.0, bottom: 12.0, right: 20.0),
                    itemCount: widget.subcategories.length,
                    itemBuilder: (context, index) {
                      var _isSelected = false;
                      for (var category in _selectedSubcategories) {
                        if (category.id == widget.subcategories[index].id) {
                          _isSelected = true;
                        }
                      }

                      return SelectionListItemWidget(
                          title: widget.subcategories[index].name,
                          isSelected: _isSelected,
                          onTap: () => setState(() {
                                _selectedSubcategories
                                    .add(widget.subcategories[index]);
                              }));
                    }),
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
                              title: _selectedSubcategories.isEmpty
                                  ? Titles.apply
                                  : '${Titles.apply} (${_selectedSubcategories.length})',
                              isEnabled: _selectedSubcategories.isNotEmpty,
                              onTap: () => {
                                    widget
                                        .didReturnValue(_selectedSubcategories),
                                    Navigator.pop(context)
                                  })))
            ])));
  }
}
