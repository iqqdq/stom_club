// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:stom_club/entities/profession.dart';
import 'package:stom_club/entities/professions.dart';
import 'package:stom_club/repositories/profession_repository.dart';
import 'package:stom_club/services/loading_status.dart';
import 'package:stom_club/services/pagination.dart';

class ProfessionsViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;
  final List<Profession> _professions = [];

  List<Profession> get professions {
    return _professions;
  }

  ProfessionsViewModel() {
    getProfessions(Pagination(number: 1, size: 50));
  }

  /// MARK: - API CALL

  Future getProfessions(Pagination pagination) async {
    if (pagination.number == 1) {
      loadingStatus = LoadingStatus.searching;
      _professions.clear();
    }

    await ProfessionRepository().getProfessions(pagination).then((response) => {
          if (response is Professions)
            {
              if (_professions.isEmpty)
                {
                  response.results.forEach((profession) {
                    _professions.add(profession);
                  })
                }
              else
                {
                  response.results.forEach((newProfession) {
                    bool found = false;

                    for (var profession in _professions) {
                      if (profession.id == newProfession.id) {
                        found = true;
                      }
                    }

                    if (!found) {
                      _professions.add(newProfession);
                    }
                  })
                }
            }
        });

    loadingStatus = LoadingStatus.completed;
    notifyListeners();
  }
}
