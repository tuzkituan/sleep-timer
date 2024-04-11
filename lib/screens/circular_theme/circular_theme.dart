import 'package:flutter/material.dart';
import 'package:sleep_timer/components/action_button.dart';
import 'package:sleep_timer/components/my_circular_slider.dart';
import 'package:sleep_timer/components/timer_text_vertical.dart';
import 'package:sleep_timer/utils/app_variables.dart';

class CircularTheme extends StatelessWidget {
  final bool isStart;
  final double timerValue;
  final void Function() startTimer;
  final void Function() stopTimer;
  final Map<String, dynamic> finalTime;
  final void Function(double sliderValue) onSliderChange;

  CircularTheme({
    super.key,
    required this.isStart,
    required this.timerValue,
    required this.startTimer,
    required this.stopTimer,
    required this.finalTime,
    required this.onSliderChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppVariables.MAIN_PADDING,
        right: AppVariables.MAIN_PADDING,
        bottom: AppVariables.MAIN_PADDING,
        top: AppVariables.MAIN_PADDING,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: MyCircularSlider(
                  value: (timerValue / 60),
                  isStart: isStart,
                  onChange: (value) {
                    if (!isStart) {
                      onSliderChange((value * 60).toDouble());
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "stop playing in".toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[400]!,
                          letterSpacing: 1.4,
                        ),
                      ),
                      const TimerTextVertical()
                    ],
                  ),
                ),
              )
            ],
          )),
          const SizedBox(height: 48),
          ActionButton(
            title: (isStart ? "stop" : "start").toUpperCase(),
            isDanger: isStart,
            onPressed: isStart == true ? stopTimer : startTimer,
          ),
        ],
      ),
    );
  }
}
