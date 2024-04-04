import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
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
          AwesomeNotifications().dismissAllNotifications();
          notifyListeners();
        } else {
          // int min = (timerValue / 60).floor();
          timerValue--;
          // showNotification(
          //   minutes: min,
          // );
          notifyListeners();
        }
      },
    );
  }

  void stopTimer() {
    if (_timer != null) {
      _timer?.cancel();
    }
    isStart = false;
    AwesomeNotifications().dismissAllNotifications();
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
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'sleep_timer_channel',
        title: "You're set",
        body: '${minutes.toString()} minutes remaining',
        locked: true,
      ),
    );
  }

  Future<void> extendTimer() async {
    timerValue += 5 * 60;
    notifyListeners();
  }

  void resetTimer() {
    AwesomeNotifications().dismissAllNotifications();
    if (_timer != null) {
      _timer?.cancel();
    }
    isStart = false;
    timerValue = AppVariables.INIT_TIME * 60;
    notifyListeners();
  }
}
