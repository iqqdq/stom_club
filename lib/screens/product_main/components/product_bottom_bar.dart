import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/sizes.dart';
import 'package:stom_club/constants/titles.dart';

class ProductBottomBarWidget extends StatelessWidget {
  final int index;
  final Function(int) didReturnIndex;

  const ProductBottomBarWidget(
      {Key? key, required this.index, required this.didReturnIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 12.0,
          bottom: MediaQuery.of(context).padding.bottom,
          right: 12.0),
      height: Sizes.tabControllerHeight,
      color: HexColors.gray,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// MAIN BUTTON
          Expanded(
              child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () => didReturnIndex(0),
                      borderRadius: BorderRadius.circular(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/ic_basic.png',
                              color: index == 0
                                  ? HexColors.black
                                  : HexColors.unselected),
                          const SizedBox(width: 10.0),
                          Text(Titles.basic,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color: index == 0
                                      ? HexColors.black
                                      : HexColors.unselected))
                        ],
                      )))),
          Container(
              margin: const EdgeInsets.only(right: 12.0),
              width: 0.5,
              height: 33.0,
              color: HexColors.unselected.withOpacity(0.5)),

          /// MORE BUTTON
          Expanded(
              child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () => didReturnIndex(1),
                      borderRadius: BorderRadius.circular(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/ic_extra.png',
                              color: index == 1
                                  ? HexColors.black
                                  : HexColors.unselected),
                          const SizedBox(width: 10.0),
                          Text(Titles.extra,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                                color: index == 1
                                    ? HexColors.black
                                    : HexColors.unselected,
                              ))
                        ],
                      )))),
          const SizedBox(width: 12.0),
        ],
      ),
    );
  }
}
