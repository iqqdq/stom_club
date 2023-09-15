import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'dart:math';

class RatingViewWidget extends StatefulWidget {
  final double rating;
  final int oneStar;
  final int twoStars;
  final int threeStars;
  final int fourStars;
  final int fiveStars;
  final int commentCount;

  const RatingViewWidget(
      {Key? key,
      required this.rating,
      required this.oneStar,
      required this.twoStars,
      required this.threeStars,
      required this.fourStars,
      required this.fiveStars,
      required this.commentCount})
      : super(key: key);

  @override
  _RaitingViewState createState() => _RaitingViewState();
}

class _RaitingViewState extends State<RatingViewWidget> {
  final List<int> _values = [];
  int _max = 0;

  @override
  void initState() {
    _values.add(widget.oneStar);
    _values.add(widget.twoStars);
    _values.add(widget.threeStars);
    _values.add(widget.fourStars);
    _values.add(widget.fiveStars);

    _max = _values.reduce(max);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width - 170.0;
    double _step = _width / _max;
    _step = _step < 0 ? 12.0 : _step;

    return Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 24.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// AVERAGE RATING
                  Text(widget.rating.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 24.0,
                        color: HexColors.black,
                      )),
                  const SizedBox(height: 4.0),

                  /// STAR RATING
                  RatingBar(
                    ignoreGestures: true,
                    direction: Axis.horizontal,
                    initialRating: widget.rating,
                    maxRating: 5.0,
                    itemSize: 16.0,
                    itemCount: 5,
                    ratingWidget: RatingWidget(
                      full: Image.asset('assets/ic_star.png'),
                      empty: Image.asset('assets/ic_empty_star.png'),
                      half: Image.asset('assets/ic_half_star.png'),
                    ),
                    itemPadding: const EdgeInsets.only(right: 4.0),
                    onRatingUpdate: (rating) {
                      // print(rating);
                    },
                  ),
                  const SizedBox(height: 8.0),

                  /// REVIEWS COUNT
                  Text(widget.commentCount.toString(),
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                        color: HexColors.subtitle,
                      )),
                ],
              ),
              const SizedBox(width: 24.0),

              /// INDICATORS
              Container(
                  padding: const EdgeInsets.only(top: 12.0),
                  width: _width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                          duration: const Duration(seconds: 2),
                          margin: const EdgeInsets.only(bottom: 8.0),
                          height: 4.0,
                          color: HexColors.one_star_raiting,
                          width: (widget.fiveStars * _step) > 0
                              ? widget.fiveStars * _step
                              : 12.0),
                      AnimatedContainer(
                          duration: const Duration(seconds: 2),
                          margin: const EdgeInsets.only(bottom: 8.0),
                          height: 4.0,
                          color: HexColors.two_star_raiting,
                          width: (widget.fourStars * _step) > 0
                              ? widget.fourStars * _step
                              : 12.0),
                      AnimatedContainer(
                          duration: const Duration(seconds: 2),
                          margin: const EdgeInsets.only(bottom: 8.0),
                          height: 4.0,
                          color: HexColors.thee_star_raiting,
                          width: (widget.threeStars * _step) > 0
                              ? widget.threeStars * _step
                              : 12.0),
                      AnimatedContainer(
                          duration: const Duration(seconds: 2),
                          margin: const EdgeInsets.only(bottom: 8.0),
                          height: 4.0,
                          color: HexColors.four_star_raiting,
                          width: (widget.twoStars * _step) > 0
                              ? widget.twoStars * _step
                              : 12.0),
                      AnimatedContainer(
                          duration: const Duration(seconds: 2),
                          margin: const EdgeInsets.only(bottom: 8.0),
                          height: 4.0,
                          color: HexColors.five_star_raiting,
                          width: (widget.oneStar * _step) > 0
                              ? widget.oneStar * _step
                              : 12.0),
                    ],
                  ))
            ],
          ),
        ));
  }
}
