import 'package:flutter/material.dart';
import 'package:sleep_timer/utils/app_colors.dart';
import 'package:sleep_timer/utils/app_variables.dart';

class TimeSlider extends StatelessWidget {
  late bool isStart;
  late int timerValue;
  late Function onChange;

  TimeSlider({
    super.key,
    required this.isStart,
    required this.timerValue,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double sliderWidth = screenWidth - AppVariables.MAIN_PADDING * 2;

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.sliderColor.withOpacity(0.3),
      ),
      height: AppVariables.SLIDER_HEIGHT,
      child: GestureDetector(
        onHorizontalDragStart: (details) {
          if (!isStart) {
            var x = details.localPosition.dx / sliderWidth;
            if (x >= 0 && x <= 1) {
              onChange((x * AppVariables.MAX_TIME).round());
            }
          }
        },
        onHorizontalDragUpdate: (details) {
          if (!isStart) {
            var x = details.localPosition.dx / sliderWidth;
            if (x >= 0 && x <= 1) {
              onChange((x * AppVariables.MAX_TIME).round());
            }
          }
        },
        child: Stack(
          children: [
            Container(
              width: sliderWidth,
              height: AppVariables.SLIDER_HEIGHT,
              color: Colors.transparent,
              child: Container(),
            ),
            Positioned(
              child: Container(
                color: AppColors.sliderColor,
                width: (timerValue / AppVariables.MAX_TIME) * sliderWidth,
                height: AppVariables.SLIDER_HEIGHT,
              ),
            ),
            Positioned(
              left: (timerValue / AppVariables.MAX_TIME) * sliderWidth - 6,
              top: AppVariables.SLIDER_HEIGHT / 3.5,
              bottom: AppVariables.SLIDER_HEIGHT / 3.5,
              child: Container(
                width: 12,
                // height: 15,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(99),
                  ),
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.9),
                    width: 3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
