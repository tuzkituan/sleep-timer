import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sleep_timer/utils/app_colors.dart';
import 'package:sleep_timer/utils/app_variables.dart';

class SleepPage extends StatefulWidget {
  @override
  _SleepPageState createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  int MAX_TIME = 3600;
  int INIT_TIME = 900; // 15 minutes

  late Timer _timer;
  bool isStart = false;
  // late int timerValue;
  late int timerValue;

  @override
  void initState() {
    super.initState();
    timerValue = INIT_TIME;
  }

  void _updateLabels(int init, int end, int l) {
    setState(() {
      timerValue = end * 60;
    });
  }

  void startTimer() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    setState(() {
      isStart = true;
    });
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) async {
        if (timerValue == 0) {
          if (await session.setActive(true,
              avAudioSessionSetActiveOptions:
                  const AVAudioSessionSetActiveOptions(1),
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
    return "$minute:$second";
  }

  @override
  Widget build(BuildContext context) {
    String renderText = formattedTime(timeInSecond: timerValue);

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
          Center(
            child: Text(
              "SLEEP TIMER",
              style: GoogleFonts.archivo(fontSize: 14, letterSpacing: 7)
                  .copyWith(color: Colors.white),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: SvgPicture.asset(
                    'assets/sleep_man.svg',
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -40),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Column(
                      children: [
                        isStart
                            ? Shimmer.fromColors(
                                baseColor: Colors.white30,
                                highlightColor: Colors.white70,
                                enabled: isStart,
                                period: const Duration(seconds: 2),
                                child: Text(
                                  renderText,
                                  style: TextStyle(
                                    fontSize: isStart ? 70 : 44,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                renderText,
                                style: TextStyle(
                                  fontSize: isStart ? 70 : 44,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                        Text(
                          isStart ? "have a good night!" : "",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          isStart
              ? Container(
                  height: AppVariables.SLIDER_HEIGHT,
                )
              : Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white10,
                  ),
                  height: AppVariables.SLIDER_HEIGHT,
                  child: renderTimeSlider(),
                ),
          const SizedBox(height: 24),
          _renderStartButton()
        ],
      ),
    );
  }

  Widget renderTimeSlider() {
    double screenWidth = MediaQuery.of(context).size.width;
    double sliderWidth = screenWidth - AppVariables.MAIN_PADDING * 2;

    return GestureDetector(
      onHorizontalDragStart: (details) {
        if (!isStart) {
          var x = details.localPosition.dx / sliderWidth;
          if (x >= 0 && x <= 1) {
            setState(() {
              timerValue = (x * MAX_TIME).round();
            });
          }
        }
      },
      onHorizontalDragUpdate: (details) {
        if (!isStart) {
          var x = details.localPosition.dx / sliderWidth;
          if (x >= 0 && x <= 1) {
            setState(() {
              timerValue = (x * MAX_TIME).round();
            });
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
              color: Colors.blue[800],
              width: (timerValue / MAX_TIME) * sliderWidth,
              height: AppVariables.SLIDER_HEIGHT,
            ),
          ),
          Positioned(
            left: (timerValue / MAX_TIME) * sliderWidth - 4,
            top: 32,
            bottom: 32,
            child: Container(
              width: 8,
              height: 15,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(4),
                  ),
                  border: Border.all(
                    color: AppColors.primaryColor,
                    width: 3,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderStartButton() {
    return ElevatedButton(
      onPressed: isStart == true ? stopTimer : startTimer,
      style: ElevatedButton.styleFrom(
          backgroundColor:
              isStart ? Colors.red[900]!.withOpacity(0.7) : Colors.transparent,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.white24),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 4),
          Text(
            (isStart ? "stop" : "start").toUpperCase(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
