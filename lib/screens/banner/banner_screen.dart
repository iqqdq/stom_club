import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/entities/advertising.dart';
import 'package:stom_club/models/banner_view_model.dart';
import 'package:stom_club/screens/banner/banner_screen_body.dart';

class BannerScreenWidget extends StatelessWidget {
  final Advertising banner;

  const BannerScreenWidget({Key? key, required this.banner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => BannerViewModel(banner.product),
        child: BannerScreenBodyWidget(banner: banner));
  }
}
