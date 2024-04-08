import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

class BackgroundController extends ChangeNotifier {
  // this will be used as notification channel id
  static const notificationChannelId = 'my_foreground';

// this will be used for notification id, So you can update your custom notification with this id.
  static const notificationId = 888;

  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      notificationChannelId, // id
      'SleepTimer', // title
      description:
          'This channel is used for important notifications.', // description
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
        autoStart: true,
        isForegroundMode: true,

        notificationChannelId:
            notificationChannelId, // this must match with notification channel you created above.
        foregroundServiceNotificationId: notificationId,
      ),
      iosConfiguration: IosConfiguration(),
    );
  }

  static Future<void> onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();
    print("[FOREGROUND SERVICE] started");
    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        // print("[FOREGROUND SERVICE] setAsForeground");
        service.setAsForegroundService();
      });
      service.on('setAsBackground').listen((event) {
        // print("[FOREGROUND SERVICE] setAsBackground");
        service.setAsBackgroundService();
      });
    }
    service.on("startTimer").listen((event) {
      // print("[FOREGROUND SERVICE] startTimer " + event.toString());
      FlutterLocalNotificationsPlugin().show(
        notificationId,
        "You're set!",
        '${event!["value"]} minutes left',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            notificationChannelId,
            'SleepTimer',
            icon: 'ic_bg_service_small',
            ongoing: true,
          ),
        ),
      );
    });

    service.on('stopTimer').listen((event) {
      // print("[FOREGROUND SERVICE] stopTimer");
      FlutterLocalNotificationsPlugin().cancelAll();
    });
    service.on('stopService').listen((event) {
      // print("[FOREGROUND SERVICE] stopService");
      service.stopSelf();
    });
  }
}
