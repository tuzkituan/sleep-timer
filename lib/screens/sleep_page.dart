import 'dart:async';
import 'package:volume_control/volume_control.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';

class SleepPage extends StatefulWidget {
  @override
  _SleepPageState createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  final baseColor = Colors.pink[400];

  int INIT_TIME = 900; // 15 minutes
  late Timer _timer;
  bool isStart = false;
  // late int timerValue;
  late int timerValue;

  late VolumeControl volumeController;
  late double currentVolume;

  @override
  void initState() {
    super.initState();
    // timerValue = 15; // 15 minutes
    timerValue = INIT_TIME;
  }

  void _updateLabels(int init, int end, int l) {
    setState(() {
      // timerValue = end;
      timerValue = end * 60;
    });
  }

  void startTimer() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());

    setState(() {
      isStart = true;
    });
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) async {
        if (timerValue == 0) {
          if (await session.setActive(true,
              avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions(1),
              androidAudioFocusGainType: AndroidAudioFocusGainType.gain)) {
            print("end");
            await session.setActive(false);
          } else {}

          setState(() {
            timer.cancel();
            timerValue = INIT_TIME;
            isStart = false;
          });
        } else {
          print('value: ' + timerValue.toString());
          setState(() {
            timerValue--;
          });
        }
      },
    );
  }

  void stopTimer() {
    _timer.cancel();
    setState(() {
      timerValue = INIT_TIME;
      isStart = false;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  Widget _renderInside() {
    String renderText = isStart
        ? formattedTime(timeInSecond: timerValue)
        : (timerValue ~/ 60).toString();

    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            renderText,
            style: TextStyle(
              fontSize: isStart ? 70.0 : 110,
              color: baseColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 1,
          ),
          Text(
            isStart ? 'have a nice dream!' : 'minutes',
            style: const TextStyle(fontSize: 20.0, color: Colors.white38),
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
                  timerValue ~/ 60,
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
