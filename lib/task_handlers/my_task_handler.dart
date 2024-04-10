import 'dart:isolate';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sleep_timer/utils/app_variables.dart';

class MyTaskHandler extends TaskHandler {
  SendPort? _sendPort;
  int timerValue = 0;

  // Called when the task is started.
  @override
  void onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;

    final value = await FlutterForegroundTask.getData<int>(key: 'timerValue');
    if (value != null) {
      timerValue = value;
    }
  }

  // Called every [interval] milliseconds in [ForegroundTaskOptions].
  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    if (timerValue > 0) {
      int min = (timerValue / 60).floor();
      FlutterForegroundTask.updateService(
        notificationTitle: "You're set!",
        notificationText: '$min minutes left',
      );
      timerValue--;
      sendPort?.send(timerValue);
    }

    if (timerValue == 0) {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());

      if (await session.setActive(true,
          avAudioSessionSetActiveOptions:
              const AVAudioSessionSetActiveOptions(1),
          androidAudioFocusGainType: AndroidAudioFocusGainType.gain)) {
        await session.setActive(false);
      }
      sendPort?.send("stop");
      FlutterForegroundTask.stopService();
    }
  }

  // Called when the notification button on the Android platform is pressed.
  @override
  void onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // FlutterForegroundTask.stopService();
  }

  // Called when the notification button on the Android platform is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    print("sendPort: $_sendPort");
    print('onNotificationButtonPressed >> $id');
    switch (id) {
      case "stop":
        _sendPort?.send("stop");
        FlutterForegroundTask.stopService();
        break;
      case "extend":
        var newValue = timerValue + AppVariables.EXTEND_TIME * 60;
        if (newValue > AppVariables.MAX_TIME * 60) {
          newValue = AppVariables.MAX_TIME * 60;
        }
        timerValue = newValue;
        Fluttertoast.showToast(
          msg: "${AppVariables.EXTEND_TIME} minutes extended",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        break;
      default:
    }
  }

  // Called when the notification itself on the Android platform is pressed.
  //
  // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
  // this function to be called.
  @override
  void onNotificationPressed() {
    // Note that the app will only route to "/resume-route" when it is exited so
    // it will usually be necessary to send a message through the send port to
    // signal it to restore state when the app is already started.
    // FlutterForegroundTask.launchApp("/resume-route");
    // _sendPort?.send('onNotificationPressed');
  }
}
