import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/components/default_button.dart';
import 'package:stom_club/components/device_detector.dart';
import 'package:stom_club/components/back_button_widget.dart';
import 'package:stom_club/components/load_indicator_widget.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/constants/sizes.dart';
import 'package:stom_club/constants/titles.dart';
import 'package:stom_club/constants/ulrs.dart';
import 'package:stom_club/entities/auth_token.dart';
import 'package:stom_club/entities/authorization.dart';
import 'package:stom_club/entities/product.dart';
import 'package:stom_club/entities/review.dart';
import 'package:stom_club/models/reviews_view_model.dart';
import 'package:stom_club/screens/reviews/components/review_list_item.dart';
import 'package:stom_club/services/loading_status.dart';
import 'package:stom_club/services/pagination.dart';
import 'package:stom_club/services/user_service.dart';

class ReviewsScreenBodyWidget extends StatefulWidget {
  final Product product;
  final VoidCallback onPop;

  const ReviewsScreenBodyWidget(
      {Key? key, required this.product, required this.onPop})
      : super(key: key);

  @override
  _ReviewsScreenBodyState createState() => _ReviewsScreenBodyState();
}

class _ReviewsScreenBodyState extends State<ReviewsScreenBodyWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Authorization? _authorization;
  bool _isAuthorized = false;
  final ScrollController _scrollController =
      ScrollController(keepScrollOffset: true);
  final Pagination _pagination = Pagination(number: 1, size: 50);
  bool _isRefresh = false;

  @override
  void initState() {
    super.initState();

    _getAuthorization();

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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final reviewsViewModel =
        Provider.of<ReviewsViewModel>(context, listen: true);

    Review? myReview;

    for (var review in reviewsViewModel.reviews) {
      if (_authorization != null) {
        if (review.createdBy.id == _authorization?.id) {
          myReview = review;
        }
      }
    }

    if (_isRefresh) {
      _isRefresh = !_isRefresh;
      reviewsViewModel.getReviewList(_pagination);
    }

    return Scaffold(
        backgroundColor: HexColors.white,
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
                    reviewsViewModel.reviews.isEmpty
                        ? Titles.reviews
                        : '${Titles.reviews} (${reviewsViewModel.reviews.length})',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                      color: HexColors.black,
                    )),
                const SizedBox(height: 2.0),
                Text(widget.product.name,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                      color: HexColors.subtitle,
                    )),
              ],
            )),
        body: Stack(children: [
          /// REVIEWS
          SizedBox.expand(
              child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: HexColors.selected,
                  backgroundColor: HexColors.white,
                  child: ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: reviewsViewModel.reviews.length,
                      padding: EdgeInsets.only(
                          bottom: DeviceDetector.isLarge(context)
                              ? MediaQuery.of(context).padding.bottom + 64.0
                              : 72.0),
                      itemBuilder: (context, index) {
                        return ReviewListItem(
                            name:
                                '${reviewsViewModel.reviews[index].createdBy.firstName} ${reviewsViewModel.reviews[index].createdBy.lastName}',
                            url: reviewsViewModel.reviews[index].createdBy.photo ??
                                '',
                            rating: reviewsViewModel.reviews[index].rating
                                .toDouble(),
                            pluses: reviewsViewModel.reviews[index].advantages,
                            minuses: reviewsViewModel.reviews[index].defects,
                            comments:
                                reviewsViewModel.reviews[index].commentsCount,
                            attachment:
                                reviewsViewModel.reviews[index].attachment,
                            likes: reviewsViewModel.reviews[index].likesCount,
                            isLiked: reviewsViewModel.reviews[index].hasMyLike,
                            dislikes:
                                reviewsViewModel.reviews[index].dislikesCount,
                            isDisliked:
                                reviewsViewModel.reviews[index].hasMyDislike,
                            dateTime: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                .parse(
                                    reviewsViewModel.reviews[index].createdAt),
                            onUserTap: () => reviewsViewModel.showProfileScreen(
                                context,
                                reviewsViewModel.reviews[index].createdBy.id!),
                            onLikeTap: () => reviewsViewModel.setLikeToReview(
                                _pagination,
                                index,
                                !reviewsViewModel.reviews[index].hasMyLike),
                            onDislikeTap: () => reviewsViewModel
                                .setLikeToReview(_pagination, index, false),
                            onDocumentTap: () =>
                                reviewsViewModel.openFile(reviewsViewModel.reviews[index].attachment == null
                                    ? ''
                                    : reviewsViewModel.reviews[index].attachment!.contains('https')
                                        ? reviewsViewModel.reviews[index].attachment!
                                        : URLs.media_url + reviewsViewModel.reviews[index].attachment!),
                            onAnswerTap: () => reviewsViewModel.showCommentsScreen(
                                context,
                                _pagination,
                                _authorization == null
                                    ? false
                                    : !_isAuthorized
                                        ? false
                                        : _authorization?.id == reviewsViewModel.reviews[index].createdBy.id,
                                reviewsViewModel.reviews[index]));
                      }))),

          /// SEND/CHANGE REVIEW BUTTON
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DefaultButtonWidget(
                  title: myReview == null
                      ? Titles.feedback
                      : Titles.change_feedback,
                  margin: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      bottom: MediaQuery.of(context).padding.bottom == 0.0
                          ? 12.0
                          : MediaQuery.of(context).padding.bottom),
                  onTap: () => _isAuthorized
                      ? myReview == null
                          ? reviewsViewModel.showReviewScreen(
                              _pagination, myReview)
                          : reviewsViewModel.showAlert(
                              context, _pagination, myReview)
                      : showOkAlertDialog(
                          context: context,
                          title: Titles.warning,
                          message: Titles.only_auth_review)),
            ],
          ),

          /// NO DATA LABEL
          reviewsViewModel.loadingStatus == LoadingStatus.completed &&
                  reviewsViewModel.reviews.isEmpty
              ? Center(
                  child: Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: Sizes.appBarHeight),
                      child: Text(Titles.no_results,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              color: HexColors.unselected))))
              : Container(),

          /// INDICATOR
          reviewsViewModel.loadingStatus == LoadingStatus.searching
              ? Container(
                  margin: EdgeInsets.only(bottom: Sizes.appBarHeight + 34.0),
                  child: const Center(
                      child: LoadIndicatorWidget(indicatorOnly: true)))
              : Container(),
        ]));
  }
}
