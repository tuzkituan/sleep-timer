import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sleep_timer/controllers/timer_controller.dart';

double numberFontSize = 80;

class TimerTextHorizontal extends StatelessWidget {
  const TimerTextHorizontal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TimerController timerController = Provider.of<TimerController>(context);
    bool isStart = timerController.isStart;
    var finalTime = timerController.getTime();
    String minute = finalTime["minute"]!;

    return Shimmer.fromColors(
      baseColor: isStart ? Colors.white30 : Colors.white70,
      highlightColor: isStart ? Colors.white70 : Colors.white70,
      enabled: isStart,
      period: const Duration(seconds: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            minute,
            style: GoogleFonts.kodeMono(
              fontSize: numberFontSize,
              height: 0,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            "m",
            style: GoogleFonts.kodeMono(
              color: Colors.white,
              height: 2.2,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
