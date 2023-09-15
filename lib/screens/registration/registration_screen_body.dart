import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/components/default_button.dart';
import 'package:stom_club/components/load_indicator_widget.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/models/registration_view_model.dart';
import 'package:stom_club/services/loading_status.dart';

class RegistrationScreenBodyWidget extends StatefulWidget {
  final Function(int) onUpdate;

  const RegistrationScreenBodyWidget({Key? key, required this.onUpdate})
      : super(key: key);

  @override
  _RegistrationScreenBodyState createState() => _RegistrationScreenBodyState();
}

class _RegistrationScreenBodyState extends State<RegistrationScreenBodyWidget> {
  final _nameTextEditingController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _surnameTextEditingController = TextEditingController();
  final _surnameFocusNode = FocusNode();
  final _cityTextEditingController = TextEditingController();
  final _cityFocusNode = FocusNode();
  final _professionTextEditingController = TextEditingController();
  final _professionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _nameTextEditingController.addListener(() {
      setState(() {});
    });

    _surnameTextEditingController.addListener(() {
      setState(() {});
    });

    _cityTextEditingController.addListener(() {
      setState(() {});
    });

    _professionTextEditingController.addListener(() {
      setState(() {});
    });

    _nameTextEditingController.addListener(() {
      setState(() {});
    });

    _surnameFocusNode.requestFocus();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Widget _getTextFormField(
      TextEditingController textEditingController,
      FocusNode focusNode,
      String hintText,
      RegistrationViewModel registrationViewModel,
      int index) {
    return TextFormField(
      keyboardAppearance: Brightness.dark,
      readOnly: index == 3,
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
          color: HexColors.white),
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
            icon: textEditingController.text.isEmpty ||
                    !focusNode.hasFocus ||
                    index == 3
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
      onTap: () => setState(() => {
            if (index == 3) registrationViewModel.showSelectionScreen(context)
          }),
      onEditingComplete: () => setState(() {
        switch (index) {
          case 0:
            _nameFocusNode.requestFocus();
            break;
          case 1:
            _cityFocusNode.requestFocus();
            break;

          default:
            FocusScope.of(context).unfocus();
        }
      }),
    );
  }

  @override
  void dispose() {
    _nameTextEditingController.dispose();
    _surnameTextEditingController.dispose();
    _cityTextEditingController.dispose();
    _professionTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _registrationViewModel =
        Provider.of<RegistrationViewModel>(context, listen: true);

    _professionTextEditingController.text =
        _registrationViewModel.profession == null
            ? ''
            : _registrationViewModel.profession!.name;

    return Stack(children: [
      SizedBox.expand(
          child: Padding(
              padding:
                  const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
              child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: [
                    /// SURNAME INPUT
                    _getTextFormField(
                        _surnameTextEditingController,
                        _surnameFocusNode,
                        Titles.surname,
                        _registrationViewModel,
                        0),
                    const SizedBox(height: 16.0),

                    /// NAME INPUT
                    _getTextFormField(_nameTextEditingController,
                        _nameFocusNode, Titles.name, _registrationViewModel, 1),
                    const SizedBox(height: 16.0),

                    /// CITY INPUT
                    _getTextFormField(_cityTextEditingController,
                        _cityFocusNode, Titles.city, _registrationViewModel, 2),
                    const SizedBox(height: 16.0),

                    /// PROFESSION INPUT
                    _getTextFormField(
                        _professionTextEditingController,
                        _professionFocusNode,
                        Titles.profession,
                        _registrationViewModel,
                        3),
                    const SizedBox(height: 40.0),

                    /// CONTINUE BUTTON
                    DefaultButtonWidget(
                        title: Titles.continuee,
                        isEnabled: _surnameTextEditingController.text.length >=
                                2 &&
                            _nameTextEditingController.text.length >= 2 &&
                            _cityTextEditingController.text.length >= 2 &&
                            _professionTextEditingController.text.isNotEmpty,
                        onTap: () => {
                              FocusScope.of(context).unfocus(),

                              // REGISTER A NEW USER
                              _registrationViewModel
                                  .registerUser(
                                      _nameTextEditingController.text,
                                      _surnameTextEditingController.text,
                                      _registrationViewModel.profession?.id ??
                                          1,
                                      null,
                                      _cityTextEditingController.text,
                                      '',
                                      '')
                                  .then((value) => {
                                        if (_registrationViewModel.user != null)
                                          widget.onUpdate(4)
                                      })
                            })
                  ]))),

      /// APP BAR
      Padding(
          padding: const EdgeInsets.only(
              top: 8.0, left: 20.0, right: 20.0, bottom: 27.0),
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
            // CloseButtonWidget(onTap: () => Navigator.pop(context))
          ])),

      /// INDICATOR
      _registrationViewModel.loadingStatus == LoadingStatus.searching
          ? const Padding(
              padding: EdgeInsets.only(bottom: 36.0),
              child: Center(child: LoadIndicatorWidget()))
          : Container()
    ]);
  }
}
