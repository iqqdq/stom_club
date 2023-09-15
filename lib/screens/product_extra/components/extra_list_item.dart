import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';

class ExtraListItem extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final DateTime dateTime;
  final VoidCallback onTap;

  const ExtraListItem(
      {Key? key,
      this.imageUrl,
      required this.title,
      required this.dateTime,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: () => onTap(),
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
                height: 60.0,
                margin: const EdgeInsets.symmetric(vertical: 9.0),
                padding: const EdgeInsets.only(
                  right: 10.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: SizedBox.expand(
                    child: Row(
                  children: [
                    /// IMAGE
                    Container(
                      width: 68.0,
                      height: 56.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: HexColors.gray),
                      child: imageUrl == null
                          ? Container()
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: CachedNetworkImage(
                                  imageUrl: imageUrl!,
                                  width: 68.0,
                                  height: 56.0,
                                  fit: BoxFit.cover),
                            ),
                    ),
                    const SizedBox(width: 16.0),

                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// DATE
                        Text(
                            '${dateTime.day}.${dateTime.month}.${dateTime.year}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0,
                              color: HexColors.subtitle,
                            )),
                        const SizedBox(height: 4.0),

                        /// TITLE
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                            color: HexColors.black,
                          ),
                        )
                      ],
                    ))
                  ],
                )))));
  }
}
