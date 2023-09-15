import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:stom_club/components/separator.dart';
import 'package:stom_club/constants/hex_colors.dart';

class ParamsListItemWidget extends StatelessWidget {
  final String title;
  final String text;
  final bool isExpanded;
  final VoidCallback onTap;

  const ParamsListItemWidget(
      {Key? key,
      required this.title,
      required this.text,
      required this.isExpanded,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
            onTap: () => onTap(),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 20.0),
                child: Row(
                  children: [
                    /// UNWRAP BUTTON
                    Container(
                      width: 36.0,
                      height: 36.0,
                      decoration: BoxDecoration(
                          color: HexColors.unwrap,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Center(
                        child: Image.asset(isExpanded
                            ? 'assets/ic_minus.png'
                            : 'assets/ic_plus.png'),
                      ),
                    ),
                    const SizedBox(width: 16.0),

                    /// TITLE
                    Expanded(
                        child: Text(title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 18.0,
                              color: HexColors.selected,
                            )))
                  ],
                ))),
        AnimatedSizeAndFade(
          child: isExpanded
              ? Container(
                  margin: const EdgeInsets.only(
                      left: 52.0, right: 20.0, bottom: 20.0),
                  child: Html(data: text, style: {
                    "body": Style(
                      color: HexColors.black,
                    )
                  })

                  //  Text(text,
                  //     style: TextStyle(
                  //       height: 1.5,
                  //       fontFamily: 'Inter',
                  //       fontWeight: FontWeight.w400,
                  //       fontSize: 14.0,
                  //       color: HexColors.black,
                  //     ))
                  )
              : Container(),
          fadeDuration: const Duration(seconds: 300),
          sizeDuration: const Duration(milliseconds: 200),
        ),
        const SeparatorWidget()
      ],
    );
  }
}
