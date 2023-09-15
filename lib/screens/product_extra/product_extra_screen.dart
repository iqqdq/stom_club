import 'package:flutter/material.dart';
import 'package:stom_club/entities/product.dart';
import 'package:stom_club/screens/product_extra/product_extra_screen_body.dart';

class ProductExtraScreenWidget extends StatelessWidget {
  final Product product;

  const ProductExtraScreenWidget({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProductExtraScreenBodyWidget(product: product);
  }
}
