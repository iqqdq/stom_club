import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/models/about_view_model.dart';
import 'package:stom_club/screens/about/about_screen_body.dart';

class AboutScreenWidget extends StatelessWidget {
  const AboutScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AboutViewModel(),
        child: const AboutScreenBodyWidget());
  }
}
