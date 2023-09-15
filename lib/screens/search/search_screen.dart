import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/models/products_view_model.dart';
import 'package:stom_club/screens/search/search_screen_body.dart';

class SearchScreenWidget extends StatelessWidget {
  const SearchScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ProductsViewModel(false, []),
        child: const SearchScreenBodyWidget());
  }
}
