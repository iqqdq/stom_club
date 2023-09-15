import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/entities/product.dart';
import 'package:stom_club/models/product_view_model.dart';
import 'package:stom_club/screens/product/product_screen_body.dart';

class ProductScreenWidget extends StatelessWidget {
  final Product product;

  const ProductScreenWidget({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ProductViewModel(context, product),
        child: ProductScreenBodyWidget(product: product));
  }
}
