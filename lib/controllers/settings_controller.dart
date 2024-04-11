import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleep_timer/services/settings_service.dart';
import 'package:sleep_timer/utils/layouts.dart';
import 'package:sleep_timer/utils/themes.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this._settingsService);
  final SettingsService _settingsService;

  late AppThemeKeys _themeKey;
  late AppLayoutKeys _layoutKey;

  Future<void> loadSettings() async {
    _themeKey = await _settingsService.loadThemeKey();
    _layoutKey = await _settingsService.loadLayoutKey();

    notifyListeners();
  }

  static SettingsController of(BuildContext context, {bool listen = false}) =>
      Provider.of<SettingsController>(context, listen: listen);

  ThemeData get currentTheme => ThemeList[_themeKey] ?? ThemeData();
  AppThemeKeys get currentThemeKey => _themeKey;

  AppLayoutKeys get currentLayoutKey => _layoutKey;

  Future<void> setLayout(AppLayoutKeys? layoutKey) async {
    if (layoutKey == null) return;
    if (layoutKey == _layoutKey) return;
    _layoutKey = layoutKey;
    notifyListeners();
    await _settingsService.updateLayoutKey(layoutKey);
  }

  Future<void> setTheme(AppThemeKeys? themeKey) async {
    if (themeKey == null) return;
    if (themeKey == _themeKey) return;
    _themeKey = themeKey;
    notifyListeners();
    await _settingsService.updateThemeKey(themeKey);
  }
}
