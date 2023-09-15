import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/models/authorization_view_model.dart';
import 'package:stom_club/screens/phone/phone_screen_body.dart';

class PhoneScreenWidget extends StatelessWidget {
  final Function(int) onUpdate;

  const PhoneScreenWidget({Key? key, required this.onUpdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AuthorizationViewModel(),
        child: PhoneScreenBodyWidget(onUpdate: onUpdate));
  }
}
