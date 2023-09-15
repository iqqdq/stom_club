import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/titles.dart';

class ReviewsButton extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final VoidCallback onTap;

  const ReviewsButton(
      {Key? key,
      required this.onTap,
      required this.reviewCount,
      required this.rating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        height: 84.0,
        decoration: BoxDecoration(
            color: HexColors.gray, borderRadius: BorderRadius.circular(16.0)),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () => onTap(),
                borderRadius: BorderRadius.circular(16.0),
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(children: [
                      Image.asset('assets/ic_reviews.png'),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
                          width: 0.5,
                          height: 46.0,
                          color: HexColors.unselected.withOpacity(0.5)),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// TITLE
                          Text('${Titles.reviews} ($reviewCount)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 16.0,
                                color: HexColors.black,
                              )),
                          const SizedBox(height: 6.0),

                          /// RATING
                          Row(
                            children: [
                              Text(
                                  rating % 2 == 0
                                      ? rating.toInt().toString()
                                      : rating.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                    color: HexColors.black,
                                  )),
                              const SizedBox(width: 2.0),
                              RatingBar(
                                ignoreGestures: true,
                                initialRating: rating,
                                direction: Axis.horizontal,
                                itemSize: 16.0,
                                itemCount: 5,
                                ratingWidget: RatingWidget(
                                  full: Image.asset('assets/ic_star.png'),
                                  empty:
                                      Image.asset('assets/ic_empty_star.png'),
                                  half: Image.asset('assets/ic_half_star.png'),
                                ),
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                onRatingUpdate: (rating) {
                                  // print(rating);
                                },
                              )
                            ],
                          ),
                        ],
                      )),
                      const SizedBox(width: 10.0),
                      Image.asset('assets/ic_right_arrow.png')
                    ])))));
  }
}
