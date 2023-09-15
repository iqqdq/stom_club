import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/ulrs.dart';
import 'package:stom_club/screens/comments/components/remove_button.dart';
import 'package:stom_club/screens/reviews/components/document_button.dart';

class CommentListItem extends StatelessWidget {
  final bool isMineComment;
  final String name;
  final String text;
  final String url;
  final DateTime dateTime;
  final String? attachment;
  final VoidCallback? onDocumentTap;
  final VoidCallback onUserTap;
  final VoidCallback onRemoveTap;

  const CommentListItem(
      {Key? key,
      required this.isMineComment,
      required this.name,
      required this.url,
      required this.text,
      required this.dateTime,
      this.attachment,
      this.onDocumentTap,
      required this.onUserTap,
      required this.onRemoveTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _hour = dateTime.hour.toString().length == 1
        ? '0${dateTime.hour}'
        : dateTime.hour;

    final _minute = dateTime.minute.toString().length == 1
        ? '0${dateTime.minute}'
        : dateTime.minute;

    String _fileName = attachment == null
        ? ''
        : attachment!.length >= 14
            ? '...${attachment!.substring(attachment!.length - 12, attachment!.length)}'
                .toLowerCase()
            : attachment!;

    return Container(
        margin: EdgeInsets.only(
            bottom: 16.0,
            left: isMineComment ? 60.0 : 20.0,
            right: isMineComment ? 20.0 : 60.0),
        padding: const EdgeInsets.symmetric(vertical: 11.0, horizontal: 16.0),
        decoration: BoxDecoration(
            color: HexColors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                  color: HexColors.black.withOpacity(0.05),
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 4.0))
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
                child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Row(children: [
                      /// PHOTO

                      Stack(children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10.0),
                          width: 28.0,
                          height: 28.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14.0),
                              color: HexColors.separator),
                        ),
                        url.isEmpty
                            ? Container()
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: CachedNetworkImage(
                                    imageUrl: url.startsWith('https')
                                        ? url
                                        : URLs.media_url + url,
                                    width: 24.0,
                                    height: 24.0,
                                    fit: BoxFit.cover))
                      ]),

                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// NAME
                          Text(name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                                color: HexColors.black,
                              )),
                          const SizedBox(height: 4.0),
                        ],
                      ))
                    ]),
                    onTap: () => onUserTap())),
            const SizedBox(width: 10.0),

            /// DATE
            Text(
                '$_hour:$_minute / ${dateTime.day}.${dateTime.month}.${dateTime.year}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                  color: HexColors.subtitle,
                )),
          ]),
          const SizedBox(height: 10.0),
          InkWell(
              child: _fileName.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child:

                          /// TEXT
                          Text(text,
                              style: TextStyle(
                                  decoration: _fileName.isEmpty
                                      ? TextDecoration.none
                                      : TextDecoration.underline,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color: HexColors.black.withOpacity(0.8))))
                  :

                  /// DOCUMENT
                  DocumentButtonWidget(
                      name: _fileName.toUpperCase(),
                      attachment: attachment,
                      onTap: () =>
                          onDocumentTap == null ? null : onDocumentTap!())),
          isMineComment
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [RemoveButtonWidget(onTap: () => onRemoveTap())])
              : Container()
        ]));
  }
}
