import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';

class SeparatorWidget extends StatelessWidget {
  const SeparatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20.0),
      height: 0.5,
      color: HexColors.unselected.withOpacity(0.5),
    );
  }
}
