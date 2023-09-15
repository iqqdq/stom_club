import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/titles.dart';

class RemoveButtonWidget extends StatelessWidget {
  final VoidCallback onTap;

  const RemoveButtonWidget({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
        child: Container(
            height: 26.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(width: 1.0, color: HexColors.separator),
              color: Colors.transparent,
            ),
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () => onTap(),
                    borderRadius: BorderRadius.circular(8.0),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Center(
                          child: Text(Titles.delete,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 16.0,
                                overflow: TextOverflow.ellipsis,
                                color: HexColors.black,
                              )),
                        ))))));
  }
}
