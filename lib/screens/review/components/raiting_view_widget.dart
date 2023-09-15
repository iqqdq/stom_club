import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/titles.dart';

class RaitingViewWidget extends StatelessWidget {
  final double rating;
  final Function(double) didReturnValue;

  const RaitingViewWidget(
      {Key? key, required this.rating, required this.didReturnValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 23.0, bottom: 23.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(Titles.set_raiting,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                    color: HexColors.black,
                  )),
              const SizedBox(height: 16.0),
              RatingBar(
                  initialRating: rating,
                  direction: Axis.horizontal,
                  itemSize: 44.0,
                  itemCount: 5,
                  ratingWidget: RatingWidget(
                    full: Image.asset('assets/ic_star.png'),
                    empty: Image.asset('assets/ic_empty_star.png'),
                    half: Image.asset('assets/ic_half_star.png'),
                  ),
                  itemPadding: const EdgeInsets.symmetric(horizontal: 6.0),
                  onRatingUpdate: (rating) => didReturnValue(rating))
            ])));
  }
}
