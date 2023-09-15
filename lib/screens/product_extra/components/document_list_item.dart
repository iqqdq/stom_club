import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';

class DocumentListItemWidget extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const DocumentListItemWidget(
      {Key? key, required this.name, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: () => onTap(),
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
                margin: const EdgeInsets.symmetric(vertical: 9.0),
                child: Row(children: [
                  Container(
                      width: 68.0,
                      height: 56.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border:
                            Border.all(width: 1.0, color: HexColors.separator),
                        color: Colors.transparent,
                      ),
                      child: Material(
                          color: Colors.transparent,
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset('assets/ic_file.png',
                                  height: 40.0, color: HexColors.black)))),
                  const SizedBox(width: 16.0),
                  Expanded(
                      child: Text(name,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                            overflow: TextOverflow.ellipsis,
                            color: HexColors.black,
                          )))
                ]))));
  }
}
