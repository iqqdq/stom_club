import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';

class FilterButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const FilterButtonWidget({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
            color: HexColors.row, borderRadius: BorderRadius.circular(20.0)),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () => onTap(),
                borderRadius: BorderRadius.circular(20.0),
                child: SizedBox(
                    height: 52.0,
                    width: 52.0,
                    child: Center(
                        child: Image.asset('assets/ic_filter.png',
                            width: 18.0,
                            height: 18.0,
                            fit: BoxFit.cover,
                            color: HexColors.unselected))))));
  }
}
