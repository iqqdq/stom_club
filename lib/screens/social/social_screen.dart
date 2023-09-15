import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/models/registration_view_model.dart';
import 'package:stom_club/screens/social/social_screen_body.dart';

class SocialScreenWidget extends StatelessWidget {
  final Function(int) onUpdate;

  const SocialScreenWidget({Key? key, required this.onUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => RegistrationViewModel(),
        child: SocialScreenBodyWidget(onUpdate: onUpdate));
  }
}
