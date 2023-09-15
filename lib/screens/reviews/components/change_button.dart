import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/titles.dart';

class ChangeButtonWidget extends StatelessWidget {
  final VoidCallback onTap;

  const ChangeButtonWidget({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
        child: Container(
            height: 56.0,
            width: double.infinity,
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
                          child: Text(Titles.change,
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
