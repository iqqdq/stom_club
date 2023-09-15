import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/components/back_button_widget.dart';
import 'package:stom_club/components/load_indicator_widget.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/sizes.dart';
import 'package:stom_club/entities/article.dart';
import 'package:stom_club/models/article_view_model.dart';
import 'package:stom_club/services/loading_status.dart';

class ArticleScreenBodyWidget extends StatefulWidget {
  final Article article;

  const ArticleScreenBodyWidget({Key? key, required this.article})
      : super(key: key);

  @override
  _ArticleScreenBodyState createState() => _ArticleScreenBodyState();
}

class _ArticleScreenBodyState extends State<ArticleScreenBodyWidget> {
  @override
  Widget build(BuildContext context) {
    final _articleViewModel =
        Provider.of<ArticleViewModel>(context, listen: true);

    return Scaffold(
      backgroundColor: HexColors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: HexColors.white,
        centerTitle: true,
        elevation: 0.0,
        leading: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: BackButtonWidget(
                color: HexColors.white, onTap: () => Navigator.pop(context))),
        title: Text(widget.article.title,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 20.0,
              color: HexColors.black,
            )),
      ),
      body: SizedBox.expand(
          child: Stack(children: [
        SingleChildScrollView(
            padding: EdgeInsets.only(
                top: 6.0,
                bottom: MediaQuery.of(context).padding.bottom == 0.0
                    ? 12.0
                    : MediaQuery.of(context).padding.bottom),
            child: _articleViewModel.article?.text != null
                ? InteractiveViewer(
                    panEnabled: true,
                    boundaryMargin: EdgeInsets.zero,
                    minScale: 1.0,
                    maxScale: 5.0,
                    child: Html(data: _articleViewModel.article?.text, style: {
                      "body": Style(
                        color: HexColors.black,
                      )
                    }))
                : Container()),

        /// INDICATOR
        _articleViewModel.loadingStatus == LoadingStatus.searching
            ? Container(
                margin: EdgeInsets.only(bottom: Sizes.appBarHeight),
                child: const Center(
                    child: LoadIndicatorWidget(indicatorOnly: true)))
            : Container(),
      ])),
    );
  }
}
