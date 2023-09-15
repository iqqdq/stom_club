import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';

class SelectionListItemWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  const SelectionListItemWidget(
      {Key? key,
      required this.title,
      required this.isSelected,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
        ignoring: onTap == null,
        child: Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            height: 64.0,
            decoration: BoxDecoration(
                color: HexColors.row,
                borderRadius: BorderRadius.circular(24.0)),
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () => onTap!(),
                    borderRadius: BorderRadius.circular(16.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 23.0, right: 14.0),
                      child: Row(children: [
                        Row(children: [
                          /// CHECKBOX
                          Container(
                              margin: const EdgeInsets.only(right: 16.0),
                              width: 24.0,
                              height: 24.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: HexColors.unselected),
                              child: isSelected
                                  ? Center(
                                      child: Container(
                                      width: 16.0,
                                      height: 16.0,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: HexColors.selected),
                                    ))
                                  : Container())
                        ]),

                        /// TITLE
                        Expanded(
                          child: Text(title,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 18.0,
                                color: HexColors.white,
                              )),
                        )
                      ]),
                    )))));
  }
}
