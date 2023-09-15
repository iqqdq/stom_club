import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';

class ReviewButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ReviewButton({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 56.0,
      decoration: BoxDecoration(
          border: Border.all(
              width: 1.0, color: HexColors.unselected.withOpacity(0.25)),
          borderRadius: BorderRadius.circular(16.0)),
      child: Material(
          color: Colors.transparent,
          child: InkWell(
              onTap: () => onTap(),
              borderRadius: BorderRadius.circular(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: HexColors.black,
                      )),
                  const SizedBox(width: 10.0),
                  Image.asset('assets/ic_reviews.png')
                ],
              ))),
    );
  }
}
