import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:sleep_timer/components/app_title/app_title.dart';
import 'package:sleep_timer/components/settings_bottom_sheet/settings_bottom_sheet.dart';
import 'package:sleep_timer/screens/sleep_page.dart';
import 'package:sleep_timer/task_handlers/foreground_task.dart';
import 'package:sleep_timer/utils/app_variables.dart';

@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(ForegroundTask());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int timerValue = AppVariables.INIT_TIME * 60;
  bool isStart = false;
  ReceivePort? _receivePort;
  static const notificationChannelId = 'my_foreground';
  static const notificationId = 145;

  void stopTimer() async {
    setState(() {
      isStart = false;
    });
    closeReceivePort();
    FlutterForegroundTask.stopService();
  }

  void closeReceivePort() {
    _receivePort?.close();
    _receivePort = null;
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

  bool _registerReceivePort(ReceivePort? newReceivePort) {
    if (newReceivePort == null) {
      return false;
    }

    closeReceivePort();

    _receivePort = newReceivePort;
    _receivePort?.listen((data) {
      if (data is int) {
        setState(() {
          timerValue = data;
          if (!isStart) {
            isStart = true;
          }
        });
      } else if (data is String) {
        if (data == 'stop') {
          stopTimer();
        }
      }
    });

    return _receivePort != null;
  }

  void initForegroundTask() async {
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

  Future<void> _requestPermissionForAndroid() async {
    if (!Platform.isAndroid) {
      return;
    }

    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }

    final NotificationPermission notificationPermissionStatus =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermissionStatus != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _requestPermissionForAndroid();
      initForegroundTask();
      if (await FlutterForegroundTask.isRunningService) {
        final newReceivePort = FlutterForegroundTask.receivePort;
        _registerReceivePort(newReceivePort);
      }
    });
  }

  @override
  void dispose() {
    closeReceivePort();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WithForegroundTask(
      child: Scaffold(
        appBar: AppBar(
          title: const AppTitle(),
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.transparent,
          toolbarHeight: 50,
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SettingsBottomSheet();
                  },
                  isScrollControlled: true,
                );
              },
              icon: const Icon(
                Icons.settings,
                size: 20,
              ),
            ),
          ],
        ),
        body: SafeArea(
          top: true,
          child: SleepPage(
            isStart: isStart,
            onSliderChange: (val) {
              setState(() {
                timerValue = val;
              });
            },
            startTimer: () {
              setState(() {
                isStart = true;
              });
              startForegroundTask();
            },
            stopTimer: stopTimer,
            timerValue: timerValue,
          ),
        ),
      ),
    );
  }
}
