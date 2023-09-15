import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stom_club/components/transparent_route.dart';
import 'package:stom_club/entities/advertising.dart';
import 'package:stom_club/entities/advertisings.dart';
import 'package:stom_club/entities/auth_token.dart';
import 'package:stom_club/entities/authorization.dart';
import 'package:stom_club/entities/category.dart';
import 'package:stom_club/entities/subcategory.dart';
import 'package:stom_club/entities/user.dart';
import 'package:stom_club/repositories/authoriztion_repository.dart';
import 'package:stom_club/repositories/catalog_repository.dart';
import 'package:stom_club/screens/authorization/authorization_screen.dart';
import 'package:stom_club/screens/banner/banner_screen.dart';
import 'package:stom_club/screens/category/category_screen.dart';
import 'package:stom_club/screens/products/products_screen.dart';
import 'package:stom_club/screens/profile/profile_screen.dart';
import 'package:stom_club/screens/search/search_screen.dart';
import 'package:stom_club/services/loading_status.dart';
import 'package:stom_club/services/pagination.dart';
import 'package:stom_club/services/user_service.dart';

class CatalogViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;
  UserService userService = UserService();

  final List<Advertising> _banners = [];
  final List<Subcategory> _subcategories = [];
  User? _user;

  User? get user {
    return _user;
  }

  List<Advertising> get banners {
    return _banners;
  }

  List<Subcategory> get subcategories {
    return _subcategories;
  }

  CatalogViewModel() {
    getTokenLifecycle();
  }

  /// MARK: -
  /// MARK: - API CALL

  Future getTokenLifecycle() async {
    AuthToken? authToken = await userService.getToken();
    DateTime? tokenDateTime = await userService.getTokenDate();

    if (authToken != null) {
      if (tokenDateTime != null) {
        /// DETECT TOKEN DATE
        if (tokenDateTime
            .add(const Duration(days: 6))
            .isBefore(DateTime.now())) {
          refreshToken(tokenDateTime, authToken.refresh);
        }
      } else {
        /// LOGOUT IF NEW APP VERSION
        userService.clear();
      }
    }

    getBannerList(Pagination(number: 1, size: 40));
  }

  Future refreshToken(DateTime dateTime, String refresh) async {
    if (dateTime.add(const Duration(days: 21)).isAfter(DateTime.now())) {
      ///  REFRESH IF TOKEN HAS EXPIRED
      AuthToken newAuthToken =
          await AuthorizationRepository().refreshToken(refresh);
      userService.setToken(newAuthToken);
      userService.setTokenDate(DateTime.now());
    } else {
      ///  LOGOUT IF TOKEN_REFRESH HAS EXPIRED
      userService.clear();
    }
  }

  Future getBannerList(Pagination pagination) async {
    loadingStatus = LoadingStatus.searching;

    await CatalogRepository().getBanners(pagination).then((response) => {
          if (response is Advertisings)
            {
              if (_banners.isEmpty)
                {
                  response.results?.forEach((banner) {
                    _banners.add(banner);
                  })
                }
              else
                {
                  response.results?.forEach((newBanner) {
                    bool found = false;

                    for (var banner in _banners) {
                      if (banner.id == newBanner.id) {
                        found = true;
                      }
                    }

                    if (!found) {
                      _banners.add(newBanner);
                    }
                  })
                },

              // loadingStatus = LoadingStatus.completed
            }
          else
            loadingStatus = LoadingStatus.error,
          getCategoryList(Pagination(number: 1, size: 40))
        });
  }

  Future getCategoryList(Pagination pagination) async {
    await CatalogRepository().getCategories(pagination).then((response) => {
          if (response is Category)
            {
              if (_subcategories.isEmpty)
                {
                  response.results?.forEach((subcategory) {
                    _subcategories.add(subcategory);
                  })
                }
              else
                {
                  response.results?.forEach((newCategory) {
                    bool found = false;

                    for (var subcategory in _subcategories) {
                      if (subcategory.id == newCategory.id) {
                        found = true;
                      }
                    }

                    if (!found) {
                      _subcategories.add(newCategory);
                    }
                  })
                },
              _subcategories.sort((b, a) =>
                  a.subcategories.length.compareTo(b.subcategories.length)),
              loadingStatus = LoadingStatus.completed
            }
          else
            loadingStatus = LoadingStatus.error,
          notifyListeners()
        });
  }

  /// MARK: -
  /// MARK: - ACTIONS

  void showSearchScreen(BuildContext context) {
    Navigator.push(context,
        TransparentRoute(builder: (context) => const SearchScreenWidget()));
  }

  void showBannerScreen(BuildContext context, Advertising banner) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BannerScreenWidget(banner: banner)));
  }

  void showCategoryScreen(BuildContext context, Subcategory subcategory) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CategoryScreenWidget(subcategory: subcategory)));
  }

  void showProductsScreen(
      BuildContext context, bool isNew, List<Subcategory> subcategories) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductsScreenWidget(
                isNew: isNew, subcategories: subcategories)));
  }

  void showProfileScreen(BuildContext context) async {
    Authorization? authorization = await userService.getAuth();
    AuthToken? authToken = await userService.getToken();

    showMaterialModalBottomSheet(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => authorization == null
            ? const AuthorizationScreenWidget()
            : authorization.isCreated == true
                ? const AuthorizationScreenWidget()
                : authToken == null
                    ? const AuthorizationScreenWidget()
                    : ProfileScreenWidget(userId: authorization.id));
  }
}
