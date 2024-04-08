import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BackgroundController extends ChangeNotifier {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const notificationChannelId = 'my_foreground';
  static const notificationId = 3;

  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      notificationChannelId, // id
      'SleepTimer', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.low, // importance must be at low or higher level
    );

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
        autoStartOnBoot: false,
      ),
      iosConfiguration: IosConfiguration(),
    );
  }

  @pragma('vm:entry-point')
  static Future<void> onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();
    print("[FOREGROUND SERVICE] started");
    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });
      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
      if (await service.isForegroundService()) {
        service.on("startTimer").listen((event) async {
          flutterLocalNotificationsPlugin.show(
            notificationId,
            "You're set!",
            '${event!["value"]} minutes left',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                notificationChannelId,
                'SleepTimer',
                ongoing: true,
                playSound: false,
                actions: [
                  AndroidNotificationAction(
                    'stop',
                    'Stop',
                    showsUserInterface: true,
                  ),
                ],
              ),
            ),
          );
        });
        service.on('stopTimer').listen((event) async {
          await flutterLocalNotificationsPlugin.cancelAll();
        });
      }
    }
    service.on('stopService').listen((event) {
      service.invoke("stopTimer");
      service.stopSelf();
    });
  }
}
