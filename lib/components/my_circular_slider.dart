import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:sleep_timer/utils/app_variables.dart';
import 'package:sleep_timer/utils/functions.dart';

class MyCircularSlider extends StatelessWidget {
  final bool isStart;
  final double value;
  final void Function(double value) onChange;
  final Widget child;

  const MyCircularSlider({
    super.key,
    required this.isStart,
    required this.value,
    required this.onChange,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    num sec = (value * 60) % 60;

    return SleekCircularSlider(
      appearance: CircularSliderAppearance(
        customWidths: CustomSliderWidths(
          trackWidth: 12,
          progressBarWidth: 12,
          shadowWidth: 12,
        ),
        customColors: CustomSliderColors(
          dotColor: Colors.white.withOpacity(0.8),
          trackColor: HexColor('#98DBFC').withOpacity(0.3),
          progressBarColor: HexColor('#6DCFFF'),
          shadowColor: HexColor('#98DBFC'),
          shadowStep: 14.0,
          shadowMaxOpacity: 0,
        ),
        startAngle: 270,
        angleRange: 360,
        size: 320.0,
        animationEnabled: true,
      ),
      min: 0,
      max: AppVariables.MAX_TIME.toDouble(),
      initialValue: value,
      onChange: (value) {
        onChange(value);
      },
      innerWidget: (double value) {
        return Align(
          alignment: Alignment.center,
          child: isStart
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SleekCircularSlider(
                    appearance: CircularSliderAppearance(
                      customWidths: CustomSliderWidths(
                        trackWidth: 2,
                        progressBarWidth: 2,
                        shadowWidth: 2,
                      ),
                      customColors: CustomSliderColors(
                        dotColor: Colors.white.withOpacity(0.8),
                        trackColor: Colors.cyan.withOpacity(0.3),
                        progressBarColor: Colors.cyan,
                        shadowColor: Colors.cyan,
                        shadowStep: 14.0,
                        shadowMaxOpacity: 0,
                      ),
                      startAngle: 270,
                      angleRange: 360,
                      size: 290.0,
                      animationEnabled: false,
                    ),
                    min: 0,
                    max: AppVariables.MAX_TIME.toDouble(),
                    initialValue: sec.toDouble(),
                    innerWidget: (double value) {
                      return child;
                    },
                  ),
                )
              : child,
        );
      },
    );
  }
}
