import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thinkerx/core/storage_util.dart';

Locale localeFromString(String localeString) {
  final localeList = localeString.split('_');
  switch (localeList.length) {
    case 2:
      return Locale(localeList.first, localeList.last);
    case 3:
      return Locale.fromSubtags(languageCode: localeList.first, scriptCode: localeList[1], countryCode: localeList.last);
    default:
      return Locale(localeList.first);
  }
}

class AppViewModel with ChangeNotifier {
  bool _isFollowDeviceLocale = StorageUtil.getBool('follow_device_locale');
  Locale _currentAppLocale = localeFromString(StorageUtil.getString('current_app_locale', defaultValue: 'zh_CN'));
  String _appTheme = StorageUtil.getString('app_theme', defaultValue: 'blue');
  List<String> _appFavorites = StorageUtil.getStringList('app_favorites', defaultValue: []);

  bool get followDeviceLocale => _isFollowDeviceLocale;
  Locale get currentAppLocale => _currentAppLocale;
  String get appTheme => _appTheme;
  List<String> get appFavorites => _appFavorites;

  handleChangeIsFollowDeviceLocale(bool isFollowDeviceLocale) {
    _isFollowDeviceLocale = isFollowDeviceLocale;
    StorageUtil.instance.setBool('follow_device_locale', isFollowDeviceLocale);
  }

  handleChangeCurrentAppLocale(Locale locale) {
    this._currentAppLocale = locale;
    StorageUtil.instance.setString('current_app_locale', locale.toString());
    notifyListeners();
  }

  handleSetTheme(String themeName) {
    this._appTheme = themeName;
    StorageUtil.instance.setString('app_theme', themeName);
    notifyListeners();
  }

  handleSetFavorites(List<String> favorites) {
    this._appFavorites = favorites;
    StorageUtil.instance.setStringList('app_favorites', favorites);
    notifyListeners();
  }
}
