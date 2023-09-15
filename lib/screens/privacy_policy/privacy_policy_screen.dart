import 'package:flutter/material.dart';
import 'package:stom_club/screens/privacy_policy/privacy_policy_screen_body.dart';

class PrivacyPolicyScreenWidget extends StatelessWidget {
  final Function(int) onUpdate;

  const PrivacyPolicyScreenWidget({Key? key, required this.onUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrivacyPolicyScreenBodyWidget(onUpdate: onUpdate);
  }
}
