import 'package:flutter/material.dart';
import 'package:stom_club/entities/subcategory.dart';
import 'package:stom_club/screens/category_filter/category_filter_screen_body.dart';

class CategoryFilterScreenWidget extends StatelessWidget {
  final List<Subcategory> subcategories;
  final Function(List<Subcategory>) didReturnValue;

  const CategoryFilterScreenWidget(
      {Key? key, required this.subcategories, required this.didReturnValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CategoryFilterScreenBodyWidget(
        subcategories: subcategories, didReturnValue: didReturnValue);
  }
}
