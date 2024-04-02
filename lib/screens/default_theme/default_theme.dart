import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleep_timer/components/action_button/action_button.dart';
import 'package:sleep_timer/components/main_timer_text/main_timer_text.dart';
import 'package:sleep_timer/components/time_slider/time_slider.dart';
import 'package:sleep_timer/controllers/settings_controller.dart';
import 'package:sleep_timer/utils/themes.dart';
import 'package:sleep_timer/utils/app_variables.dart';

class DefaultTheme extends StatelessWidget {
  final bool isStart;
  final int timerValue;
  final void Function() startTimer;
  final void Function() stopTimer;
  final Map<String, dynamic> finalTime;
  final void Function(int sliderValue) onSliderChange;

  DefaultTheme(
      {super.key,
      required this.isStart,
      required this.timerValue,
      required this.startTimer,
      required this.stopTimer,
      required this.finalTime,
      required this.onSliderChange});

  @override
  Widget build(BuildContext context) {
    SettingsController settingsController = SettingsController.of(context);
    AppThemeKeys currentTheme = settingsController.currentThemeKey;

    String character = ThemeCharacter[currentTheme]!;

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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: SvgPicture.asset(
                    character,
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                ),
                const Text(
                  "stop playing in",
                  style: TextStyle(
                    // color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                MainTimerText(
                  minute: finalTime["minute"],
                  second: finalTime["second"],
                  isStart: isStart,
                ),
              ],
            ),
          ),
          TimeSlider(
            isStart: isStart,
            timerValue: timerValue,
            onChange: onSliderChange,
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
