import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/components/decouncer.dart';
import 'package:stom_club/components/filter_button.dart';
import 'package:stom_club/components/input_widget.dart';
import 'package:stom_club/components/back_button_widget.dart';
import 'package:stom_club/components/load_indicator_widget.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/sizes.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/entities/subcategory.dart';
import 'package:stom_club/models/products_view_model.dart';
import 'package:stom_club/components/filter_list_item.dart';
import 'package:stom_club/screens/products/components/product_list_item.dart';
import 'package:stom_club/services/loading_status.dart';
import 'package:stom_club/services/pagination.dart';

class ProductsScreenBodyWidget extends StatefulWidget {
  final bool isNew;
  final List<Subcategory> subcategories;

  const ProductsScreenBodyWidget(
      {Key? key, required this.isNew, required this.subcategories})
      : super(key: key);

  @override
  _ProductsScreenBodyState createState() => _ProductsScreenBodyState();
}

class _ProductsScreenBodyState extends State<ProductsScreenBodyWidget> {
  final ScrollController _scrollController =
      ScrollController(keepScrollOffset: true);
  final Pagination _pagination = Pagination(number: 1, size: 50);
  bool _isRefresh = false;

  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();

  final _debouncer = Debouncer(milliseconds: 500);
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.number++;
        setState(() => _isRefresh = !_isRefresh);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future<void> _onRefresh() async {
    _pagination.number = 1;
    setState(() => _isRefresh = !_isRefresh);
  }

  @override
  Widget build(BuildContext context) {
    final _productsViewModel =
        Provider.of<ProductsViewModel>(context, listen: true);

    if (_isRefresh) {
      _productsViewModel
          .getProductList(_isRefresh, _pagination, _textEditingController.text)
          .then((value) => _isRefresh = !_isRefresh);
    }

    return Scaffold(
        backgroundColor: HexColors.background,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: Sizes.appBarHeight,
          backgroundColor: HexColors.background,
          centerTitle: true,
          elevation: 0.0,
          leading: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: BackButtonWidget(
                  color: HexColors.white, onTap: () => Navigator.pop(context))),
          title: Text(
              widget.subcategories.length > 1
                  ? Titles.newest
                  : widget.subcategories.first.name,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 20.0,
                color: HexColors.white,
              )),
        ),
        body: Stack(children: [
          Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// SEARCH INPUT
                Expanded(
                    child: InputWidget(
                        keyboardAppearance: Brightness.dark,
                        margin: const EdgeInsets.only(left: 20.0, right: 12.0),
                        textEditingController: _textEditingController,
                        focusNode: _focusNode,
                        placeholder: Titles.search,
                        onChanged: (text) {
                          setState(() => _isSearching = true);

                          _debouncer.run(() {
                            _pagination.number = 1;
                            _productsViewModel
                                .getProductList(true, _pagination,
                                    _textEditingController.text)
                                .then((value) =>
                                    setState(() => _isSearching = false));
                          });
                        })),

                /// FILTER BUTTON
                FilterButtonWidget(
                    title: Titles.filter,
                    onTap: () => {
                          _pagination.number = 1,
                          widget.isNew
                              ? _productsViewModel.showCategoryFilterScreen(
                                  context,
                                  _pagination,
                                  _textEditingController.text)
                              : _productsViewModel.showManufacturerFilterScreen(
                                  context,
                                  _pagination,
                                  _textEditingController.text)
                        }),
              ],
            ),

            SizedBox(
                height: widget.isNew
                    ? _productsViewModel.selectedSubcategories.isEmpty
                        ? 0.0
                        : 16.0
                    : _productsViewModel.manufacturers.isEmpty
                        ? 0.0
                        : 16.0),

            /// HORIZONTAL LIST
            Container(
                margin: const EdgeInsets.only(left: 20.0),
                height: widget.isNew
                    ? _productsViewModel.selectedSubcategories.isEmpty
                        ? 0.0
                        : 38.0
                    : _productsViewModel.manufacturers.isEmpty
                        ? 0.0
                        : 38.0,
                child: ListView.builder(
                    padding: const EdgeInsets.only(right: 10.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.isNew
                        ? _productsViewModel.selectedSubcategories.length
                        : _productsViewModel.manufacturers.length,
                    itemBuilder: (context, index) {
                      return FilterListItemWidget(
                          title: widget.isNew
                              ? _productsViewModel
                                  .selectedSubcategories[index].name
                              : _productsViewModel.manufacturers[index].name,
                          onTap: () => {},
                          onRemoveTap: () => {
                                _pagination.number = 1,
                                widget.isNew
                                    ? _productsViewModel.removeCategory(
                                        _pagination,
                                        _productsViewModel
                                            .selectedSubcategories[index].id,
                                        _textEditingController.text)
                                    : _productsViewModel.removeManufacturer(
                                        _pagination,
                                        _productsViewModel
                                            .manufacturers[index].id,
                                        _textEditingController.text)
                              });
                    })),
            const SizedBox(height: 12.0),

            /// PRODUCTS
            Expanded(
                child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: HexColors.selected,
                    backgroundColor: HexColors.background,
                    child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        padding: EdgeInsets.only(
                            top: 12.0,
                            bottom: MediaQuery.of(context).padding.bottom == 0.0
                                ? 12.0
                                : MediaQuery.of(context).padding.bottom),
                        itemCount: _productsViewModel.products.length,
                        itemBuilder: (context, index) {
                          return ProductListItem(
                              title: _productsViewModel.products[index].name,
                              imageUrl: _productsViewModel
                                      .products[index].images.isEmpty
                                  ? ''
                                  : _productsViewModel
                                      .products[index].images.first.image,
                              rating: _productsViewModel.products[index].rating,
                              reviewsCount: _productsViewModel
                                  .products[index].reviewsCount,
                              onTap: () => _productsViewModel.showProductScreen(
                                  context, _productsViewModel.products[index]));
                        })))
          ]),

          /// EMPTY LIST TEXT
          _productsViewModel.loadingStatus == LoadingStatus.completed &&
                  _productsViewModel.products.isEmpty &&
                  !_isSearching
              ? Center(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(Titles.no_results,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              color: HexColors.unselected))))
              : Container(),

          /// INDICATOR
          _isSearching ||
                  _productsViewModel.loadingStatus == LoadingStatus.searching
              ? Container(
                  margin: EdgeInsets.only(top: Sizes.appBarHeight + 24.0),
                  child: const LoadIndicatorWidget())
              : Container()
        ]));
  }
}
