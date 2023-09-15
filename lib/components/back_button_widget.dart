import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';

class BackButtonWidget extends StatelessWidget {
  final Color? color;
  final Color? backgoundColor;
  final VoidCallback onTap;

  const BackButtonWidget({
    Key? key,
    required this.onTap,
    this.backgoundColor,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22.0),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Image.asset('assets/ic_arrow_back.png',
          width: 44.0, height: 44.0, color: HexColors.selected),
    );
  }
}
