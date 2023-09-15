import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/components/list_item.dart';
import 'package:stom_club/components/back_button_widget.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/sizes.dart';
import 'package:stom_club/entities/subcategory.dart';
import 'package:stom_club/models/category_view_model.dart';

class CategoryScreenBodyWidget extends StatefulWidget {
  final Subcategory subcategory;

  const CategoryScreenBodyWidget({Key? key, required this.subcategory})
      : super(key: key);

  @override
  _CategoryScreenBodyState createState() => _CategoryScreenBodyState();
}

class _CategoryScreenBodyState extends State<CategoryScreenBodyWidget> {
  @override
  Widget build(BuildContext context) {
    final _categoryViewModel =
        Provider.of<CategoryViewModel>(context, listen: true);

    return Scaffold(
        backgroundColor: HexColors.background,
        appBar: AppBar(
          toolbarHeight: Sizes.appBarHeight,
          backgroundColor: HexColors.background,
          centerTitle: false,
          elevation: 0.0,
          leading: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: BackButtonWidget(
                  color: HexColors.white, onTap: () => Navigator.pop(context))),
          title: Text(widget.subcategory.name,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 20.0,
                color: HexColors.white,
              )),
        ),
        body: SizedBox.expand(
            child: ListView.builder(
                padding: const EdgeInsets.only(
                    top: 16.0, left: 20.0, bottom: 12.0, right: 20.0),
                itemCount: widget.subcategory.subcategories.length,
                itemBuilder: (context, index) {
                  return ListItemWidget(
                      height: 84.0,
                      title: widget.subcategory.subcategories[index].name,
                      url: widget.subcategory.subcategories[index].image,
                      onTap: () => _categoryViewModel.showSubcategoryScreen(
                          context, widget.subcategory.subcategories[index]));
                })));
  }
}
