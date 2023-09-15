import 'package:flutter/material.dart';
import 'package:stom_club/entities/product.dart';
import 'package:stom_club/screens/product_main/product_main_screen_body.dart';

class ProductMainScreenWidget extends StatelessWidget {
  final Product product;
  final Function(Product)? didReturnValue;

  const ProductMainScreenWidget(
      {Key? key, required this.product, this.didReturnValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProductMainScreenBodyWidget(
        product: product, didReturnValue: didReturnValue);
  }
}
