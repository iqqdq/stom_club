import 'package:flutter/material.dart';
import 'package:stom_club/components/back_button_widget.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/sizes.dart';
import 'package:stom_club/entities/product.dart';
import 'package:stom_club/screens/product_extra/product_extra_screen_body.dart';
import 'package:stom_club/screens/product_main/components/product_bottom_bar.dart';
import 'package:stom_club/screens/product_main/product_main_screen.dart';

class ProductScreenBodyWidget extends StatefulWidget {
  final Product product;

  const ProductScreenBodyWidget({Key? key, required this.product})
      : super(key: key);

  @override
  _ProductScreenBodyState createState() => _ProductScreenBodyState();
}

class _ProductScreenBodyState extends State<ProductScreenBodyWidget> {
  final _pageController = PageController(initialPage: 0);
  int _index = 0;
  Product? _product;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // MARK: -
  // MARK: - ACTIONS

  void nextPage(int index) {
    setState(() {
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: HexColors.white,
        appBar: AppBar(
          toolbarHeight: Sizes.appBarHeight,
          backgroundColor: HexColors.white,
          centerTitle: false,
          elevation: 0.0,
          leading: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: BackButtonWidget(
                  color: HexColors.white, onTap: () => Navigator.pop(context))),
          title: Text(_product == null ? widget.product.name : _product!.name,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 20.0,
                color: HexColors.black,
              )),
        ),
        body: Stack(children: [
          SizedBox.expand(
              child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _index = index);
                  },
                  children: [
                ProductMainScreenWidget(
                    product: widget.product,
                    didReturnValue: (product) => {
                          Future.delayed(const Duration(milliseconds: 150),
                              () => setState(() => _product = product))
                        }),
                ProductExtraScreenBodyWidget(product: widget.product)
              ])),

          /// BOTTOM BAR
          Align(
              alignment: Alignment.bottomCenter,
              child: ProductBottomBarWidget(
                  index: _index, didReturnIndex: (index) => nextPage(index)))
        ]));
  }
}
