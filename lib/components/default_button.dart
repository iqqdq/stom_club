import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';

class DefaultButtonWidget extends StatelessWidget {
  final String title;
  final Color? color;
  final Color? titleColor;
  final EdgeInsets? margin;
  final bool? isEnabled;
  final VoidCallback onTap;

  const DefaultButtonWidget(
      {Key? key,
      required this.title,
      required this.onTap,
      this.color,
      this.titleColor,
      this.margin,
      this.isEnabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _isEnabled = isEnabled == null ? true : isEnabled!;

    return IgnorePointer(
        ignoring: !_isEnabled,
        child: Opacity(
            opacity: _isEnabled ? 1.0 : 0.5,
            child: Container(
                margin: margin ?? EdgeInsets.zero,
                height: 56.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: color ?? HexColors.selected,
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
                                    color: _isEnabled
                                        ? titleColor ?? HexColors.white
                                        : titleColor ??
                                            HexColors.white.withOpacity(0.5),
                                  )))),
                    )))));
  }
}
