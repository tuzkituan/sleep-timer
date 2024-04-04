import 'package:flutter/material.dart';

enum AppThemeKeys { theme0, theme1, theme2, theme3 }

final Map<AppThemeKeys, ThemeData> ThemeList = {
  AppThemeKeys.theme0: ThemeData(
    primaryColor: const Color(0xFF051a3b),
    scaffoldBackgroundColor: const Color(0xFF051a3b),
    dialogBackgroundColor: const Color(0xFF051a3b),
    brightness: Brightness.dark,
  ),
  AppThemeKeys.theme1: ThemeData(
    primaryColor: const Color(0xFF362666),
    scaffoldBackgroundColor: const Color(0xFF362666),
    dialogBackgroundColor: const Color(0xFF362666),
    brightness: Brightness.dark,
  ),
  AppThemeKeys.theme2: ThemeData(
    primaryColor: const Color(0xFF18122a),
    scaffoldBackgroundColor: const Color(0xFF18122a),
    dialogBackgroundColor: const Color(0xFF18122a),
    brightness: Brightness.dark,
  ),

  // 582143
  AppThemeKeys.theme3: ThemeData(
    primaryColor: const Color(0xFF121212),
    scaffoldBackgroundColor: const Color(0xFF121212),
    dialogBackgroundColor: const Color(0xFF121212),
    brightness: Brightness.dark,
  ),
};

final Map<AppThemeKeys, String> ThemeCharacter = {
  AppThemeKeys.theme0: 'assets/sleep_man.svg',
  AppThemeKeys.theme1: 'assets/sleep_girl.svg',
  AppThemeKeys.theme2: 'assets/sleep_earth.svg',
  AppThemeKeys.theme3: 'assets/sleep_man_1.svg',
};
