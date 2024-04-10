import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:provider/provider.dart';
import 'package:sleep_timer/services/timer_service.dart';
import 'package:sleep_timer/utils/app_variables.dart';

class TimerController extends ChangeNotifier {
  TimerController(this._timerService);
  final TimerService _timerService;

  static const notificationChannelId = 'my_foreground';
  static const notificationId = 145;

  bool isStart = false;
  double timerValue = AppVariables.INIT_TIME * 60;

  Future<void> loadState() async {
    var isRunning = await FlutterForegroundTask.isRunningService;
    if (isRunning == true) {
      double? temp = await _timerService.loadTimerValue();
      if (temp != null) {
        timerValue = temp;
      }
      isStart = await _timerService.loadIsStart();
    } else {
      _timerService.reset();
    }
    notifyListeners();
  }

  static TimerController of(BuildContext context, {bool listen = false}) =>
      Provider.of<TimerController>(context, listen: listen);

  void setTimerValue(double value) {
    timerValue = value;
    notifyListeners();
  }

  void updateTimer(double value) {
    timerValue = value;
    if (!isStart) {
      isStart = true;
    }
    _timerService.saveTimerValue(value);
    _timerService.saveIsStart(isStart);
    notifyListeners();
  }

  Future<void> startTimer() async {
    isStart = true;
    _timerService.saveIsStart(true);
    notifyListeners();
  }

  void stopTimer() async {
    isStart = false;
    _timerService.saveIsStart(false);
    notifyListeners();
  }

  Map<String, String> getTime() {
    num sec = timerValue % 60;
    num min = (timerValue / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return {
      "minute": minute,
      "second": second,
    };
  }
}
