import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';

class StepIndicatorWidget extends StatelessWidget {
  final int index;

  const StepIndicatorWidget({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 28.0, left: 20.0, right: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 4.0,
              decoration: BoxDecoration(
                  color: index == 0 ? HexColors.selected : HexColors.gray,
                  borderRadius: BorderRadius.circular(12.0)),
            )),
            Expanded(
                child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 4.0,
              decoration: BoxDecoration(
                  color: index == 1 ? HexColors.selected : HexColors.gray,
                  borderRadius: BorderRadius.circular(12.0)),
            )),
            Expanded(
                child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 4.0,
              decoration: BoxDecoration(
                  color: index == 2 ? HexColors.selected : HexColors.gray,
                  borderRadius: BorderRadius.circular(12.0)),
            )),
            Expanded(
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    height: 4.0,
                    decoration: BoxDecoration(
                        color: index == 3 ? HexColors.selected : HexColors.gray,
                        borderRadius: BorderRadius.circular(12.0))))
          ],
        ));
  }
}
