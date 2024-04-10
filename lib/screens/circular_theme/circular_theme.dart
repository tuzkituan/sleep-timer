import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:sleep_timer/components/action_button/action_button.dart';
import 'package:sleep_timer/components/main_timer_text/main_timer_text.dart';
import 'package:sleep_timer/utils/app_variables.dart';
import 'package:sleep_timer/utils/functions.dart';

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
                  child: SleekCircularSlider(
                    appearance: CircularSliderAppearance(
                      customWidths: CustomSliderWidths(
                        trackWidth: isStart ? 0 : 5,
                        progressBarWidth: isStart ? 0 : 16,
                        shadowWidth: isStart ? 0 : 20,
                      ),
                      customColors: isStart
                          ? CustomSliderColors(
                              trackColor: Colors.transparent,
                              progressBarColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shadowMaxOpacity: 0.0,
                            )
                          : CustomSliderColors(
                              dotColor: Colors.white.withOpacity(0.8),
                              trackColor: HexColor('#98DBFC').withOpacity(0.3),
                              progressBarColor: HexColor('#6DCFFF'),
                              shadowColor: HexColor('#98DBFC'),
                              shadowStep: 14.0,
                              shadowMaxOpacity: 0.1,
                            ),
                      startAngle: 270,
                      angleRange: 360,
                      size: 320.0,
                      animationEnabled: true,
                    ),
                    min: 0,
                    max: AppVariables.MAX_TIME,
                    initialValue: (timerValue / 60),
                    onChange: (value) {
                      if (!isStart) {
                        onSliderChange((value.floor() * 60).toDouble());
                      }
                    },
                    innerWidget: (double value) {
                      return Align(
                        alignment: Alignment.center,
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
                            MainTimerText(
                              minute: finalTime["minute"],
                              second: finalTime["second"],
                              isStart: isStart,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
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
