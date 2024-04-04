import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep_timer/utils/themes.dart';

class SettingsService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<AppThemeKeys> loadThemeKey() async {
    final prefs = await SharedPreferences.getInstance();
    final themeKey = prefs.getString('themeKey');
    return themeKey == null
        ? AppThemeKeys.theme0
        : AppThemeKeys.values.firstWhere(
            (e) => e.toString() == themeKey,
            orElse: () => AppThemeKeys.theme0,
          );
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeKey(AppThemeKeys themeKey) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('themeKey', themeKey.toString());
  }
}
