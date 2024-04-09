import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sleep_timer/controllers/settings_controller.dart';
import 'package:sleep_timer/controllers/timer_controller.dart';
import 'package:sleep_timer/home_page.dart';
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
      home: const HomePage(),
    );
  }
}
