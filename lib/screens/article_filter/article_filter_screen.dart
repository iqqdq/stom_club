import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/entities/subcategory.dart';
import 'package:stom_club/models/article_filter_view_model.dart';
import 'package:stom_club/screens/article_filter/article_filter_screen_body.dart';

class ArticleFilterScreenWidget extends StatelessWidget {
  final List<Subcategory> selectedSubcategories;
  final Function(List<Subcategory>) didReturnValue;

  const ArticleFilterScreenWidget(
      {Key? key,
      required this.didReturnValue,
      required this.selectedSubcategories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ArticleFilterViewModel(selectedSubcategories),
        child: ArticleFilterScreenBodyWidget(
            selectedSubcategories: selectedSubcategories,
            didReturnValue: didReturnValue));
  }
}
