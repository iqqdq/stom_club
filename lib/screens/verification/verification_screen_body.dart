import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/components/border_button.dart';
import 'package:stom_club/components/close_button.dart';
import 'package:stom_club/components/default_button.dart';
import 'package:stom_club/components/load_indicator_widget.dart';
import 'package:stom_club/components/phone_mask.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/models/verification_view_model.dart';
import 'package:stom_club/services/loading_status.dart';

class VerificationScreenBodyWidget extends StatefulWidget {
  final Function(int) onUpdate;

  const VerificationScreenBodyWidget({Key? key, required this.onUpdate})
      : super(key: key);

  @override
  _VerificationScreenBodyState createState() => _VerificationScreenBodyState();
}

class _VerificationScreenBodyState extends State<VerificationScreenBodyWidget> {
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();
  late Timer _timer;
  int _seconds = 59;

  @override
  void initState() {
    super.initState();

    _textEditingController.addListener(() {
      setState(() {});
    });

    _focusNode.requestFocus();

    _startTimer();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _timer.cancel();
    super.dispose();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        setState(() {
          if (_seconds == 0) {
            _timer.cancel();
          } else {
            _seconds--;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _verificationViewModel =
        Provider.of<VerificationViewModel>(context, listen: true);

    return Stack(children: [
      Padding(
          padding: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
          child: Column(children: [
            Text(Titles.incoming_call,
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.5,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0,
                  color: HexColors.subtitle,
                )),

            const SizedBox(height: 16.0),

            /// PHONE TITLE
            Text(
                PhoneMask()
                    .setMask(_verificationViewModel.authorization?.phone ?? ''),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 24.0,
                  color: HexColors.white,
                )),

            const SizedBox(height: 30.0),

            /// PHONE INPUT
            SizedBox(
                width: 140.0,
                child: TextFormField(
                  keyboardAppearance: Brightness.dark,
                  textAlign: TextAlign.center,
                  maxLength: 4,
                  controller: _textEditingController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.phone,
                  cursorColor: HexColors.selected,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: HexColors.white),
                  decoration: InputDecoration(
                      counterText: '',
                      hintText: Titles.code,
                      hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: HexColors.unselected),
                      fillColor: HexColors.selected,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HexColors.unselected),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HexColors.selected),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: HexColors.unselected),
                      )),
                  onChanged: (text) => {
                    if (text.length == 4)
                      {
                        FocusScope.of(context).unfocus(),

                        /// VERIFY IS USER EXISTS
                        Future.delayed(
                            const Duration(milliseconds: 200),
                            () => _verificationViewModel
                                .verify(context, _textEditingController)
                                .then((value) async => {
                                      if (_verificationViewModel.authToken !=
                                          null)
                                        if (_verificationViewModel
                                            .authorization!.isCreated)
                                          widget.onUpdate(2)
                                        else
                                          Navigator.pop(context)
                                    }))
                      }
                  },
                  onEditingComplete: () => FocusScope.of(context).unfocus(),
                )),

            const SizedBox(height: 40.0),

            /// RESEND BUTTON
            DefaultButtonWidget(
                title: _seconds == 0
                    ? Titles.resend_code
                    : '${Titles.resend_code_after} $_seconds с',
                isEnabled: _seconds == 0,
                onTap: () => {
                      FocusScope.of(context).unfocus(),
                      _verificationViewModel.resend(context).then((value) =>
                          {_seconds = 59, _timer.cancel(), _startTimer()})
                    }),
            const SizedBox(height: 16.0),
            // BACK BUTTON
            BorderButtonWidget(
                title: Titles.back, onTap: () => widget.onUpdate(0))
          ])),

      /// APP BAR
      Padding(
          padding: const EdgeInsets.only(
              top: 2.0, left: 20.0, right: 20.0, bottom: 27.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            /// TITLE
            Text(Titles.code,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0,
                  color: HexColors.white,
                )),

            /// CLOSE BUTTON
            CloseButtonWidget(onTap: () => Navigator.pop(context))
          ])),

      /// INDICATOR
      _verificationViewModel.loadingStatus == LoadingStatus.searching
          ? Container(
              margin: const EdgeInsets.only(bottom: 32.0),
              child: const Center(child: LoadIndicatorWidget()))
          : Container()
    ]);
  }
}
