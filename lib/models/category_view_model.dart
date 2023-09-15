import 'package:flutter/material.dart';
import 'package:stom_club/entities/subcategory.dart';
import 'package:stom_club/screens/subcategory/subcategory_screen.dart';

class CategoryViewModel with ChangeNotifier {
  // MARK: -
  // MARK: - ACTIONS

  void showSubcategoryScreen(BuildContext context, Subcategory subcategory) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SubcategoryScreenWidget(subcategory: subcategory)));
  }
}
