import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleep_timer/controllers/timer_controller.dart';
import 'package:sleep_timer/screens/default_theme/default_theme.dart';

class SleepPage extends StatefulWidget {
  @override
  _SleepPageState createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  @override
  Widget build(BuildContext context) {
    TimerController timerController =
        Provider.of<TimerController>(context, listen: true);
    var finalTime = timerController.getTime();

    return DefaultTheme(
      isStart: timerController.isStart,
      timerValue: timerController.timerValue,
      startTimer: () => timerController.startTimer(),
      stopTimer: () => timerController.stopTimer(),
      finalTime: finalTime,
      onSliderChange: (int value) {
        timerController.setTimerValue(value);
      },
    );
  }
}
