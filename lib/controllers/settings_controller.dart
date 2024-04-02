import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleep_timer/services/settings_service.dart';
import 'package:sleep_timer/utils/themes.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this._settingsService);
  final SettingsService _settingsService;

  late AppThemeKeys _themeKey;
  late int _maxTime;

  Future<void> loadSettings() async {
    _themeKey = await _settingsService.loadThemeKey();
    _maxTime = await _settingsService.loadMaxTime();
    notifyListeners();
  }

  static SettingsController of(BuildContext context, {bool listen = false}) =>
      Provider.of<SettingsController>(context, listen: listen);

  ThemeData get currentTheme => ThemeList[_themeKey] ?? ThemeData();
  AppThemeKeys get currentThemeKey => _themeKey;

  int get maxTime => _maxTime;

  set maxTime(int maxTime) {
    _maxTime = maxTime;
    notifyListeners();
    _settingsService.updateMaxTime(maxTime);
  }

  Future<void> setTheme(AppThemeKeys? themeKey) async {
    if (themeKey == null) return;
    if (themeKey == _themeKey) return;
    _themeKey = themeKey;
    notifyListeners();
    await _settingsService.updateThemeKey(themeKey);
  }
}
