import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleep_timer/controllers/settings_controller.dart';
import 'package:sleep_timer/controllers/timer_controller.dart';
import 'package:sleep_timer/screens/circular_theme/circular_theme.dart';
import 'package:sleep_timer/screens/default_theme/default_theme.dart';
import 'package:sleep_timer/utils/layouts.dart';

class SleepPage extends StatefulWidget {
  final void Function() onStartService;
  final void Function() onStopService;

  const SleepPage(
      {super.key, required this.onStopService, required this.onStartService});

  @override
  _SleepPageState createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  int theme = 1;

  @override
  Widget build(BuildContext context) {
    TimerController timerController =
        Provider.of<TimerController>(context, listen: true);
    var finalTime = timerController.getTime();

    AppLayoutKeys currentLayoutKey =
        Provider.of<SettingsController>(context).currentLayoutKey;
    print("currentLayoutKey: $currentLayoutKey");

    return Container(
      child: currentLayoutKey == AppLayoutKeys.circular
          ? CircularTheme(
              isStart: timerController.isStart,
              timerValue: timerController.timerValue,
              startTimer: () {
                widget.onStartService();
                timerController.startTimer();
              },
              stopTimer: () {
                timerController.stopTimer();
                widget.onStopService();
              },
              finalTime: finalTime,
              onSliderChange: (double value) {
                timerController.setTimerValue(value);
              },
            )
          : DefaultTheme(
              isStart: timerController.isStart,
              timerValue: timerController.timerValue,
              startTimer: () {
                widget.onStartService();
                timerController.startTimer();
              },
              stopTimer: () {
                timerController.stopTimer();
                widget.onStopService();
              },
              finalTime: finalTime,
              onSliderChange: (double value) {
                timerController.setTimerValue(value);
              },
            ),
    );
  }
}
