// ignore_for_file: avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stom_club/components/default_button.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/entities/product.dart';
import 'package:stom_club/entities/review.dart';
import 'package:stom_club/screens/review/components/file_attachment_widget.dart';
import 'package:stom_club/screens/review/components/raiting_view_widget.dart';
import 'package:stom_club/screens/review/components/step_indicator_widget.dart';
import 'package:stom_club/screens/review/components/text_container_view_widget.dart';

class ReviewScreenBodyWidget extends StatefulWidget {
  final Product product;
  final double rating;
  final Function(String advantages, String defects, double rating,
      String? filePath, String? fileName) onPop;
  final Review? review;

  const ReviewScreenBodyWidget(
      {Key? key,
      required this.product,
      required this.rating,
      required this.onPop,
      this.review})
      : super(key: key);

  @override
  _ReviewScreenBodyState createState() => _ReviewScreenBodyState();
}

class _ReviewScreenBodyState extends State<ReviewScreenBodyWidget> {
  final _pageController = PageController(initialPage: 0);
  final _plusTextEditingController = TextEditingController();
  final _plusFocusNode = FocusNode();
  final _minusTextEditingController = TextEditingController();
  final _minusFocusNode = FocusNode();
  double _rating = 0.0;
  int _index = 0;
  String? _filePath;
  String? _fileName;

  @override
  void initState() {
    _rating = widget.rating;

    super.initState();

    _plusTextEditingController.text = widget.review?.advantages ?? '';
    _plusTextEditingController.addListener(() {
      print(_plusTextEditingController.text);
    });

    _minusTextEditingController.text = widget.review?.defects ?? '';
    _minusTextEditingController.addListener(() {
      print(_minusTextEditingController.text);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // MARK: -
  // MARK: - ACTIONS

  void showPage(int page) {
    if (_index < 4) {
      setState(() {
        _index = page;
      });

      _pageController.animateToPage(page,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    } else {
      widget.onPop(_plusTextEditingController.text,
          _minusTextEditingController.text, _rating, _filePath, _fileName);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Container(
              decoration: BoxDecoration(
                  color: HexColors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0))),
              child: Column(children: [
                const SizedBox(height: 15.0),
                Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  width: 56.0,
                  height: 6.0,
                  decoration: BoxDecoration(
                      color: HexColors.separator,
                      borderRadius: BorderRadius.circular(12.0)),
                ),

                /// PRODUCT
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        /// IMAGE
                        widget.product.images.isEmpty
                            ? Container(
                                width: 64.0,
                                height: 38.0,
                                decoration: BoxDecoration(
                                  color: HexColors.gray,
                                  borderRadius: BorderRadius.circular(6.0),
                                ))
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(6.0),
                                child: CachedNetworkImage(
                                    imageUrl: widget.product.images.first.image,
                                    width: 64.0,
                                    height: 38.0,
                                    fit: BoxFit.cover),
                              ),
                        const SizedBox(width: 16.0),

                        /// TITLE
                        Expanded(
                            child: Text(widget.product.name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20.0,
                                  color: HexColors.black,
                                )))
                      ],
                    )),

                /// STEP INDICATOR
                StepIndicatorWidget(index: _index),

                /// PAGE VIEW
                SizedBox(
                    height: 254.0,
                    child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() => _index = index);
                        },
                        children: [
                          TextContainerViewWidget(
                            textEditingController: _plusTextEditingController,
                            focusNode: _plusFocusNode,
                            placeholder: Titles.describe_plus,
                            onEditingComplete: () => {
                              // _minusFocusNode.requestFocus(),
                              // _pageController.animateToPage(1,
                              //     duration: const Duration(milliseconds: 300),
                              //     curve: Curves.fastOutSlowIn)
                            },
                          ),
                          TextContainerViewWidget(
                              textEditingController:
                                  _minusTextEditingController,
                              focusNode: _minusFocusNode,
                              placeholder: Titles.describe_minus,
                              onEditingComplete: () => {
                                    // FocusScope.of(context).unfocus(),
                                    // _pageController.animateToPage(2,
                                    //     duration:
                                    //         const Duration(milliseconds: 300),
                                    //     curve: Curves.fastOutSlowIn)
                                  }),
                          RaitingViewWidget(
                              rating: _rating,
                              didReturnValue: (rating) => _rating = rating),
                          FileAttachmentViewWidget(
                              attachment: widget.review?.attachment,
                              didReturnValue: (path, name) => setState(
                                  () => {_filePath = path, _fileName = name}))
                        ])),

                /// CONTINUE BUTTON

                DefaultButtonWidget(
                    isEnabled: true,
                    title: _index < 3
                        ? Titles.continuee
                        : _filePath == null
                            ? Titles.skip
                            : Titles.done,
                    titleColor: HexColors.white,
                    color: HexColors.selected,
                    margin: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        bottom: MediaQuery.of(context).padding.bottom == 0.0
                            ? 12.0
                            : MediaQuery.of(context).padding.bottom),
                    onTap: () => {
                          FocusScope.of(context).unfocus(),
                          _index += 1,
                          showPage(_index)
                        }),

                /// KEYBOARD APPEREANCE
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  color: HexColors.white,
                  height: _plusFocusNode.hasFocus || _minusFocusNode.hasFocus
                      ? 360.0
                      : 0.0,
                )
              ]))
        ]));
  }
}
