import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/components/decouncer.dart';
import 'package:stom_club/components/device_detector.dart';
import 'package:stom_club/components/filter_button.dart';
import 'package:stom_club/components/filter_list_item.dart';
import 'package:stom_club/components/input_widget.dart';
import 'package:stom_club/components/back_button_widget.dart';
import 'package:stom_club/components/load_indicator_widget.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/models/products_view_model.dart';
import 'package:stom_club/screens/products/components/product_list_item.dart';
import 'package:stom_club/services/loading_status.dart';
import 'package:stom_club/services/pagination.dart';

class SearchScreenBodyWidget extends StatefulWidget {
  const SearchScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _SearchScreenBodyState createState() => _SearchScreenBodyState();
}

class _SearchScreenBodyState extends State<SearchScreenBodyWidget> {
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
        body: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top +
                    (DeviceDetector().isLarge() ? 0.0 : 12.0)),
            child: Stack(children: [
              Column(children: [
                /// APP BAR
                Row(
                  children: [
                    const SizedBox(width: 12.0),

                    /// BACK BUTTON
                    BackButtonWidget(
                        color: HexColors.white,
                        onTap: () => Navigator.pop(context)),

                    /// SEARCH INPUT
                    Expanded(
                        child: InputWidget(
                            margin:
                                const EdgeInsets.only(left: 4.0, right: 12.0),
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
                              _productsViewModel.showManufacturerFilterScreen(
                                  context,
                                  _pagination,
                                  _textEditingController.text)
                            }),
                  ],
                ),

                /// HORIZONTAL LIST
                Container(
                    margin: EdgeInsets.only(
                        top: _productsViewModel.manufacturers.isEmpty
                            ? 0.0
                            : 18.0,
                        bottom: _productsViewModel.manufacturers.isEmpty
                            ? 0.0
                            : 4.0,
                        left: 20.0),
                    height:
                        _productsViewModel.manufacturers.isEmpty ? 0.0 : 38.0,
                    child: ListView.builder(
                        padding: const EdgeInsets.only(right: 10.0),
                        scrollDirection: Axis.horizontal,
                        itemCount: _productsViewModel.manufacturers.length,
                        itemBuilder: (context, index) {
                          return FilterListItemWidget(
                              title:
                                  _productsViewModel.manufacturers[index].name,
                              onTap: () => {},
                              onRemoveTap: () => {
                                    _pagination.number = 1,
                                    _productsViewModel.removeManufacturer(
                                        _pagination,
                                        _productsViewModel
                                            .manufacturers[index].id,
                                        _textEditingController.text)
                                  });
                        })),
                const SizedBox(height: 16.0),

                /// PRODUCTS
                Expanded(
                    child: RefreshIndicator(
                        onRefresh: _onRefresh,
                        color: HexColors.selected,
                        backgroundColor: HexColors.background,
                        child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            itemCount: _productsViewModel.products.length,
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).padding.bottom ==
                                        0.0
                                    ? 12.0
                                    : MediaQuery.of(context).padding.bottom),
                            itemBuilder: (context, index) {
                              return ProductListItem(
                                  title:
                                      _productsViewModel.products[index].name,
                                  imageUrl: _productsViewModel
                                          .products[index].images.isEmpty
                                      ? null
                                      : _productsViewModel
                                          .products[index].images.first.image,
                                  rating:
                                      _productsViewModel.products[index].rating,
                                  reviewsCount: _productsViewModel
                                      .products[index].reviewsCount,
                                  onTap: () =>
                                      _productsViewModel.showProductScreen(
                                          context,
                                          _productsViewModel.products[index]));
                            })))
              ]),

              /// NO DATA LABEL
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
                      _productsViewModel.loadingStatus ==
                          LoadingStatus.searching
                  ? const Center(child: SizedBox(child: LoadIndicatorWidget()))
                  : Container()
            ])));
  }
}
