import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/models/articles_view_model.dart';
import 'package:stom_club/screens/articles/articles_screen_body.dart';

class ArticlesScreenWidget extends StatelessWidget {
  const ArticlesScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ArticlesViewModel(),
        child: const ArticlesScreenBodyWidget());
  }
}
