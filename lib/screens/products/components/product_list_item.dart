import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';

class ProductListItem extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final double rating;
  final int reviewsCount;
  final VoidCallback onTap;

  const ProductListItem(
      {Key? key,
      this.imageUrl,
      required this.title,
      required this.rating,
      required this.reviewsCount,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: HexColors.row,
        ),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () => onTap(),
                borderRadius: BorderRadius.circular(16.0),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 12.0,
                    bottom: 12.0,
                    left: 16.0,
                    right: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          Stack(children: [
                            Container(
                              width: 56.0,
                              height: 56.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: HexColors.unselected),
                            ),
                            imageUrl == null
                                ? Container()
                                : imageUrl!.isEmpty
                                    ? Container()
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        child: CachedNetworkImage(
                                            imageUrl: imageUrl!,
                                            width: 56.0,
                                            height: 56.0,
                                            fit: BoxFit.cover)),
                          ]),
                          const SizedBox(width: 16.0),
                          Expanded(
                              child: SizedBox(
                                  height: 60.0,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// TITLE
                                      Text(title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.0,
                                            color: HexColors.white,
                                          )),

                                      Row(
                                        children: [
                                          /// RATING
                                          Row(
                                            children: [
                                              Image.asset('assets/ic_star.png',
                                                  width: 14.0,
                                                  height: 14.0,
                                                  fit: BoxFit.cover),
                                              const SizedBox(width: 4.0),
                                              Text(
                                                  rating % 2 == 0
                                                      ? rating
                                                          .toInt()
                                                          .toString()
                                                      : rating.toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14.0,
                                                    color: HexColors.selected,
                                                  ))
                                            ],
                                          ),
                                          const SizedBox(width: 12.0),

                                          /// COMMENT'S COUNT
                                          Row(
                                            children: [
                                              Image.asset(
                                                  'assets/ic_comment.png',
                                                  width: 14.0,
                                                  height: 14.0,
                                                  fit: BoxFit.cover),
                                              const SizedBox(width: 4.0),
                                              Text(reviewsCount.toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14.0,
                                                    color: HexColors.unselected,
                                                  ))
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  )))
                        ],
                      )),
                      Image.asset('assets/ic_right_arrow.png')
                    ],
                  ),
                ))));
  }
}
