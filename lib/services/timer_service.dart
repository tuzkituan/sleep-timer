import 'package:shared_preferences/shared_preferences.dart';

class TimerService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<int?> loadTimerValue() async {
    final prefs = await SharedPreferences.getInstance();
    final timerValue = prefs.getInt('timerValue');
    return timerValue;
  }

  Future<void> saveTimerValue(int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('timerValue', value);
  }

  Future<bool> loadIsStart() async {
    final prefs = await SharedPreferences.getInstance();
    final isStart = prefs.getBool('isStart');
    return isStart ?? false;
  }

  Future<void> saveIsStart(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isStart', value);
  }
}
