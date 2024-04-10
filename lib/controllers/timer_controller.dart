import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:sleep_timer/utils/app_variables.dart';

class TimerController extends ChangeNotifier {
  static const notificationChannelId = 'my_foreground';
  static const notificationId = 145;

  bool isStart = false;
  int timerValue = AppVariables.INIT_TIME * 60;

  void setTimerValue(int value) {
    timerValue = value;
    notifyListeners();
  }

  Future<void> startTimer() async {
    isStart = true;
    notifyListeners();
  }

  void stopTimer() async {
    isStart = false;
    FlutterForegroundTask.stopService();
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
}
