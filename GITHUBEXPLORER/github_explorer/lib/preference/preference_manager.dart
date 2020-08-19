import 'package:github_explorer/model/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PreferenceManager {
  static var _instance;
  static var _preferences;

  static Future<PreferenceManager> getInstance() async {
    if (_instance == null) {
      _instance = PreferenceManager();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }

  static setRepositoryData(List<Repository> savedRepository) {
    removeStoredRepositoryData();
    String jsonUser = jsonEncode(savedRepository);
    _preferences.setString('saved_repository', jsonUser);
  }

  static List<Repository> getRepositoryData() {
    if (_preferences.containsKey('saved_repository')) {
      String result = _preferences.getString('saved_repository');

      var jsonObject = jsonDecode(result) as List;
      List<Repository> resultList =
          jsonObject.map((json) => Repository.fromJSON(json)).toList();

      return resultList;
    } else {
      return null;
    }
  }

  static removeStoredRepositoryData() {
    _preferences.remove('saved_repository');
  }
}
