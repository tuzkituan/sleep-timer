import 'package:flutter/material.dart';
import 'package:sleep_timer/screens/default_theme/default_theme.dart';

class SleepPage extends StatefulWidget {
  int timerValue;
  bool isStart;

  void Function() startTimer;
  void Function() stopTimer;
  void Function(int) onSliderChange;

  SleepPage(
      {Key? key,
      required this.isStart,
      required this.timerValue,
      required this.startTimer,
      required this.stopTimer,
      required this.onSliderChange})
      : super(key: key);

  @override
  _SleepPageState createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  Map<String, String> getTime(int timerValue) {
    int sec = timerValue % 60;
    int min = (timerValue / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return {
      "minute": minute,
      "second": second,
    };
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTheme(
      isStart: widget.isStart,
      timerValue: widget.timerValue,
      startTimer: () => widget.startTimer(),
      stopTimer: () => widget.stopTimer(),
      finalTime: getTime(widget.timerValue),
      onSliderChange: (int value) {
        widget.onSliderChange(value);
      },
    );
  }
}
