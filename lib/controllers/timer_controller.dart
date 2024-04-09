import 'dart:async';
import 'dart:ui';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sleep_timer/utils/app_variables.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

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

  Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      notificationChannelId, // id
      'SleepTimer Foreground Service', // title
      importance: Importance.low, // importance must be at low or higher level
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: false,
        isForegroundMode: true,

        notificationChannelId: notificationChannelId,
        foregroundServiceNotificationId: notificationId,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,
      ),
    );
  }

  @pragma('vm:entry-point')
  static Future<void> onStart(ServiceInstance service) async {
    // Only available for flutter 3.0.0 and later
    DartPluginRegistrant.ensureInitialized();

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });

      service.on('stopService').listen((event) {
        service.stopSelf();
      });

      service.on('startTimer').listen((event) async {
        if (await service.isForegroundService()) {
          flutterLocalNotificationsPlugin.show(
            notificationId,
            "You're set!",
            '${event?['value']} minutes left',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                "sleep_timer_channel",
                'SleepTimer',
                ongoing: true,
                playSound: false,
                priority: Priority.low,
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
      });
    }
  }

  void setTimerValue(int value) {
    timerValue = value;
    notifyListeners();
  }

  Future<void> startTimer() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    isStart = true;
    notifyListeners();

    final isRunning = await FlutterBackgroundService().isRunning();
    if (!isRunning) {
      await FlutterBackgroundService().startService();
    }

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
    isStart = false;
    notifyListeners();
    FlutterBackgroundService().invoke("stopService");
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
    FlutterBackgroundService().invoke("startTimer", {"value": minutes});
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
