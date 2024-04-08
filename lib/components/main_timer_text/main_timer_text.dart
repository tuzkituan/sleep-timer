import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

double numberFontSize = 64;

class MainTimerText extends StatelessWidget {
  final String minute;
  final String second;
  final bool isStart;

  const MainTimerText(
      {super.key,
      required this.minute,
      required this.second,
      required this.isStart});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: isStart ? Colors.white30 : Colors.white70,
      highlightColor: isStart ? Colors.white70 : Colors.white70,
      enabled: isStart,
      period: const Duration(seconds: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
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
              height: 2,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Text(
            second,
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
            "s",
            style: GoogleFonts.kodeMono(
              color: Colors.white,
              height: 2,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}
