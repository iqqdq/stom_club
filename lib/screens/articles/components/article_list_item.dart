import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:intl/intl.dart';
import 'package:stom_club/extensions/date_time_extension.dart';

class ArticleListItem extends StatelessWidget {
  final String? url;
  final String title;
  final DateTime dateTime;
  final VoidCallback onTap;

  const ArticleListItem(
      {Key? key,
      required this.url,
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
            child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 12.0, bottom: 12.0),
                child: Column(
                  children: [
                    /// IMAGE
                    Container(
                      width: double.infinity,
                      height: 144.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        color: HexColors.unselected,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.0),
                        child: url == null
                            ? Container()
                            : url!.isEmpty
                                ? Container()
                                : CachedNetworkImage(
                                    imageUrl: url!, fit: BoxFit.fitHeight),
                      ),
                    ),
                    const SizedBox(height: 12.0),

                    Row(children: [
                      /// DATE WIDGET
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: HexColors.row,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /// DAY TITLE
                              Text(DateFormat.d().format(dateTime),
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.0,
                                    color: HexColors.white,
                                  )),
                              const SizedBox(height: 4.0),

                              /// MONTH TITLE
                              Text(DateTimeExtension(dateTime).getMonthName(),
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.0,
                                    color: HexColors.unselected,
                                  )),
                            ],
                          )),
                      const SizedBox(width: 16.0),

                      /// TITLE
                      Expanded(
                        child: Text(title,
                            maxLines: 3,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 18.0,
                              color: HexColors.white,
                            )),
                      ),
                    ]),
                  ],
                ))));
  }
}
