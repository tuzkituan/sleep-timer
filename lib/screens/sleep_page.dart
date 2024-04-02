import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sleep_timer/screens/default_theme/default_theme.dart';
import 'package:sleep_timer/utils/app_variables.dart';

class SleepPage extends StatefulWidget {
  @override
  _SleepPageState createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late Timer _timer;
  bool isStart = false;
  // late int timerValue;
  late int timerValue;
  late int currentNotificationId = 0;

  @override
  void initState() {
    super.initState();
    timerValue = AppVariables.INIT_TIME * 60;
  }

  void _updateLabels(int init, int end, int l) {
    setState(() {
      timerValue = end * 60;
    });
  }

  Future<void> _showNotificationWithActions({int minutes = 0}) async {
    // AndroidNotificationDetails androidNotificationDetails =
    //     const AndroidNotificationDetails(
    //   "sleep_timer_id",
    //   'SleepTimer',
    //   channelDescription: 'your channel description',
    //   // importance: Importance.high,
    //   // priority: Priority.high,
    //   playSound: false,
    //   ticker: 'ticker',
    //   ongoing: true,
    //   actions: <AndroidNotificationAction>[
    //     AndroidNotificationAction('id_1', 'Stop'),
    //     AndroidNotificationAction('id_2', 'Extend'),
    //   ],
    // );
    // NotificationDetails notificationDetails =
    //     NotificationDetails(android: androidNotificationDetails);
    // await flutterLocalNotificationsPlugin.show(0, "You're set",
    //     '${minutes.toString()} minutes remaining', notificationDetails);
  }

  void startTimer() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    setState(() {
      isStart = true;
    });
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
          } else {}

          flutterLocalNotificationsPlugin.cancelAll();
          setState(() {
            timer.cancel();
            currentNotificationId = 0;
            timerValue = AppVariables.INIT_TIME * 60;
            isStart = false;
          });
        } else {
          int min = (timerValue / 60).floor();
          setState(() {
            timerValue--;
          });
          if (currentNotificationId != min) {
            _showNotificationWithActions(
              minutes: min,
            );
            setState(() {
              currentNotificationId = min;
            });
          }
        }
      },
    );
  }

  void stopTimer() {
    _timer.cancel();
    flutterLocalNotificationsPlugin.cancelAll();

    setState(() {
      isStart = false;
      currentNotificationId = 0;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return {"minute": minute, "second": second};
  }

  @override
  Widget build(BuildContext context) {
    var finalTime = formattedTime(timeInSecond: timerValue);

    return DefaultTheme(
      isStart: isStart,
      timerValue: timerValue,
      startTimer: startTimer,
      stopTimer: stopTimer,
      finalTime: finalTime,
      onSliderChange: (int value) {
        setState(
          () {
            timerValue = value;
          },
        );
      },
    );
  }
}
