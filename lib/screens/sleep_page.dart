import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleep_timer/controllers/timer_controller.dart';
import 'package:sleep_timer/screens/default_theme/default_theme.dart';

class SleepPage extends StatefulWidget {
  void Function() onStartService;
  void Function() onStopService;

  SleepPage(
      {Key? key, required this.onStopService, required this.onStartService})
      : super(key: key);

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
      startTimer: () {
        widget.onStartService();
        timerController.startTimer();
      },
      stopTimer: () {
        timerController.stopTimer();
        widget.onStopService();
      },
      finalTime: finalTime,
      onSliderChange: (int value) {
        timerController.setTimerValue(value);
      },
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:sleep_timer/screens/default_theme/default_theme.dart';

// class SleepPage extends StatefulWidget {
//   int timerValue;
//   bool isStart;

//   void Function() startTimer;
//   void Function() stopTimer;
//   void Function(int) onSliderChange;

//   SleepPage(
//       {Key? key,
//       required this.isStart,
//       required this.timerValue,
//       required this.startTimer,
//       required this.stopTimer,
//       required this.onSliderChange})
//       : super(key: key);

//   @override
//   _SleepPageState createState() => _SleepPageState();
// }

// class _SleepPageState extends State<SleepPage> {
//   Map<String, String> getTime(int timerValue) {
//     int sec = timerValue % 60;
//     int min = (timerValue / 60).floor();
//     String minute = min.toString().length <= 1 ? "0$min" : "$min";
//     String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
//     return {
//       "minute": minute,
//       "second": second,
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTheme(
//       isStart: widget.isStart,
//       timerValue: widget.timerValue,
//       startTimer: () => widget.startTimer(),
//       stopTimer: () => widget.stopTimer(),
//       finalTime: getTime(widget.timerValue),
//       onSliderChange: (int value) {
//         widget.onSliderChange(value);
//       },
//     );
//   }
// }
