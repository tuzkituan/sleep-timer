import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sleep_timer/utils/app_variables.dart';

class TimerController extends ChangeNotifier {
  // this will be used as notification channel id
  static const notificationChannelId = 'my_foreground';

  // this will be used for notification id, So you can update your custom notification with this id.
  static const notificationId = 3;

  Timer? _timer;
  bool isStart = false;
  late int timerValue = AppVariables.INIT_TIME * 60;
  bool needReset = false;
  int currentMinute = -1;

// flutterLocalNotificationsPlugin.show(
//             notificationId,
//             "You're set!",
//             '${event?['value']} minutes left',
//             const NotificationDetails(
//               android: AndroidNotificationDetails(
//                 "sleep_timer_channel",
//                 'Sleep Timer',
//                 ongoing: true,
//                 playSound: false,
//                 priority: Priority.low,
//                 actions: [
//                   AndroidNotificationAction(
//                     'stop',
//                     'Stop',
//                     showsUserInterface: true,
//                   ),
//                   AndroidNotificationAction(
//                     'extend',
//                     'Extend',
//                     showsUserInterface: true,
//                   ),
//                 ],
//               ),
//             ),
//           );

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
          currentMinute = -1;
          isStart = false;

          notifyListeners();
        } else {
          int min = (timerValue / 60).floor();
          timerValue--;
          if (min != currentMinute) {
            currentMinute = min;
            showNotification(
              minutes: min,
            );
          }
          notifyListeners();
        }
      },
    );
  }

  void stopTimer() async {
    if (_timer != null) {
      _timer?.cancel();
    }
    currentMinute = -1;
    isStart = false;
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
    // FlutterBackgroundService().invoke("startTimer", {"value": minutes});
  }

  Future<void> extendTimer() async {
    var newValue = timerValue + 5 * 60;
    if (newValue > AppVariables.MAX_TIME * 60) {
      newValue = AppVariables.MAX_TIME * 60;
    }
    timerValue = newValue;
    Fluttertoast.showToast(
      msg: "5 minutes extended",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    notifyListeners();
  }
}
