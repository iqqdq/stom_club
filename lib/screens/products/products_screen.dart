import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/entities/subcategory.dart';
import 'package:stom_club/models/products_view_model.dart';
import 'package:stom_club/screens/products/products_screen_body.dart';

class ProductsScreenWidget extends StatelessWidget {
  final bool? isNew;
  final List<Subcategory> subcategories;

  const ProductsScreenWidget(
      {Key? key, this.isNew, required this.subcategories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ProductsViewModel(isNew ?? false, subcategories),
        child: ProductsScreenBodyWidget(
            isNew: isNew ?? false, subcategories: subcategories));
  }
}
