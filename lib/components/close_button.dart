import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/titles.dart';

class CloseButtonWidget extends StatelessWidget {
  final String? title;
  final VoidCallback onTap;

  const CloseButtonWidget({Key? key, required this.onTap, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 32.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.transparent,
        ),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () => onTap(),
                borderRadius: BorderRadius.circular(8.0),
                child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(title ?? Titles.close,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 16.0,
                            color: HexColors.selected))))));
  }
}
