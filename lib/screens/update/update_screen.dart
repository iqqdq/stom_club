import 'package:flutter/material.dart';
import 'package:stom_club/screens/update/update_screen_body.dart';

class UpdateScreenWidget extends StatelessWidget {
  final bool isVk;
  final String url;
  final Function(String) onUpdate;

  const UpdateScreenWidget(
      {Key? key, required this.isVk, required this.url, required this.onUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UpdateScreenBodyWidget(isVk: isVk, url: url, onUpdate: onUpdate);
  }
}
