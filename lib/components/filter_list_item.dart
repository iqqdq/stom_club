import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';

class FilterListItemWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final VoidCallback? onRemoveTap;

  const FilterListItemWidget(
      {Key? key, required this.title, required this.onTap, this.onRemoveTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 10.0),
        decoration: BoxDecoration(
            color: HexColors.row, borderRadius: BorderRadius.circular(24.0)),
        child: Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 6.0, bottom: 6.0),
            child: Row(children: [
              const SizedBox(width: 8.0),

              /// TITLE
              Text(title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                    color: HexColors.white,
                  )),
              const SizedBox(width: 8.0),

              /// REMOVE BUTTON
              InkWell(
                  onTap: () => onRemoveTap != null ? onRemoveTap!() : null,
                  borderRadius: BorderRadius.circular(16.0),
                  child: SizedBox(
                    width: 44.0,
                    height: 44.0,
                    child: Center(
                      child: Image.asset('assets/ic_clear.png'),
                    ),
                  ))
            ])));
  }
}
