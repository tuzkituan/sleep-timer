import 'package:flutter/material.dart';

enum AppThemeKeys { theme0, theme1, theme2, theme3 }

final Map<AppThemeKeys, ThemeData> ThemeList = {
  AppThemeKeys.theme0: ThemeData(
    primaryColor: const Color(0xFF051a3b),
    scaffoldBackgroundColor: const Color(0xFF051a3b),
    brightness: Brightness.dark,
  ),
  AppThemeKeys.theme1: ThemeData(
    primaryColor: const Color(0xFF18122a),
    scaffoldBackgroundColor: const Color(0xFF18122a),
    brightness: Brightness.dark,
  ),
  AppThemeKeys.theme2: ThemeData(
    primaryColor: const Color(0xFF121212),
    scaffoldBackgroundColor: const Color(0xFF121212),
    brightness: Brightness.dark,
  ),
  AppThemeKeys.theme3: ThemeData(
    primaryColor: Colors.blueGrey[900],
    scaffoldBackgroundColor: Colors.blueGrey[900],
    brightness: Brightness.dark,
  ),
};

final Map<AppThemeKeys, String> ThemeCharacter = {
  AppThemeKeys.theme0: 'assets/sleep_man.svg',
  AppThemeKeys.theme1: 'assets/sleep_earth.svg',
  AppThemeKeys.theme2: 'assets/sleep_man.svg',
  AppThemeKeys.theme3: 'assets/sleep_earth.svg',
};
