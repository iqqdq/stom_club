import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/components/list_item.dart';
import 'package:stom_club/components/back_button_widget.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/sizes.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/entities/subcategory.dart';
import 'package:stom_club/models/subcategory_view_model.dart';

class SubcategoryScreenBodyWidget extends StatefulWidget {
  final Subcategory subcategory;

  const SubcategoryScreenBodyWidget({Key? key, required this.subcategory})
      : super(key: key);

  @override
  _SubcategoryScreenBodyState createState() => _SubcategoryScreenBodyState();
}

class _SubcategoryScreenBodyState extends State<SubcategoryScreenBodyWidget> {
  @override
  Widget build(BuildContext context) {
    final _subcategoryViewModel =
        Provider.of<SubcategoryViewModel>(context, listen: true);

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
            child: Stack(children: [
          ListView.builder(
              padding: const EdgeInsets.only(
                  top: 16.0, left: 20.0, bottom: 12.0, right: 20.0),
              itemCount: widget.subcategory.subcategories.length,
              itemBuilder: (context, index) {
                return ListItemWidget(
                    title: widget.subcategory.subcategories[index].name,
                    onTap: () => _subcategoryViewModel.showProductsScreen(
                        context, widget.subcategory.subcategories[index]));
              }),

          /// EMPTY LIST TEXT
          widget.subcategory.subcategories.isEmpty
              ? Center(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(Titles.no_results,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              color: HexColors.unselected))))
              : Container()
        ])));
  }
}
