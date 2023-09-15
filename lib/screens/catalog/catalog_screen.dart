import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/models/catalog_view_model.dart';
import 'package:stom_club/screens/catalog/catalog_screen_body.dart';

class CatalogScreenWidget extends StatelessWidget {
  const CatalogScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CatalogViewModel(),
        child: const CatalogScreenBodyWidget());
  }
}
