import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stom_club/components/device_detector.dart';
import 'package:stom_club/constants/hex_colors.dart';

class ListItemWidget extends StatelessWidget {
  final String title;
  final Color? color;
  final bool? checkbox;
  final double? fontSize;
  final String? url;
  final String? image;
  final double? height;
  final double? padding;
  final String? buttonImagePath;
  final VoidCallback? onTap;
  final VoidCallback? onButtonTap;

  const ListItemWidget(
      {Key? key,
      required this.title,
      this.checkbox,
      this.color,
      this.fontSize,
      this.url,
      this.image,
      this.height,
      this.padding,
      this.buttonImagePath,
      required this.onTap,
      this.onButtonTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding == null
            ? EdgeInsets.only(bottom: DeviceDetector().isLarge() ? 16.0 : 10.0)
            : EdgeInsets.only(bottom: padding!),
        child: Container(
            height: height ?? 68.0,
            decoration: BoxDecoration(
                color: color ?? HexColors.row,
                borderRadius: BorderRadius.circular(24.0)),
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: onTap == null ? null : () => onTap!(),
                    borderRadius: BorderRadius.circular(16.0),
                    child: Padding(
                        padding: const EdgeInsets.only(left: 23.0, right: 14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(children: [
                                /// IMAGE
                                image == null
                                    ? Container()
                                    : Container(
                                        margin:
                                            const EdgeInsets.only(right: 20.0),
                                        child: Image.asset(image!,
                                            width: 32.0,
                                            height: 32.0,
                                            fit: BoxFit.cover)),
                                url == null
                                    ? Container()
                                    : Transform.scale(
                                        scale: DeviceDetector().isLarge()
                                            ? 1.0
                                            : 0.75,
                                        child: Container(
                                            margin: const EdgeInsets.only(
                                                right: 20.0),
                                            child: url!.isEmpty
                                                ? Image.asset(
                                                    'assets/ic_new.png',
                                                    width: 32.0,
                                                    height: 32.0,
                                                    fit: BoxFit.cover)
                                                : CachedNetworkImage(
                                                    imageUrl: url!,
                                                    width: 32.0,
                                                    height: 32.0,
                                                    fit: BoxFit.cover))),

                                /// CHECKBOX
                                Row(children: [
                                  checkbox == null
                                      ? Container()
                                      : Container(
                                          margin: const EdgeInsets.only(
                                              right: 16.0),
                                          width: 24.0,
                                          height: 24.0,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              color: HexColors.unselected),
                                          child: Center(
                                              child: Container(
                                            width: 16.0,
                                            height: 16.0,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                color: HexColors.selected),
                                          )))
                                ]),

                                /// TITLE
                                Expanded(
                                  child: Text(title,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        fontSize: fontSize ?? 18.0,
                                        color: HexColors.white,
                                      )),
                                )
                              ]),
                            ),

                            /// COPY BUTTON
                            onButtonTap == null
                                ? Container()
                                : InkWell(
                                    onTap: () => onButtonTap!(),
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: SizedBox(
                                      width: 44.0,
                                      height: 44.0,
                                      child: Center(
                                        child: buttonImagePath == null
                                            ? Container()
                                            : Image.asset(buttonImagePath!),
                                      ),
                                    ))
                          ],
                        ))))));
  }
}
