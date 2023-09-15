import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/models/verification_view_model.dart';
import 'package:stom_club/screens/verification/verification_screen_body.dart';

class VerificationScreenWidget extends StatelessWidget {
  final Function(int) onUpdate;

  const VerificationScreenWidget({Key? key, required this.onUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => VerificationViewModel(),
        child: VerificationScreenBodyWidget(onUpdate: onUpdate));
  }
}
