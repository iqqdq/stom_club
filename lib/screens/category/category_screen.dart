import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/entities/subcategory.dart';
import 'package:stom_club/models/category_view_model.dart';
import 'package:stom_club/screens/category/category_screen_body.dart';

class CategoryScreenWidget extends StatelessWidget {
  final Subcategory subcategory;

  const CategoryScreenWidget({Key? key, required this.subcategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CategoryViewModel(),
        child: CategoryScreenBodyWidget(subcategory: subcategory));
  }
}
