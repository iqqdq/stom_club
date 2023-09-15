import 'package:flutter/material.dart';
import 'package:stom_club/components/close_button.dart';
import 'package:stom_club/components/default_button.dart';
import 'package:stom_club/components/device_detector.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/titles.dart';

class UpdateScreenBodyWidget extends StatefulWidget {
  final bool isVk;
  final String url;
  final Function(String) onUpdate;

  const UpdateScreenBodyWidget(
      {Key? key, required this.isVk, required this.url, required this.onUpdate})
      : super(key: key);

  @override
  _UpdateScreenBodyState createState() => _UpdateScreenBodyState();
}

class _UpdateScreenBodyState extends State<UpdateScreenBodyWidget> {
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _textEditingController.text = widget.url.isEmpty
        ? widget.isVk
            ? 'https://vk.com'
            : 'https://t.me'
        : widget.url;

    _textEditingController.addListener(() {
      if (_textEditingController.text.contains('vk')) {
        if (_textEditingController.text.length < Titles.vkUrl.length) {
          _textEditingController.text = Titles.vkUrl;
          _textEditingController.selection = TextSelection.fromPosition(
              TextPosition(offset: _textEditingController.text.length));
        }
      } else {
        if (_textEditingController.text.length < Titles.telegramUrl.length) {
          _textEditingController.text = Titles.telegramUrl;
          _textEditingController.selection = TextSelection.fromPosition(
              TextPosition(offset: _textEditingController.text.length));
        }
      }

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
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top +
                    (DeviceDetector().isLarge() ? 0.0 : 12.0)),
            padding: const EdgeInsets.only(top: 16.0),
            decoration: BoxDecoration(
                color: HexColors.background,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0))),
            child: Stack(children: [
              Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 60.0),

                        /// PHONE INPUT
                        TextFormField(
                          keyboardAppearance: Brightness.dark,
                          controller: _textEditingController,
                          focusNode: _focusNode,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: HexColors.selected,
                          textInputAction: TextInputAction.done,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: HexColors.white),
                          decoration: InputDecoration(
                              counterText: '',
                              labelStyle: TextStyle(
                                  color: HexColors.selected,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  fontFamily: 'Inter'),
                              suffixIcon: IconButton(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onPressed: () => setState(() {}),
                                icon: Container(),
                              ),
                              fillColor: HexColors.selected,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: HexColors.unselected),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: HexColors.selected),
                              ),
                              border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: HexColors.unselected),
                              )),
                          onChanged: (text) => setState(() {}),
                          onEditingComplete: () =>
                              FocusScope.of(context).unfocus(),
                        ),

                        const SizedBox(height: 40.0),

                        /// CONTINUE BUTTON
                        DefaultButtonWidget(
                            title: Titles.apply,
                            isEnabled: true,
                            onTap: () => {
                                  FocusScope.of(context).unfocus(),
                                  widget.onUpdate(_textEditingController.text ==
                                              'https://t.me/' ||
                                          _textEditingController.text ==
                                              'https://vk.com/'
                                      ? ''
                                      : _textEditingController.text),
                                  Navigator.pop(context)
                                })
                      ])),

              /// APP BAR
              Padding(
                  padding: const EdgeInsets.only(
                      top: 2.0, left: 20.0, right: 20.0, bottom: 27.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// TITLE
                        Text((widget.isVk ? Titles.vk : Titles.telegram),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 20.0,
                              color: HexColors.white,
                            )),

                        /// CLOSE BUTTON
                        CloseButtonWidget(onTap: () => Navigator.pop(context))
                      ])),
            ])));
  }
}
