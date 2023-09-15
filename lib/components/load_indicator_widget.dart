import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';

class LoadIndicatorWidget extends StatelessWidget {
  final Size? size;
  final bool? indicatorOnly;

  const LoadIndicatorWidget({Key? key, this.size, this.indicatorOnly})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Center(
            child: Container(
                width: size?.width ?? 70.0,
                height: size?.height ?? 70.0,
                decoration: BoxDecoration(
                  color: indicatorOnly == null
                      ? HexColors.row
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 4.0,
                  valueColor: AlwaysStoppedAnimation<Color>(HexColors.selected),
                )))));
  }
}
