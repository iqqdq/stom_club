import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/components/close_button.dart';
import 'package:stom_club/components/default_button.dart';
import 'package:stom_club/components/load_indicator_widget.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/titles.dart';
import 'dart:io';

import 'package:stom_club/models/registration_view_model.dart';
import 'package:stom_club/services/loading_status.dart';
import 'package:stom_club/services/user_service.dart';

class AvatarScreenBodyWidget extends StatefulWidget {
  final Function(int) onUpdate;

  const AvatarScreenBodyWidget({Key? key, required this.onUpdate})
      : super(key: key);

  @override
  _AvatarScreenBodyState createState() => _AvatarScreenBodyState();
}

class _AvatarScreenBodyState extends State<AvatarScreenBodyWidget> {
  XFile? _xFile;

  // MARK: -
  // MARK: - FUNCTIONS

  void _openGallery() async {
    _xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _registrationViewModel =
        Provider.of<RegistrationViewModel>(context, listen: true);

    return Stack(children: [
      Padding(
          padding: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            /// CROP IMAGE VIEW

            Material(
                color: Colors.transparent,
                child: Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 2.0, color: HexColors.unselected),
                        borderRadius: BorderRadius.circular(100.0)),
                    child: _xFile == null
                        ? InkWell(
                            onTap: () => _openGallery(),
                            borderRadius: BorderRadius.circular(100.0),
                            child: Center(
                              child:

                                  /// TITLE
                                  Text(Titles.upload_photo,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0,
                                        color: HexColors.white,
                                      )),
                            ))
                        : InkWell(
                            onTap: () => _openGallery(),
                            borderRadius: BorderRadius.circular(100.0),
                            child: Container(
                              width: 200.0,
                              height: 200.0,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2.0, color: HexColors.unselected),
                                  borderRadius: BorderRadius.circular(100.0)),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: Image.file(File(_xFile!.path),
                                      fit: BoxFit.cover)),
                            )))),
            const SizedBox(height: 40.0),

            /// CONTINUE BUTTON
            DefaultButtonWidget(
                title: _xFile == null ? Titles.skip : Titles.register,
                isEnabled: true,
                onTap: () => {
                      FocusScope.of(context).unfocus(),
                      if (_xFile == null)
                        {Navigator.pop(context)}
                      else
                        {
                          /// UPDATE USER SOCIAL
                          UserService().getProfessionId().then((id) => {
                                UserService().getUser().then((user) => {
                                      _registrationViewModel
                                          .registerUser(
                                              user!.firstName,
                                              user.lastName,
                                              id,
                                              File(_xFile!.path),
                                              user.city,
                                              user.vkUrl ?? '',
                                              user.telegramUrl ?? '')
                                          .then((value) => {
                                                if (_registrationViewModel
                                                        .user !=
                                                    null)
                                                  Navigator.pop(context)
                                              })
                                    })
                              })
                        }
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
