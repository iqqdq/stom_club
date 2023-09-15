import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';

class SlideShowItemWidget extends StatelessWidget {
  final String? title;
  final double? borderRadius;
  final EdgeInsets? margin;
  final double height;
  final String url;
  final VoidCallback onTap;

  const SlideShowItemWidget(
      {Key? key,
      this.title,
      required this.height,
      required this.url,
      this.borderRadius,
      this.margin,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: height,
          margin: margin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 24.0),
            color: HexColors.gray,
          ),
          child: SizedBox(
              child: Stack(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius ?? 24.0),
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                          width: MediaQuery.of(context).size.width,
                          height: height,
                          imageUrl: url,
                          fit: BoxFit.fitHeight),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: title == null
                                  ? [
                                      Colors.transparent,
                                      Colors.transparent,
                                    ]
                                  : [
                                      Colors.transparent,
                                      HexColors.black.withOpacity(0.72)
                                    ],
                              begin: const FractionalOffset(0.0, 0.4),
                              end: const FractionalOffset(0.0, 1.0),
                              stops: const [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                      )
                    ],
                  )),
              Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Padding(
                  padding: const EdgeInsets.only(left: 19.0, bottom: 18.0),
                  child: Text(title ?? '',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: HexColors.white,
                      )),
                )
              ])
            ],
          )),
        ));
  }
}
