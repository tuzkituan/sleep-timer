import 'package:shared_preferences/shared_preferences.dart';

class TimerService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<double?> loadTimerValue() async {
    final prefs = await SharedPreferences.getInstance();
    final timerValue = prefs.getDouble('timerValue');
    return timerValue;
  }

  Future<void> saveTimerValue(double value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('timerValue', value);
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

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('isStart');
    prefs.remove('timerValue');
  }
}
