import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/sizes.dart';
import 'package:stom_club/constants/titles.dart';

class CatalogAppBarWidget extends StatefulWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onProfileTap;

  const CatalogAppBarWidget(
      {Key? key, required this.onSearchTap, required this.onProfileTap})
      : super(key: key);

  @override
  _CatalogAppBarState createState() => _CatalogAppBarState();
}

class _CatalogAppBarState extends State<CatalogAppBarWidget> {
  double _bottomPadding = Sizes.appBarHeight;

  @override
  void initState() {
    super.initState();

    Future.delayed(
        Duration.zero,
        () => {
              setState(() {
                _bottomPadding = 0.0;
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: AnimatedContainer(
          padding: EdgeInsets.only(bottom: _bottomPadding),
          duration: const Duration(milliseconds: 300),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/ic_tooth.png', width: 18.0, height: 22.0),
                const SizedBox(width: 10.0),
                Image.asset('assets/ic_stom_club.png',
                    width: 88.0, height: 18.0)
              ],
            ),
            Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  /// SEARCH INPUT BUTTON
                  Expanded(
                      child: Container(
                          margin:
                              const EdgeInsets.only(left: 24.0, right: 10.0),
                          height: 52.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.0),
                              color: HexColors.row),
                          child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => widget.onSearchTap(),
                                borderRadius: BorderRadius.circular(16.0),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10.0),
                                    Image.asset('assets/ic_search.png'),
                                    const SizedBox(width: 10.0),
                                    Text(
                                      Titles.search,
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                          color: HexColors.white),
                                    ),
                                    const SizedBox(width: 10.0),
                                  ],
                                ),
                              )))),

                  /// PROFILE BUTTON
                  Container(
                      width: 52.0,
                      height: 52.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.0),
                          color: HexColors.row),
                      child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => widget.onProfileTap(),
                            borderRadius: BorderRadius.circular(16.0),
                            child: Center(
                              child: Image.asset('assets/ic_profile.png'),
                            ),
                          )))
                ]))
          ]),
        ));
  }
}
