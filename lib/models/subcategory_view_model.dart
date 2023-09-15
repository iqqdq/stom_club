import 'package:flutter/material.dart';
import 'package:stom_club/entities/subcategory.dart';
import 'package:stom_club/screens/products/products_screen.dart';

class SubcategoryViewModel with ChangeNotifier {
  // MARK: -
  // MARK: - ACTIONS

  void showProductsScreen(BuildContext context, Subcategory subcategory) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ProductsScreenWidget(subcategories: [subcategory])));
  }
}
