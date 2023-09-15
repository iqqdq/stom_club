import 'package:flutter/material.dart';
import 'package:stom_club/entities/manufacturer.dart';
import 'package:stom_club/entities/manufacturers.dart';
import 'package:stom_club/repositories/product_repository.dart';
import 'package:stom_club/services/loading_status.dart';
import 'package:stom_club/services/pagination.dart';

class ManufacturerFilterViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;
  final List<Manufacturer> preselectedManufacturers;
  final List<Manufacturer> _manufacturers = [];
  final List<Manufacturer> _selectedManufacturers = [];

  List<Manufacturer> get manufacturers {
    return _manufacturers;
  }

  List<Manufacturer> get selectedManufacturers {
    return _selectedManufacturers;
  }

  ManufacturerFilterViewModel(this.preselectedManufacturers) {
    _selectedManufacturers.addAll(preselectedManufacturers);
    getManufacturerList(Pagination(number: 1, size: 50));
  }

  /// MARK: -
  /// MARK: - API CALL

  Future getManufacturerList(Pagination pagination) async {
    if (pagination.number == 1) {
      loadingStatus = LoadingStatus.searching;
      _manufacturers.clear();
    }

    await ProductRepository().getManufacturers(pagination).then((response) => {
          if (response is Manufacturers)
            {
              if (_manufacturers.isEmpty)
                response.results?.forEach((manufacturer) {
                  _manufacturers.add(manufacturer);
                })
              else
                {
                  response.results?.forEach((newManufacturer) {
                    bool found = false;

                    for (var manufacturer in _manufacturers) {
                      if (manufacturer.id == newManufacturer.id) {
                        found = true;
                      }
                    }

                    if (!found) {
                      _manufacturers.add(newManufacturer);
                    }
                  })
                },
              loadingStatus = LoadingStatus.completed
            }
          else
            loadingStatus = LoadingStatus.error,
          notifyListeners()
        });
  }

  /// MARK: -
  /// MARK: - ACTIONS

  void onItemSelect(Manufacturer manufacturer) {
    if (_selectedManufacturers.isEmpty) {
      _selectedManufacturers.add(manufacturer);
    } else {
      var found = false;
      for (var selectedManufacturer in _selectedManufacturers) {
        if (manufacturer.id == selectedManufacturer.id) {
          found = true;
        }
      }

      if (found) {
        _selectedManufacturers
            .removeWhere((element) => element.id == manufacturer.id);
      } else {
        _selectedManufacturers.add(manufacturer);
      }
    }

    notifyListeners();
  }

  void onApplyTap(
      BuildContext context, Function(List<Manufacturer>) didReturnValue) {
    didReturnValue(_selectedManufacturers);
    Navigator.pop(context);
  }
}
