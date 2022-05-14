import 'package:flutter/material.dart';
import 'package:frontend/util/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppStatus { notInitialized, initialized }

class Allergens extends ChangeNotifier {
  AppStatus? _status;
  List<String>? _userAllergens;
  SharedPreferences? _sharedPreferences;

  List<Function(AppStatus)> _onInitCallbacks = [];

  Allergens() {
    _status = AppStatus.notInitialized;
    SharedPreferences.getInstance().then((sp) {
      _sharedPreferences = sp;
      _getUserAllergensFromPreferences();
    });
  }

  void _getUserAllergensFromPreferences() {
    _userAllergens = _sharedPreferences!.getStringList(userAllergensSlug);

    if (_userAllergens == null) {
      _status = AppStatus.notInitialized;

      _callOnInitCallback();
      notifyListeners();
      return;
    }

    _status = AppStatus.initialized;
    notifyListeners();
  }

  void _callOnInitCallback() {
    for (Function(AppStatus) f in _onInitCallbacks) {
      f(_status!);
    }

    _onInitCallbacks = [];
  }

  void updateUserAllergens(List<String> allergens) {
    _userAllergens = allergens;
    _sharedPreferences!.setStringList(userAllergensSlug, allergens);
    notifyListeners();
  }

  void setOnInitCallback(Function(AppStatus) onInit) {
    if (_status != AppStatus.notInitialized) {
      // init already completed, call function
      Future.delayed(Duration.zero).then((_) => onInit(_status!));
    } else {
      // save function and update on init
      _onInitCallbacks.add(onInit);
    }
  }

  List<String>? get userAllergens => _userAllergens;

  AppStatus? get status => _status;
}
