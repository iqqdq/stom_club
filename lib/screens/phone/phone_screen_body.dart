import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/components/close_button.dart';
import 'package:stom_club/components/default_button.dart';
import 'package:stom_club/components/load_indicator_widget.dart';
import 'package:stom_club/components/phone_mask.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/models/authorization_view_model.dart';
import 'package:stom_club/services/loading_status.dart';

class PhoneScreenBodyWidget extends StatefulWidget {
  final Function(int) onUpdate;

  const PhoneScreenBodyWidget({Key? key, required this.onUpdate})
      : super(key: key);

  @override
  _PhoneScreenBodyState createState() => _PhoneScreenBodyState();
}

class _PhoneScreenBodyState extends State<PhoneScreenBodyWidget> {
  final _textEditingController = TextEditingController(text: '+7 ');
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _textEditingController.addListener(() {
      setState(() {});
    });

    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _authorizationViewModel =
        Provider.of<AuthorizationViewModel>(context, listen: true);

    return Stack(children: [
      Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 60.0),

            /// PHONE INPUT
            TextFormField(
              maxLength: 18,
              keyboardAppearance: Brightness.dark,
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
                  labelText: Titles.phone,
                  labelStyle: TextStyle(
                      color: HexColors.selected,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                      fontFamily: 'Inter'),
                  suffixIcon: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () => setState(() {
                      _textEditingController.text = '+7';
                      _textEditingController.selection =
                          TextSelection.fromPosition(TextPosition(
                              offset: _textEditingController.text.length));
                    }),
                    icon: _textEditingController.text.isEmpty
                        ? Container()
                        : Image.asset('assets/ic_clear.png',
                            width: 20.0,
                            height: 20.0,
                            fit: BoxFit.cover,
                            color: HexColors.unselected),
                  ),
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
              onChanged: (text) => setState(() {
                _textEditingController.text = PhoneMask().setMask(text);
                _textEditingController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _textEditingController.text.length));
              }),
              onEditingComplete: () => FocusScope.of(context).unfocus(),
            ),

            const SizedBox(height: 40.0),

            /// CONTINUE BUTTON
            DefaultButtonWidget(
                title: Titles.continuee,
                isEnabled: _textEditingController.text.length == 18,
                onTap: () => {
                      FocusScope.of(context).unfocus(),

                      /// VERIFY USER AUTH
                      Future.delayed(
                          const Duration(milliseconds: 200),
                          () => _authorizationViewModel
                              .authorize(context, _textEditingController)
                              .then((value) => {
                                    if (_authorizationViewModel.authorization !=
                                        null)
                                      widget.onUpdate(1)
                                  }))
                    })
          ])),

      /// APP BAR
      Padding(
          padding: const EdgeInsets.only(
              top: 2.0, left: 20.0, right: 20.0, bottom: 27.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            /// TITLE
            Text(Titles.enter,
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
      _authorizationViewModel.loadingStatus == LoadingStatus.searching
          ? Container(
              margin: const EdgeInsets.only(bottom: 32.0),
              child: const Center(child: LoadIndicatorWidget()))
          : Container()
    ]);
  }
}
