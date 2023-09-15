import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/models/registration_view_model.dart';
import 'package:stom_club/screens/registration/registration_screen_body.dart';

class RegistrationScreenWidget extends StatelessWidget {
  final Function(int) onUpdate;

  const RegistrationScreenWidget({Key? key, required this.onUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => RegistrationViewModel(),
        child: RegistrationScreenBodyWidget(onUpdate: onUpdate));
  }
}
