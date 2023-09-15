import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/entities/profession.dart';
import 'package:stom_club/models/profession_view_model.dart';
import 'package:stom_club/screens/professions/professions_screen_body.dart';

class ProfessionsScreenWidget extends StatelessWidget {
  final Function(Profession) didReturnValue;

  const ProfessionsScreenWidget({Key? key, required this.didReturnValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ProfessionsViewModel(),
        child: ProfessionsScreenBodyWidget(didReturnValue: didReturnValue));
  }
}
