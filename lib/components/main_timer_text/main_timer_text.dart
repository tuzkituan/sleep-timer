import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

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
      period: const Duration(seconds: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            minute,
            style: GoogleFonts.kodeMono(
              fontSize: 100,
              height: 0,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            "minutes".toUpperCase(),
            style: GoogleFonts.kodeMono(
              color: Colors.white,
              // height: 1.2,
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
