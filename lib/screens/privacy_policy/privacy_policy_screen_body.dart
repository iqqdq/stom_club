import 'package:flutter/material.dart';
import 'package:stom_club/components/default_button.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/titles.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class PrivacyPolicyScreenBodyWidget extends StatefulWidget {
  final Function(int) onUpdate;

  const PrivacyPolicyScreenBodyWidget({Key? key, required this.onUpdate})
      : super(key: key);

  @override
  _PrivacyPolicyScreenBodyState createState() =>
      _PrivacyPolicyScreenBodyState();
}

class _PrivacyPolicyScreenBodyState
    extends State<PrivacyPolicyScreenBodyWidget> {
  String? _privacyPolicyText;

  @override
  void initState() {
    loadAsset();

    super.initState();
  }

  Future loadAsset() async {
    _privacyPolicyText =
        await rootBundle.loadString('assets/privacy_policy.txt');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          ListView(
              padding: const EdgeInsets.only(
                  top: 60.0, left: 20.0, right: 20.0, bottom: 124.0),
              children: [
                /// TEXT
                Text(_privacyPolicyText ?? '',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      height: 1.5,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                      color: HexColors.white,
                    ))
              ]),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child:

                    /// ACCEPT BUTTON
                    DefaultButtonWidget(
                        title: Titles.i_agree,
                        margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).padding.bottom == 0.0
                                ? 12.0
                                : MediaQuery.of(context).padding.bottom),
                        onTap: () => {widget.onUpdate(3)}),
              )),

          /// TITLE
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              height: 60.0,
              width: double.infinity,
              color: HexColors.background,
              child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(Titles.privacy_policy,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0,
                        color: HexColors.white,
                      )))),
        ]));
  }
}
