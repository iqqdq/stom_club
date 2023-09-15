import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/components/close_button.dart';
import 'package:stom_club/components/default_button.dart';
import 'package:stom_club/components/load_indicator_widget.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/models/registration_view_model.dart';
import 'package:stom_club/services/loading_status.dart';
import 'package:stom_club/services/user_service.dart';

class SocialScreenBodyWidget extends StatefulWidget {
  final Function(int) onUpdate;

  const SocialScreenBodyWidget({Key? key, required this.onUpdate})
      : super(key: key);

  @override
  _SocialScreenBodyState createState() => _SocialScreenBodyState();
}

class _SocialScreenBodyState extends State<SocialScreenBodyWidget> {
  final _vkTextEditingController = TextEditingController(text: Titles.vkUrl);
  final _vkFocusNode = FocusNode();
  final _telegramTextEditingController =
      TextEditingController(text: Titles.telegramUrl);
  final _telegramFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _vkTextEditingController.addListener(() {
      if (_vkTextEditingController.text.length < Titles.vkUrl.length) {
        _vkTextEditingController.text = Titles.vkUrl;
        _vkTextEditingController.selection = TextSelection.fromPosition(
            TextPosition(offset: _vkTextEditingController.text.length));
      }

      setState(() {});
    });

    _telegramTextEditingController.addListener(() {
      if (_telegramTextEditingController.text.length <
          Titles.telegramUrl.length) {
        _telegramTextEditingController.text = Titles.telegramUrl;
        _telegramTextEditingController.selection = TextSelection.fromPosition(
            TextPosition(offset: _telegramTextEditingController.text.length));
      }

      setState(() {});
    });

    _vkFocusNode.requestFocus();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Widget _getTextFormField(TextEditingController textEditingController,
      FocusNode focusNode, String hintText, int index) {
    return TextFormField(
      keyboardAppearance: Brightness.dark,
      controller: textEditingController,
      focusNode: focusNode,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      cursorColor: HexColors.selected,
      textInputAction: TextInputAction.done,
      style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: HexColors.selected),
      decoration: InputDecoration(
          counterText: '',
          labelText: hintText,
          labelStyle: TextStyle(
              color: HexColors.subtitle,
              fontWeight: FontWeight.w400,
              fontSize: 14.0,
              fontFamily: 'Inter'),
          suffixIcon: IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () => setState(() {
              textEditingController.clear();
            }),
            icon: textEditingController.text.isEmpty || !focusNode.hasFocus
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
      onTap: () => setState(() {}),
      onEditingComplete: () => setState(() {
        switch (index) {
          case 0:
            _telegramFocusNode.requestFocus();
            break;
          case 1:
            FocusScope.of(context).unfocus();
            break;
          default:
        }
      }),
    );
  }

  @override
  void dispose() {
    _vkTextEditingController.dispose();
    _telegramTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _registrationViewModel =
        Provider.of<RegistrationViewModel>(context, listen: true);

    return Stack(children: [
      Padding(
          padding: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            /// VK INPUT
            _getTextFormField(
                _vkTextEditingController, _vkFocusNode, Titles.vk, 0),
            const SizedBox(height: 16.0),

            /// TELEGRAM INPUT
            _getTextFormField(_telegramTextEditingController,
                _telegramFocusNode, Titles.telegram, 1),
            const SizedBox(height: 40.0),

            /// CONTINUE BUTTON
            DefaultButtonWidget(
                title: _vkTextEditingController.text.length >
                            Titles.vkUrl.length ||
                        _telegramTextEditingController.text.length >
                            Titles.telegramUrl.length
                    ? Titles.continuee
                    : Titles.skip,
                isEnabled: true,
                onTap: () => {
                      FocusScope.of(context).unfocus(),
                      _vkTextEditingController.text.length > 7 ||
                              _telegramTextEditingController.text.length > 5
                          ? {
                              /// UPDATE USER SOCIAL
                              UserService().getProfessionId().then((id) => {
                                    UserService().getUser().then((user) => {
                                          _registrationViewModel
                                              .registerUser(
                                                  user!.firstName,
                                                  user.lastName,
                                                  id,
                                                  null,
                                                  user.city,
                                                  _vkTextEditingController
                                                              .text ==
                                                          'https://vk.com/'
                                                      ? ''
                                                      : _vkTextEditingController
                                                          .text,
                                                  _telegramTextEditingController
                                                              .text ==
                                                          'https://t.me/'
                                                      ? ''
                                                      : _telegramTextEditingController
                                                          .text)
                                              .then((value) => {
                                                    if (_registrationViewModel
                                                            .user !=
                                                        null)
                                                      widget.onUpdate(5)
                                                  })
                                        })
                                  })
                            }
                          : widget.onUpdate(5)
                    })
          ])),

      /// APP BAR
      Padding(
          padding: const EdgeInsets.only(
              top: 2.0, left: 20.0, right: 20.0, bottom: 27.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            /// TITLE
            Text(Titles.registration,
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
      _registrationViewModel.loadingStatus == LoadingStatus.searching
          ? Container(
              margin: const EdgeInsets.only(bottom: 32.0),
              child: const Center(child: LoadIndicatorWidget()))
          : Container()
    ]);
  }
}
