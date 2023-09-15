import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:stom_club/components/back_button_widget.dart';
import 'package:stom_club/components/load_indicator_widget.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreenWidget extends StatefulWidget {
  final String url;

  const WebViewScreenWidget({Key? key, required this.url}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreenWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
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
          title: Text(
              widget.url.length >= 12
                  ? '...${widget.url.substring(widget.url.length - 11, widget.url.length)}'
                      .toUpperCase()
                  : widget.url.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 20.0,
                color: HexColors.black,
              )),
        ),
        body: Stack(children: [
          WebView(
              initialUrl: widget.url,
              zoomEnabled: true,
              javascriptMode: JavascriptMode.unrestricted,
              onPageStarted: (start) => setState(() => _isLoading = true),
              onPageFinished: (finish) => setState(() => _isLoading = false),
              onWebResourceError: (error) => {
                    setState(() => _isLoading = false),
                    showOkAlertDialog(
                        context: context,
                        title: Titles.warning,
                        message: error.description)
                  }),
          _isLoading
              ? Container(
                  margin: const EdgeInsets.only(bottom: 32.0),
                  child: const Center(
                      child: LoadIndicatorWidget(indicatorOnly: true)))
              : Container()
        ]));
  }
}
