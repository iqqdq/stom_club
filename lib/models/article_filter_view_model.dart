import 'package:flutter/material.dart';
import 'package:stom_club/entities/category.dart';
import 'package:stom_club/entities/subcategory.dart';
import 'package:stom_club/repositories/catalog_repository.dart';
import 'package:stom_club/services/loading_status.dart';
import 'package:stom_club/services/pagination.dart';

class ArticleFilterViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;
  final List<Subcategory> preselectedSubcategories;
  final List<Subcategory> _subcategories = [];
  final List<Subcategory> _selectedSubcategories = [];

  List<Subcategory> get subcategories {
    return _subcategories;
  }

  List<Subcategory> get selectedSubcategories {
    return _selectedSubcategories;
  }

  ArticleFilterViewModel(this.preselectedSubcategories) {
    _selectedSubcategories.addAll(preselectedSubcategories);
    getCategoryList(Pagination(number: 1, size: 40));
  }

  /// MARK: -
  /// MARK: - API CALL

  Future getCategoryList(Pagination pagination) async {
    loadingStatus == LoadingStatus.searching;

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

  void onItemSelect(Subcategory subcategory) {
    if (_selectedSubcategories.isEmpty) {
      _selectedSubcategories.add(subcategory);
    } else {
      var found = false;
      for (var selectedSubcategory in _selectedSubcategories) {
        if (subcategory.id == selectedSubcategory.id) {
          found = true;
        }
      }

      if (found) {
        _selectedSubcategories
            .removeWhere((element) => element.id == subcategory.id);
      } else {
        _selectedSubcategories.add(subcategory);
      }
    }

    notifyListeners();
  }

  void onApplyTap(
      BuildContext context, Function(List<Subcategory>) didReturnValue) {
    didReturnValue(_selectedSubcategories);
    Navigator.pop(context);
  }
}
