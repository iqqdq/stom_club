import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:stom_club/constants/hex_colors.dart';

class ProuctInfoWidget extends StatelessWidget {
  final String title;
  final String value;

  const ProuctInfoWidget({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 24.0, left: 20.0, right: 20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 16.0,
                color: HexColors.selected,
              )),
          const SizedBox(height: 6.0),
          // Text(value,
          //     style: TextStyle(
          //       fontFamily: 'Inter',
          //       fontWeight: FontWeight.w400,
          //       fontSize: 16.0,
          //       color: HexColors.black,
          //     ))

          value.isEmpty ? Container() : Html(data: value)
        ]));
  }
}
