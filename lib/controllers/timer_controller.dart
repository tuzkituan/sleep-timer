import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sleep_timer/utils/app_variables.dart';

class TimerController extends ChangeNotifier {
  Timer? _timer;
  bool isStart = false;
  late int timerValue = AppVariables.INIT_TIME * 60;
  bool needReset = false;

  void setTimerValue(int value) {
    timerValue = value;
    notifyListeners();
  }

  Future<void> startTimer() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    isStart = true;
    notifyListeners();

    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) async {
        if (timerValue == 0) {
          if (await session.setActive(true,
              avAudioSessionSetActiveOptions:
                  const AVAudioSessionSetActiveOptions(1),
              androidAudioFocusGainType: AndroidAudioFocusGainType.gain)) {
            print("end");
            await session.setActive(false);
          }

          timer.cancel();
          timerValue = AppVariables.INIT_TIME * 60;
          isStart = false;
          notifyListeners();
        } else {
          int min = (timerValue / 60).floor();
          timerValue--;
          showNotification(
            minutes: min,
          );
          notifyListeners();
        }
      },
    );
  }

  void stopTimer() async {
    if (_timer != null) {
      _timer?.cancel();
    }
    isStart = false;
    await FlutterLocalNotificationsPlugin().cancelAll();
    notifyListeners();
  }

  Map<String, String> getTime() {
    int sec = timerValue % 60;
    int min = (timerValue / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return {
      "minute": minute,
      "second": second,
    };
  }

  Future<void> showNotification({int minutes = 0}) async {
    FlutterLocalNotificationsPlugin().show(
      3,
      "You're set!",
      '$minutes minutes left',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "sleep_timer_channel",
          'SleepTimer',
          ongoing: true,
          playSound: false,
          actions: [
            AndroidNotificationAction(
              'stop',
              'Stop',
              showsUserInterface: true,
            ),
            AndroidNotificationAction(
              'extend',
              'Extend',
              showsUserInterface: true,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> extendTimer() async {
    var newValue = timerValue + 5 * 60;
    if (newValue > AppVariables.MAX_TIME * 60) {
      newValue = AppVariables.MAX_TIME * 60;
    }
    timerValue = newValue;
    notifyListeners();
  }
}
