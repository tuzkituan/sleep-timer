import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:sleep_timer/task_handlers/my_task_handler.dart';
import 'package:sleep_timer/utils/app_variables.dart';

@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class TimerController extends ChangeNotifier {
  static const notificationChannelId = 'my_foreground';
  static const notificationId = 145;

  ReceivePort? _receivePort;

  bool isStart = false;
  int timerValue = AppVariables.INIT_TIME * 60;

  void initForegroundTask() async {
    if (await FlutterForegroundTask.isRunningService) {
      final newReceivePort = FlutterForegroundTask.receivePort;
      _registerReceivePort(newReceivePort);
    } else {
      FlutterForegroundTask.init(
        androidNotificationOptions: AndroidNotificationOptions(
          id: notificationId,
          channelId: notificationChannelId,
          channelName: 'Sleep Timer Foreground Service',
          channelDescription:
              'This notification appears when the foreground service is running.',
          channelImportance: NotificationChannelImportance.LOW,
          priority: NotificationPriority.LOW,
          isSticky: true,
          iconData: const NotificationIconData(
            resType: ResourceType.drawable,
            resPrefix: ResourcePrefix.ic,
            name: 'bg_service_small',
          ),
          buttons: [
            const NotificationButton(
              id: 'stop',
              text: 'Stop',
            ),
            const NotificationButton(
              id: 'extend',
              text: 'Extend',
            ),
          ],
        ),
        iosNotificationOptions: const IOSNotificationOptions(
          showNotification: true,
          playSound: false,
        ),
        foregroundTaskOptions: const ForegroundTaskOptions(
          interval: 1000,
          isOnceEvent: false,
          autoRunOnBoot: true,
          allowWakeLock: true,
          allowWifiLock: true,
        ),
      );
    }
  }

  void setTimerValue(int value) {
    timerValue = value;
    notifyListeners();
  }

  Future<void> startTimer() async {
    isStart = true;
    notifyListeners();
    startForegroundTask();
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

  void closeReceivePort() {
    _receivePort?.close();
    _receivePort = null;
  }

  bool _registerReceivePort(ReceivePort? newReceivePort) {
    if (newReceivePort == null) {
      return false;
    }

    closeReceivePort();

    _receivePort = newReceivePort;
    _receivePort?.listen((data) {
      if (data is int) {
        timerValue = data;
        if (!isStart) {
          isStart = true;
        }
        notifyListeners();
      } else if (data is String) {
        if (data == 'stop') {
          stopTimer();
        }
      }
    });

    return _receivePort != null;
  }

  Future<bool> startForegroundTask() async {
    await FlutterForegroundTask.saveData(key: 'timerValue', value: timerValue);

    // Register the receivePort before starting the service.
    final ReceivePort? receivePort = FlutterForegroundTask.receivePort;
    final bool isRegistered = _registerReceivePort(receivePort);
    if (!isRegistered) {
      print('Failed to register receivePort!');
      return false;
    }

    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        notificationTitle: '',
        notificationText: '',
        callback: startCallback,
      );
    }
  }
}
