// ignore_for_file: avoid_print

import 'dart:async';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/components/chat_message_bar_widget.dart';
import 'package:stom_club/components/back_button_widget.dart';
import 'package:stom_club/components/device_detector.dart';
import 'package:stom_club/components/load_indicator_widget.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/sizes.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/constants/ulrs.dart';
import 'package:stom_club/entities/auth_token.dart';
import 'package:stom_club/entities/authorization.dart';
import 'package:stom_club/entities/review.dart';
import 'package:stom_club/models/comments_view_model.dart';
import 'package:stom_club/screens/comments/components/comment_list_item.dart';
import 'package:stom_club/services/loading_status.dart';
import 'package:stom_club/services/pagination.dart';
import 'package:stom_club/services/user_service.dart';

class CommentsScreenBodyWidget extends StatefulWidget {
  final bool isMineReview;
  final Review review;
  final VoidCallback onPop;

  const CommentsScreenBodyWidget(
      {Key? key,
      required this.isMineReview,
      required this.review,
      required this.onPop})
      : super(key: key);

  @override
  _CommentsScreenBodyState createState() => _CommentsScreenBodyState();
}

class _CommentsScreenBodyState extends State<CommentsScreenBodyWidget> {
  final ScrollController _scrollController =
      ScrollController(keepScrollOffset: true);
  final Pagination _pagination = Pagination(number: 1, size: 50);
  bool _isRefresh = false;
  bool _isScrolling = false;
  String? _filePath;
  String? _fileName;

  final TextEditingController _textEditingController = TextEditingController();
  final _focusNode = FocusNode();
  late Review _review;
  Authorization? _authorization;
  bool _isAuthorized = false;

  @override
  void initState() {
    _review = widget.review;

    super.initState();

    _getAuthorization();

    _scrollController.addListener(() {
      if (!_isScrolling) {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _pagination.number++;
          setState(() => _isRefresh = !_isRefresh);
        }
      }
    });

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future<void> _onRefresh() async {
    _pagination.number = 1;
    setState(() => _isRefresh = !_isRefresh);
  }

  void _getAuthorization() async {
    UserService userService = UserService();

    _authorization = await userService.getAuth();
    if (_authorization != null) {
      if (_authorization!.isCreated == false) {
        AuthToken? authToken = await userService.getToken();
        if (authToken != null) {
          _isAuthorized = true;
        }
      }
    }

    setState(() {});
  }

  void _scrollDown(ScrollController scrollController) {
    _isScrolling = true;
    Future.delayed(const Duration(milliseconds: 200)).then((_) {
      try {
        scrollController
            .animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
        )
            .then((value) {
          scrollController
              .animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
              )
              .then((value) => _isScrolling = false);
        });
      } catch (e) {
        print('error on scroll $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _commentsViewModel =
        Provider.of<CommentsViewModel>(context, listen: true);

    if (_isRefresh) {
      _isRefresh = !_isRefresh;
      _commentsViewModel.getCommentList(_pagination);
    }

    return Scaffold(
        backgroundColor: HexColors.gray,
        appBar: AppBar(
            toolbarHeight: Sizes.appBarHeight,
            backgroundColor: HexColors.white,
            centerTitle: false,
            elevation: 0.0,
            leading: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: BackButtonWidget(
                    color: HexColors.white,
                    onTap: () => {widget.onPop(), Navigator.pop(context)})),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    _review.commentsCount == 0
                        ? Titles.comments
                        : '${Titles.comments} (${_review.commentsCount})',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                      color: HexColors.black,
                    ))
              ],
            )),
        body: Stack(children: [
          Column(children: [
            /// REVIEW
            // _focusNode.hasFocus
            //     ? Container()
            //     : ReviewListItem(
            //         hideLikes: true,
            //         name:
            //             '${widget.review.createdBy.firstName} ${widget.review.createdBy.lastName}',
            //         url: _review.createdBy.photo ?? '',
            //         rating: _review.rating.toDouble(),
            //         pluses: _review.advantages,
            //         minuses: _review.defects,
            //         comments: _review.commentsCount,
            //         attachment: _review.attachment,
            //         likes: _review.likesCount,
            //         isLiked: _review.hasMyLike,
            //         dislikes: _review.dislikesCount,
            //         isDisliked: _review.hasMyDislike,
            //         dateTime: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            //             .parse(_review.createdAt),
            //         onDocumentTap: () => _review.attachment == null
            //             ? null
            //             : _commentsViewModel.openFile(
            //                 context, _review.attachment!),
            //         onUserTap: () => _commentsViewModel.showProfileScreen(
            //             context, _review.createdBy.id!),
            //         onLikeTap: () => {},
            //         onDislikeTap: () => {}),

            /// COMMENTS
            Expanded(
                child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: HexColors.selected,
                    backgroundColor: HexColors.white,
                    child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        itemCount: _commentsViewModel.comments.length,
                        padding: EdgeInsets.only(
                            top: 20.0,
                            bottom: DeviceDetector().isLarge() ? 0.0 : 12.0),
                        itemBuilder: (context, index) {
                          return CommentListItem(
                              isMineComment: _authorization == null
                                  ? false
                                  : _authorization?.id ==
                                      _commentsViewModel
                                          .comments[index].user.id,
                              url: _commentsViewModel.comments[index].user.photo ??
                                  '',
                              attachment:
                                  _commentsViewModel.comments[index].attachment,
                              name:
                                  '${_commentsViewModel.comments[index].user.firstName} ${_commentsViewModel.comments[index].user.lastName}',
                              text: _commentsViewModel.comments[index].comment,
                              dateTime: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(
                                  _commentsViewModel.comments[index].createdAt),
                              onUserTap: () => _commentsViewModel.showProfileScreen(
                                  context,
                                  _commentsViewModel.comments[index].user.id!),
                              onDocumentTap: () => _commentsViewModel
                                          .comments[index].attachment ==
                                      null
                                  ? null
                                  : _commentsViewModel.openFile(
                                      context,
                                      _commentsViewModel.comments[index].attachment ==
                                              null
                                          ? ''
                                          : _commentsViewModel
                                                  .comments[index].attachment!
                                                  .contains('https')
                                              ? _commentsViewModel.comments[index].attachment!
                                              : URLs.media_url + _commentsViewModel.comments[index].attachment!),
                              onRemoveTap: () => _commentsViewModel.removeComment(_commentsViewModel.comments[index].id));
                        }))),

            /// MESSAGE BAR
            ChatMessageBarWidget(
                textEditingController: _textEditingController,
                focusNode: _focusNode,
                onChanged: (text) => setState((() => {})),
                didReturnValue: (path, name) => _isAuthorized
                    ? _commentsViewModel
                        .sendComment('file', path, name)
                        .then((value) => {
                              setState(() {
                                _fileName == null;
                                _filePath == null;
                              }),

                              /// UPDATE LIST
                              _scrollDown(_scrollController)
                            })
                    : showOkAlertDialog(
                        context: context,
                        title: Titles.warning,
                        message: Titles.only_auth_review),
                onSendTap: () => {
                      if (_isAuthorized)
                        {
                          if (_textEditingController.text.isNotEmpty)
                            {
                              // FocusScope.of(context).unfocus(),
                              // _pagination.size += 10,
                              _commentsViewModel
                                  .sendComment(
                                      _textEditingController.text, null, null)
                                  .then((value) => {
                                        _textEditingController.clear(),

                                        /// UPDATE LIST
                                        _scrollDown(_scrollController)
                                      }),
                            }
                        }
                      else
                        {
                          _textEditingController.clear(),
                          FocusScope.of(context).unfocus(),
                          Future.delayed(
                              const Duration(milliseconds: 600),
                              () => showOkAlertDialog(
                                  context: context,
                                  title: Titles.warning,
                                  message: Titles.only_auth_comment))
                        }
                    })
          ]),

          /// EMPTY LIST TEXT
          _commentsViewModel.loadingStatus == LoadingStatus.completed &&
                  _commentsViewModel.comments.isEmpty
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
          _commentsViewModel.loadingStatus == LoadingStatus.searching
              ? Container(
                  margin: EdgeInsets.only(bottom: Sizes.appBarHeight + 32.0),
                  child: const Center(
                      child: LoadIndicatorWidget(indicatorOnly: true)))
              : Container()
        ]));
  }
}
