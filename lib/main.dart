import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sleep_timer/components/app_title/app_title.dart';
import 'package:sleep_timer/components/settings_bottom_sheet/settings_bottom_sheet.dart';
import 'package:sleep_timer/controllers/settings_controller.dart';
import 'package:sleep_timer/controllers/timer_controller.dart';
import 'package:sleep_timer/screens/sleep_page.dart';
import 'package:sleep_timer/services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
  ));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [
    SystemUiOverlay.top,
  ]);

  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => settingsController,
        ),
        ChangeNotifierProvider(
          create: (ctx) => TimerController(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SLEEP TIMER',
      themeMode: ThemeMode.dark,
      darkTheme:
          SettingsController.of(context, listen: true).currentTheme.copyWith(
                textTheme: GoogleFonts.archivoTextTheme().copyWith(
                  bodyLarge: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.archivo().fontFamily,
                  ),
                  bodyMedium: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.archivo().fontFamily,
                  ),
                ),
              ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    initNotification();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.detached) {
      FlutterLocalNotificationsPlugin().cancelAll();
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      exit(0);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> initNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("ic_notification");
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse res) {
      if (res.actionId == "stop") {
        onNotificationStopClick();
      }
      if (res.actionId == "extend") {
        onNotificationExtendClick();
      }
    });
  }

  void onNotificationStopClick() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      TimerController timerController =
          Provider.of<TimerController>(context, listen: false);
      timerController.stopTimer();
    });
  }

  void onNotificationExtendClick() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      TimerController timerController =
          Provider.of<TimerController>(context, listen: false);
      timerController.extendTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SafeArea(top: true, child: SleepPage()),
    );
  }
}
