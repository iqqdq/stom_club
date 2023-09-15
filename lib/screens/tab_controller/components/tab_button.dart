import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/titles.dart';

class TabButtonWidget extends StatelessWidget {
  final int index;
  final String imagePath;
  final bool isSelected;
  final Function(int) didReturnIndex;

  const TabButtonWidget(
      {Key? key,
      required this.index,
      required this.imagePath,
      required this.isSelected,
      required this.didReturnIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
              onTap: () => didReturnIndex(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ImageIcon(
                    AssetImage(imagePath),
                    color:
                        isSelected ? HexColors.selected : HexColors.unselected,
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Text(
                      index == 0
                          ? Titles.catalog
                          : index == 1
                              ? Titles.articles
                              : index == 2
                                  ? Titles.contacts
                                  : Titles.about,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontFamily: 'Inter',
                        fontSize: 12.0,
                        color: isSelected
                            ? HexColors.selected
                            : HexColors.unselected,
                      ))
                ],
              ),
            )));
  }
}
