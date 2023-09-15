import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/ulrs.dart';
import 'package:image_preview/image_preview.dart';

class DocumentButtonWidget extends StatefulWidget {
  final String name;
  final String? attachment;
  final VoidCallback onTap;

  const DocumentButtonWidget(
      {Key? key, required this.name, this.attachment, required this.onTap})
      : super(key: key);

  @override
  _DocumentButtonState createState() => _DocumentButtonState();
}

class _DocumentButtonState extends State<DocumentButtonWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final _isImage = widget.attachment == null
        ? false
        : widget.attachment!.endsWith('.jpg') ||
            widget.attachment!.endsWith('.jpeg') ||
            widget.attachment!.endsWith('.png');

    final _widget = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(width: 1.0, color: HexColors.separator),
          color: _isImage ? HexColors.separator : Colors.transparent,
        ),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () => _isImage ? null : widget.onTap(),
                borderRadius: BorderRadius.circular(12.0),
                child: _isImage
                    ?

                    /// IMAGE
                    InkWell(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: CachedNetworkImage(
                                imageUrl: widget.attachment!.contains('https')
                                    ? widget.attachment!
                                    : URLs.media_url + widget.attachment!,
                                cacheKey: widget.attachment!.contains('https')
                                    ? widget.attachment!
                                    : URLs.media_url + widget.attachment!,
                                fit: BoxFit.cover)),
                        onTap: () =>
                            openImagesPage(Navigator.of(context), imgUrls: [
                              widget.attachment!.contains('https')
                                  ? widget.attachment!
                                  : URLs.media_url + widget.attachment!
                            ]))
                    :
                    // FILE
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(children: [
                          Image.asset('assets/ic_file.png',
                              height: 20.0, color: HexColors.black),
                          const SizedBox(width: 9.0),
                          Text(widget.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                                overflow: TextOverflow.ellipsis,
                                color: HexColors.black,
                              ))
                        ])))));

    return _isImage
        ? Container(
            margin: EdgeInsets.only(bottom: _isImage ? 8.0 : 0.0),
            width: double.infinity,
            height: 102.0,
            child: _widget)
        : FittedBox(child: SizedBox(height: 32.0, child: _widget));
  }
}
