import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/components/close_button.dart';
import 'package:stom_club/components/device_detector.dart';
import 'package:stom_club/components/list_item.dart';
import 'package:stom_club/components/load_indicator_widget.dart';
import 'package:stom_club/components/toast_widget.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/constants/ulrs.dart';
import 'package:stom_club/models/profile_view_model.dart';
import 'package:stom_club/screens/update/update_screen.dart';
import 'package:stom_club/services/loading_status.dart';
import 'package:stom_club/services/user_service.dart';

class ProfileScreenBodyWidget extends StatefulWidget {
  final int userId;
  const ProfileScreenBodyWidget({Key? key, required this.userId})
      : super(key: key);

  @override
  _ProfileScreenBodyState createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<ProfileScreenBodyWidget>
    with TickerProviderStateMixin {
  XFile? _xFile;
  late AnimationController _animationController;
  final _images = [
    'assets/ic_location.png',
    'assets/ic_vk.png',
    'assets/ic_telegram.png'
  ];
  bool _isMine = false;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 0));

    _checkMineProfile();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future _checkMineProfile() async {
    /// CHECK IF MINE PROFILE
    UserService().getAuth().then((authorization) => {
          if (authorization == null)
            _isMine = false
          else if (widget.userId == authorization.id)
            _isMine = true
        });
  }

  void _openGallery(ProfileViewModel profileViewModel) async {
    _xFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    _updateProfile(profileViewModel, null, null);
  }

  void _showToast() {
    if (_animationController.value == 0.0) {
      _animationController.forward(from: 0.0).then((value) => Future.delayed(
          const Duration(seconds: 3),
          () => _animationController.reverse(from: 1.0)));
    }
  }

  void _updateProfile(
      ProfileViewModel profileViewModel, String? vk, String? telegram) {
    if (profileViewModel.user != null) {
      profileViewModel.registerUser(
          profileViewModel.user!.firstName,
          profileViewModel.user!.lastName,
          profileViewModel.user!.profession?.id ?? 1,
          _xFile == null ? null : File(_xFile!.path),
          profileViewModel.user!.city,
          vk ?? profileViewModel.user!.vkUrl ?? '',
          telegram ?? profileViewModel.user!.telegramUrl ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: true);

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top +
                    (DeviceDetector().isLarge() ? 0.0 : 12.0)),
            decoration: BoxDecoration(
                color: HexColors.background,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0))),
            child: SizedBox.expand(
                child: Stack(children: [
              ListView(
                physics: DeviceDetector().isLarge()
                    ? const NeverScrollableScrollPhysics()
                    : const ScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 60.0, bottom: 20.0),
                children: [
                  /// PHOTO
                  Stack(children: [
                    _profileViewModel.user == null
                        ? Container()
                        : Center(
                            child: Container(
                                width:
                                    DeviceDetector().isLarge() ? 180.0 : 100.0,
                                height:
                                    DeviceDetector().isLarge() ? 180.0 : 100.0,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2.0,
                                        color: HexColors.unselected),
                                    borderRadius: BorderRadius.circular(
                                        DeviceDetector().isLarge()
                                            ? 90.0
                                            : 50.0)),
                                child: InkWell(
                                    onTap: () => _isMine
                                        ? _openGallery(_profileViewModel)
                                        : {},
                                    borderRadius: BorderRadius.circular(90.0),
                                    child: _isMine &&
                                            _profileViewModel.user?.photo ==
                                                null
                                        ? Center(
                                            child:

                                                /// TITLE
                                                Text(
                                                    _isMine
                                                        ? Titles.upload_photo
                                                        : '',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16.0,
                                                      color: HexColors.white,
                                                    )),
                                          )
                                        : Container(
                                            width: DeviceDetector().isLarge()
                                                ? 180.0
                                                : 100.0,
                                            height: DeviceDetector().isLarge()
                                                ? 180.0
                                                : 100.0,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 2.0,
                                                    color: HexColors
                                                        .unselected),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        DeviceDetector()
                                                                .isLarge()
                                                            ? 90.0
                                                            : 50.0)),
                                            child: _profileViewModel.user!.photo ==
                                                    null
                                                ? Container()
                                                : ClipRRect(
                                                    borderRadius: BorderRadius
                                                        .circular(DeviceDetector()
                                                                .isLarge()
                                                            ? 90.0
                                                            : 50.0),
                                                    child: CachedNetworkImage(
                                                        imageUrl: _profileViewModel
                                                                .user!.photo!
                                                                .startsWith(
                                                                    'https')
                                                            ? _profileViewModel
                                                                .user!.photo!
                                                            : URLs.media_url +
                                                                _profileViewModel
                                                                    .user!
                                                                    .photo!,
                                                        fit: BoxFit.cover)),
                                          ))),
                          )
                  ]),
                  const SizedBox(height: 24.0),

                  /// SUBTITLE
                  Text(_profileViewModel.user?.profession?.name ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                        color: HexColors.unselected,
                      )),
                  const SizedBox(height: 12.0),

                  /// NAME
                  Text(
                      _profileViewModel.user == null
                          ? ''
                          : '${_profileViewModel.user?.firstName} ${_profileViewModel.user?.lastName}',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 28.0,
                        color: HexColors.white,
                      )),

                  /// CONTACTS
                  _profileViewModel.user == null
                      ? Container()
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 24.0),
                          shrinkWrap: true,
                          itemCount: _profileViewModel.user == null
                              ? 0
                              : _images.length,
                          itemBuilder: (context, index) {
                            return ListItemWidget(
                                fontSize: 16.0,
                                padding: 12.0,
                                image: _images[index],
                                buttonImagePath: index == 0
                                    ? null
                                    : _isMine
                                        ? 'assets/ic_edit.png'
                                        : index == 1
                                            ? _profileViewModel.user?.vkUrl ==
                                                    null
                                                ? null
                                                : 'assets/ic_copy.png'
                                            : index == 2
                                                ? _profileViewModel.user!
                                                            .telegramUrl ==
                                                        null
                                                    ? null
                                                    : 'assets/ic_copy.png'
                                                : null,
                                title: index == 0
                                    ? _profileViewModel.user!.city
                                    : index == 1
                                        ? _profileViewModel.user?.vkUrl == null
                                            ? '-'
                                            : _profileViewModel
                                                    .user!.vkUrl!.isEmpty
                                                ? '-'
                                                : _profileViewModel.user!.vkUrl!
                                        : _profileViewModel.user!.telegramUrl ==
                                                null
                                            ? '-'
                                            : _profileViewModel
                                                    .user!.telegramUrl!.isEmpty
                                                ? '-'
                                                : _profileViewModel
                                                    .user!.telegramUrl!,
                                onTap: () => index == 0
                                    ? null
                                    : index == 1
                                        ? _profileViewModel.showVk(context,
                                            _profileViewModel.user!.vkUrl ?? '')
                                        : _profileViewModel.showTelegram(
                                            context,
                                            _profileViewModel
                                                    .user!.telegramUrl ??
                                                ''),
                                onButtonTap: () => index == 0
                                    ? {}
                                    : _isMine
                                        ? {
                                            showMaterialModalBottomSheet(
                                                enableDrag: false,
                                                barrierColor: Colors.black
                                                    .withOpacity(0.5),
                                                context: context,
                                                backgroundColor:
                                                    Colors.transparent,
                                                builder: (context) =>
                                                    UpdateScreenWidget(
                                                        isVk: index == 1,
                                                        url: index == 1
                                                            ? _profileViewModel
                                                                    .user
                                                                    ?.vkUrl ??
                                                                ''
                                                            : _profileViewModel
                                                                    .user
                                                                    ?.telegramUrl ??
                                                                '',
                                                        onUpdate: (value) =>

                                                            //  UPDATE VK/TELEGRAM
                                                            _updateProfile(
                                                                _profileViewModel,
                                                                index == 1
                                                                    ? value
                                                                    : null,
                                                                index == 2
                                                                    ? value
                                                                    : null)))
                                          }
                                        : {
                                            _profileViewModel.copyAddress(
                                                context,
                                                index == 1
                                                    ? _profileViewModel
                                                            .user?.vkUrl ??
                                                        ''
                                                    : _profileViewModel.user
                                                            ?.telegramUrl ??
                                                        ''),
                                            _showToast()
                                          });
                          }),

                  // /// DELETE ACCOUNT BUTTON
                  _isMine
                      ? TextButton(
                          child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  child: Text(Titles.delete_account,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0,
                                          color: HexColors.selected)))),
                          onPressed: () =>
                              _profileViewModel.deleteMyAccount(context),
                        )
                      : Container(),

                  /// LOGOUT BUTTON
                  _isMine
                      ? TextButton(
                          child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  child: Text(Titles.leave_account,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0,
                                          color: HexColors.selected)))),
                          onPressed: () => _profileViewModel.logout(context),
                        )
                      : Container()
                ],
              ),

              /// APP BAR
              Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, left: 20.0, right: 20.0, bottom: 27.0),
                  child: Align(
                      alignment: Alignment.topRight,
                      child:

                          /// CLOSE BUTTON
                          CloseButtonWidget(
                              onTap: () => Navigator.pop(context)))),

              /// INDICATOR
              _profileViewModel.loadingStatus == LoadingStatus.searching
                  ? Container(
                      margin: const EdgeInsets.only(bottom: 32.0),
                      child: const Center(child: LoadIndicatorWidget()))
                  : Container(),

              /// TOAST
              IgnorePointer(
                ignoring: true,
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12.0, left: 20.0, right: 20.0),
                    child: ToastWidget(
                        animationController: _animationController,
                        height: 56.0,
                        text: Titles.copied)),
              )
            ]))));
  }
}
