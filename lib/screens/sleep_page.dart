import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';

class SleepPage extends StatefulWidget {
  @override
  _SleepPageState createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  final baseColor = Colors.teal[600];

  late Timer _timer;
  bool isStart = false;
  late int timerValue;
  late int timerValueAsSecond;

  @override
  void initState() {
    super.initState();
    timerValue = 15; // 15 minutes
    timerValueAsSecond = 15 * 60;
  }

  void _updateLabels(int init, int end, int l) {
    setState(() {
      timerValue = end;
      timerValueAsSecond = end * 60;
    });
  }

  void startTimer() {
    setState(() {
      isStart = true;
    });
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) async {
        if (timerValueAsSecond == 0) {
          setState(() {
            timer.cancel();
            timerValue = 0;
            isStart = false;
          });
        } else {
          print('seconds: ' + timerValueAsSecond.toString());
          print('minutes: ' + (timerValueAsSecond ~/ 60 + 1).toString());
          setState(() {
            timerValueAsSecond--;
            timerValue = (timerValueAsSecond ~/ 60) + 1;
          });
        }
      },
    );
  }

  void stopTimer() {
    _timer.cancel();
    setState(() {
      isStart = false;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget _renderInside() {
    return Padding(
      padding: const EdgeInsets.all(42.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            (timerValue).toString(),
            style: TextStyle(
              fontSize: 110.0,
              color: baseColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 1,
          ),
          const Text(
            'minutes',
            style: TextStyle(fontSize: 20.0, color: Colors.white38),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isStart == true
              ? SizedBox(
                  height: 270.0,
                  width: 270.0,
                  child: _renderInside(),
                )
              : SingleCircularSlider(
                  60,
                  timerValue,
                  height: 270.0,
                  width: 270.0,
                  primarySectors: isStart ? 0 : 4,
                  secondarySectors: 0,
                  baseColor: isStart ? Colors.black : Colors.white12,
                  selectionColor: isStart ? Colors.black : baseColor,
                  handlerColor: Colors.white,
                  handlerOutterRadius: 12.0,
                  onSelectionChange: _updateLabels,
                  showHandlerOutter: false,
                  sliderStrokeWidth: 8.0,
                  child: _renderInside(),
                ),
          ElevatedButton(
            onPressed: isStart == true ? stopTimer : startTimer,
            style: ElevatedButton.styleFrom(
              backgroundColor: baseColor,
            ),
            child: isStart == true
                ? const Icon(Icons.stop)
                : const Icon(Icons.play_arrow),
          ),
        ],
      ),
    );
  }
}
