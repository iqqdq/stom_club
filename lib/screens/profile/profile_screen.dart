import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/models/profile_view_model.dart';
import 'package:stom_club/screens/profile/profile_body_screen.dart';

class ProfileScreenWidget extends StatelessWidget {
  final int userId;

  const ProfileScreenWidget({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ProfileViewModel(userId),
        child: ProfileScreenBodyWidget(userId: userId));
  }
}
