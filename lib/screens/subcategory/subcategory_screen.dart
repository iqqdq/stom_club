import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/entities/subcategory.dart';
import 'package:stom_club/models/subcategory_view_model.dart';
import 'package:stom_club/screens/subcategory/subcategory_screen_body.dart';

class SubcategoryScreenWidget extends StatelessWidget {
  final Subcategory subcategory;

  const SubcategoryScreenWidget({Key? key, required this.subcategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SubcategoryViewModel(),
        child: SubcategoryScreenBodyWidget(subcategory: subcategory));
  }
}
