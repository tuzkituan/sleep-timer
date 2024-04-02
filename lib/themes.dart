import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

enum AppThemeKeys { theme0, theme1 }

final Map<AppThemeKeys, ThemeData> ThemeList = {
  AppThemeKeys.theme0: ThemeData(
    primaryColor: const Color(0xFF0a377a),
    scaffoldBackgroundColor: const Color(0xFF0a377a),
    brightness: Brightness.dark,
    textTheme: GoogleFonts.archivoTextTheme().copyWith(
      bodyLarge: TextStyle(
        color: Colors.white,
        fontFamily: GoogleFonts.archivo().fontFamily,
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontFamily: GoogleFonts.archivo().fontFamily,
      ),
    ),
  ),
  AppThemeKeys.theme1: ThemeData(
    primaryColor: const Color(0xFF322557),
    scaffoldBackgroundColor: const Color(0xFF322557),
    brightness: Brightness.dark,
    textTheme: GoogleFonts.archivoTextTheme().copyWith(
      bodyLarge: TextStyle(
        color: Colors.white,
        fontFamily: GoogleFonts.archivo().fontFamily,
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontFamily: GoogleFonts.archivo().fontFamily,
      ),
    ),
  ),
};

final Map<AppThemeKeys, String> ThemeCharacter = {
  AppThemeKeys.theme0: 'assets/sleep_man.svg',
  AppThemeKeys.theme1: 'assets/sleep_earth.svg',
};

class AppTheme extends ChangeNotifier {
  static AppTheme of(BuildContext context, {bool listen = false}) =>
      Provider.of<AppTheme>(context, listen: listen);

  AppThemeKeys _themeKey = AppThemeKeys.theme0;

  ThemeData get currentTheme => ThemeList[_themeKey] ?? ThemeData();
  AppThemeKeys get currentThemeKey => _themeKey;

  void setTheme(AppThemeKeys themeKey) {
    _themeKey = themeKey;
    notifyListeners();
  }
}
