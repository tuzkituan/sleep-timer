import 'package:flutter/material.dart';
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
      period: const Duration(seconds: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            minute,
            style: const TextStyle(
              fontSize: 60,
              height: 0,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          const Text(
            "m",
            style: TextStyle(
              color: Colors.white,
              height: 1.6,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Text(
            second,
            style: const TextStyle(
              fontSize: 60,
              height: 0,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          const Text(
            "s",
            style: TextStyle(
              color: Colors.white,
              height: 1.6,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}
