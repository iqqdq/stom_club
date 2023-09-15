import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/components/device_detector.dart';
import 'package:stom_club/components/list_item.dart';
import 'package:stom_club/components/load_indicator_widget.dart';
import 'package:stom_club/components/toast_widget.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/sizes.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/models/about_view_model.dart';
import 'package:stom_club/services/loading_status.dart';

class AboutScreenBodyWidget extends StatefulWidget {
  const AboutScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _AboutScreenBodyState createState() => _AboutScreenBodyState();
}

class _AboutScreenBodyState extends State<AboutScreenBodyWidget>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late AnimationController _animationController;
  final _images = [
    'assets/ic_location.png',
    'assets/ic_email.png',
    'assets/ic_vk.png',
    'assets/ic_telegram.png'
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 0));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final _aboutViewModel = Provider.of<AboutViewModel>(context, listen: true);

    return Scaffold(
        backgroundColor: HexColors.background,
        body: Stack(children: [
          Column(children: [
            /// APP BAR
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top +
                      (DeviceDetector().isLarge() ? 0.0 : 12.0)),
              height: 52.0,
              color: HexColors.background,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/ic_tooth.png', width: 18.0, height: 22.0),
                  const SizedBox(width: 10.0),
                  Image.asset('assets/ic_stom_club.png',
                      width: 88.0, height: 18.0)
                ],
              ),
            ),

            /// LIST VIEW
            Expanded(
                child: ListView(
                    padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        bottom: Sizes.tabControllerHeight),
                    children: [
                  /// TITLE
                  _aboutViewModel.company == null
                      ? Container()
                      : Text(Titles.about,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 32.0,
                            color: HexColors.white,
                          )),
                  const SizedBox(height: 24.0),

                  /// TEXT
                  _aboutViewModel.company == null
                      ? Container()
                      : Text(_aboutViewModel.company?.description ?? '',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                            height: 1.5,
                            color: HexColors.white,
                          )),
                  const SizedBox(height: 16.0),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      /// PHOTO
                      _aboutViewModel.company == null
                          ? Container()
                          : Center(
                              child: ClipRRect(
                              borderRadius: BorderRadius.circular(70.0),
                              child:
                                  _aboutViewModel.company?.manager.photo == null
                                      ? Container()
                                      : CachedNetworkImage(
                                          width: 140.0,
                                          height: 140.0,
                                          imageUrl: _aboutViewModel
                                                  .company?.manager.photo ??
                                              '',
                                          fit: BoxFit.cover),
                            )),
                      const SizedBox(height: 24.0),

                      /// SUBTITLE
                      _aboutViewModel.company == null
                          ? Container()
                          : Text(
                              '${Titles.founder}  /  ${_aboutViewModel.company?.manager.profession.name}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                                color: HexColors.unselected,
                              )),
                      const SizedBox(height: 12.0),

                      /// TITLE
                      _aboutViewModel.company == null
                          ? Container()
                          : Text(
                              '${_aboutViewModel.company?.manager.lastName} ${_aboutViewModel.company?.manager.firstName} ${_aboutViewModel.company?.manager.middleName}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 28.0,
                                color: HexColors.white,
                              )),
                      const SizedBox(height: 24.0),

                      /// CONTACTS
                      _aboutViewModel.company == null
                          ? Container()
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return ListItemWidget(
                                    image: _images[index],
                                    title: index == 0
                                        ? _aboutViewModel.company?.manager.city ??
                                            ''
                                        : index == 1
                                            ? _aboutViewModel.company?.manager.email ??
                                                ''
                                            : index == 2
                                                ? _aboutViewModel.company
                                                        ?.manager.vkUrl ??
                                                    ''
                                                : _aboutViewModel.company
                                                        ?.manager.telegramUrl ??
                                                    '',
                                    fontSize: 16.0,
                                    padding: 12.0,
                                    buttonImagePath: 'assets/ic_copy.png',
                                    onTap: index == 0
                                        ? null
                                        : () => index == 1
                                            ? _aboutViewModel.sendMailToOwner(
                                                _aboutViewModel.company?.manager
                                                        .email ??
                                                    '')
                                            : index == 2
                                                ? _aboutViewModel.showVk(
                                                    context,
                                                    _aboutViewModel.company
                                                            ?.manager.vkUrl ??
                                                        '')
                                                : _aboutViewModel.showTelegram(
                                                    context,
                                                    _aboutViewModel
                                                            .company
                                                            ?.manager
                                                            .telegramUrl ??
                                                        ''),
                                    onButtonTap: index == 0
                                        ? null
                                        : () => {
                                              _aboutViewModel.copyAddress(
                                                  context,
                                                  index == 1
                                                      ? _aboutViewModel.company
                                                              ?.manager.email ??
                                                          ''
                                                      : index == 2
                                                          ? _aboutViewModel
                                                                  .company
                                                                  ?.manager
                                                                  .vkUrl ??
                                                              ''
                                                          : _aboutViewModel
                                                                  .company
                                                                  ?.manager
                                                                  .telegramUrl ??
                                                              ''),
                                              if (_animationController.value ==
                                                  0.0)
                                                {
                                                  _animationController
                                                      .forward(from: 0.0)
                                                      .then((value) => Future.delayed(
                                                          const Duration(
                                                              seconds: 3),
                                                          () =>
                                                              _animationController
                                                                  .reverse(
                                                                      from:
                                                                          1.0)))
                                                }
                                            });
                              })
                    ],
                  )
                ]))
          ]),

          /// INDICATOR
          _aboutViewModel.loadingStatus == LoadingStatus.searching
              ? Container(
                  margin: const EdgeInsets.only(bottom: 32.0),
                  child: const Center(child: LoadIndicatorWidget()))
              : Container(),

          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top == 0.0
                      ? 12.0
                      : MediaQuery.of(context).padding.top,
                  left: 20.0,
                  right: 20.0),
              child:

                  /// TOAST
                  ToastWidget(
                      animationController: _animationController,
                      text: Titles.copied))
        ]));
  }
}
