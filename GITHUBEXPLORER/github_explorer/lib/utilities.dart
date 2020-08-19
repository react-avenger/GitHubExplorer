import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:github_explorer/model/repository.dart';
import 'package:intl/intl.dart';

import 'observer/repository_observer.dart';

class Utilities {
  static List<Repository> savedRepository = List();

  static getRepositoryCreatedDate(String createdDate) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final DateFormat displayFormat = DateFormat('dd-MM-yyyy');

    final DateTime dateTime = dateFormat.parse(createdDate);
    final String repoCreatedDate = displayFormat.format(dateTime);

    return repoCreatedDate;
  }

  static void saveRepository(Repository repository) {
    bool isExist = false;

    for (var i = 0; i < savedRepository.length; i++) {
      if (repository.id == savedRepository[i].id) {
        isExist = true;
        break;
      }
    }

    if (!isExist) {
      savedRepository.add(repository);
      StateProvider _stateProvider = StateProvider();
      _stateProvider.notify(ObserverState.SAVE_REPOSITORY);
    } else {
      showToastMessage('This repository is already saved!');
    }
  }

  static void unSaveRepository(Repository repository) {
    if (savedRepository.contains(repository)) {
      savedRepository.remove(repository);

      StateProvider _stateProvider = StateProvider();
      _stateProvider.notify(ObserverState.UN_SAVE_REPOSITORY);
    }
  }

  static void showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
