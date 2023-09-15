import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';

class BorderButtonWidget extends StatelessWidget {
  final String title;
  final EdgeInsets? margin;
  final VoidCallback onTap;

  const BorderButtonWidget(
      {Key? key, required this.title, this.margin, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margin ?? EdgeInsets.zero,
        height: 56.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(width: 2.0, color: HexColors.border),
          color: Colors.transparent,
        ),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () => onTap(),
                borderRadius: BorderRadius.circular(16.0),
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Center(
                        child: Text(title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              overflow: TextOverflow.ellipsis,
                              color: HexColors.white,
                            )))))));
  }
}
