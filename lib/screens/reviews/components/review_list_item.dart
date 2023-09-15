import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/constants/ulrs.dart';
import 'package:stom_club/screens/reviews/components/comment_button.dart';
import 'package:stom_club/screens/reviews/components/document_button.dart';

class ReviewListItem extends StatefulWidget {
  final bool? hideLikes;
  final DateTime dateTime;
  final String name;
  final String url;
  final double rating;
  final String? pluses;
  final String? minuses;
  final String? attachment;
  final bool isLiked;
  final bool isDisliked;
  final int likes;
  final int dislikes;
  final int comments;
  final VoidCallback? onAnswerTap;
  final VoidCallback? onDocumentTap;
  final VoidCallback onUserTap;
  final VoidCallback onLikeTap;
  final VoidCallback onDislikeTap;

  const ReviewListItem(
      {Key? key,
      this.hideLikes,
      required this.dateTime,
      required this.name,
      required this.url,
      required this.rating,
      required this.pluses,
      required this.minuses,
      this.attachment,
      required this.likes,
      required this.dislikes,
      required this.isLiked,
      required this.isDisliked,
      required this.comments,
      this.onAnswerTap,
      this.onDocumentTap,
      required this.onUserTap,
      required this.onLikeTap,
      required this.onDislikeTap})
      : super(key: key);

  @override
  _ReviewListItemState createState() => _ReviewListItemState();
}

class _ReviewListItemState extends State<ReviewListItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      color: HexColors.white,
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: InkWell(
                  onTap: () => widget.onUserTap(),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Row(children: [
                    /// PHOTO
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: HexColors.separator),
                      child: widget.url.isEmpty
                          ? Container()
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: CachedNetworkImage(
                                  imageUrl: widget.url.contains('https')
                                      ? widget.url
                                      : URLs.media_url + widget.url,
                                  cacheKey: widget.url.contains('https')
                                      ? widget.url
                                      : URLs.media_url + widget.url,
                                  width: 40.0,
                                  height: 40.0,
                                  fit: BoxFit.cover)),
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// NAME
                        Text(widget.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 18.0,
                              color: HexColors.black,
                            )),
                        const SizedBox(height: 4.0),

                        /// DATE
                        Text(
                            '${widget.dateTime.day}.${widget.dateTime.month}.${widget.dateTime.year}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0,
                              color: HexColors.subtitle,
                            )),
                      ],
                    ))
                  ]))),
          const SizedBox(width: 10.0),

          /// RATING
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: RatingBar(
                ignoreGestures: true,
                initialRating: widget.rating,
                direction: Axis.horizontal,
                itemSize: 16.0,
                itemCount: 5,
                ratingWidget: RatingWidget(
                  full: Image.asset('assets/ic_star.png'),
                  empty: Image.asset('assets/ic_empty_star.png'),
                  half: Image.asset('assets/ic_half_star.png'),
                ),
                itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                onRatingUpdate: (rating) {
                  // print(rating);
                },
              ))
        ]),

        const SizedBox(height: 20.0),

        /// PLUSES
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Titles.benefits,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                      color: HexColors.subtitle,
                    )),
                const SizedBox(height: 4.0),
                Text(
                    widget.pluses == null
                        ? '-'
                        : widget.pluses!.isEmpty
                            ? '-'
                            : widget.pluses!,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                      color: HexColors.black,
                    ))
              ],
            )),
        const SizedBox(height: 20.0),

        /// MINUSES
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(Titles.flaws,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                    color: HexColors.subtitle,
                  )),
              const SizedBox(height: 4.0),
              Text(
                  widget.minuses == null
                      ? '-'
                      : widget.minuses!.isEmpty
                          ? '-'
                          : widget.minuses!,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                    color: HexColors.black,
                  ))
            ])),
        const SizedBox(height: 12.0),

        /// DOCUMENTS

        widget.attachment == null
            ? Container()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                    constraints: const BoxConstraints(maxWidth: 148.0),
                    height: widget.attachment!.endsWith('.jpg') ||
                            widget.attachment!.endsWith('.jpeg') ||
                            widget.attachment!.endsWith('.png')
                        ? 102.0
                        : 32.0,
                    child: DocumentButtonWidget(
                        attachment: widget.attachment,
                        name: widget.attachment!.length >= 12
                            ? '...${widget.attachment!.substring(widget.attachment!.length - 11, widget.attachment!.length)}'
                                .toUpperCase()
                            : widget.attachment!.toUpperCase(),
                        onTap: () => widget.onDocumentTap == null
                            ? null
                            : widget.onDocumentTap!()))),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// COMMENTS BUTTON
                  widget.onAnswerTap == null
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: CommentButtonWidget(
                              count: widget.comments,
                              onTap: () => widget.onAnswerTap!())),
                  Row(children: [
                    /// LIKE BUTTON
                    widget.hideLikes == null
                        ? Material(
                            color: Colors.transparent,
                            child: InkWell(
                                onTap: () => widget.onLikeTap(),
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                  height: 24.0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Row(
                                    children: [
                                      Text(widget.likes.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.0,
                                            color: widget.isLiked
                                                ? HexColors.selected
                                                : HexColors.subtitle,
                                          )),
                                      const SizedBox(width: 4.0),
                                      Image.asset(widget.isLiked
                                          ? 'assets/ic_like_selected.png'
                                          : 'assets/ic_like.png')
                                    ],
                                  ),
                                )))
                        : Container(),

                    SizedBox(height: widget.onAnswerTap == null ? 0.0 : 10.0),
                  ])
                ])),
        Container(
            height: 1.0,
            color: HexColors.separator,
            margin: const EdgeInsets.only(left: 20.0, top: 16.0, bottom: 0.0))
      ]),
    );
  }
}
