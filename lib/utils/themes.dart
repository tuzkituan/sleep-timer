import 'package:flutter/material.dart';

enum AppThemeKeys { theme0, theme1 }

final Map<AppThemeKeys, ThemeData> ThemeList = {
  AppThemeKeys.theme0: ThemeData(
    primaryColor: const Color(0xFF0a377a),
    scaffoldBackgroundColor: const Color(0xFF0a377a),
    brightness: Brightness.dark,
  ),
  AppThemeKeys.theme1: ThemeData(
    primaryColor: const Color(0xFF322557),
    scaffoldBackgroundColor: const Color(0xFF322557),
    brightness: Brightness.dark,
  ),
};

final Map<AppThemeKeys, String> ThemeCharacter = {
  AppThemeKeys.theme0: 'assets/sleep_man.svg',
  AppThemeKeys.theme1: 'assets/sleep_earth.svg',
};
