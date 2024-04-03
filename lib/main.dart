import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sleep_timer/components/app_title/app_title.dart';
import 'package:sleep_timer/components/settings_bottom_sheet/settings_bottom_sheet.dart';
import 'package:sleep_timer/controllers/notification_controller.dart';
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

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top]);

  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'sleep_timer_channel_group',
        channelKey: 'sleep_timer_channel',
        channelName: 'SleepTimer',
        channelDescription: 'Notification channel for basic tests',
        enableVibration: false,
        playSound: false,
      )
    ],
  );

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

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    requestNotification();
  }

  Future<void> requestNotification() async {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );

    print("[LOG]: REQUEST NOTIFICATION");
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TimerController timerController = Provider.of<TimerController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const AppTitle(),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 60,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SettingsBottomSheet();
                },
                isScrollControlled: true,
              ).whenComplete(() {
                timerController.resetTimer();
              });
            },
            icon: const Icon(
              Icons.settings_outlined,
              size: 20,
            ),
          ),
        ],
      ),
      body: SafeArea(top: true, child: SleepPage()),
    );
  }
}
