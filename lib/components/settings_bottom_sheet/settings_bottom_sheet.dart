import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sleep_timer/components/action_button/action_button.dart';
import 'package:sleep_timer/controllers/settings_controller.dart';
import 'package:sleep_timer/utils/app_variables.dart';
import 'package:sleep_timer/utils/themes.dart';

class SettingsBottomSheet extends StatefulWidget {
  SettingsBottomSheet({super.key});

  @override
  State<SettingsBottomSheet> createState() => _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends State<SettingsBottomSheet> {
  List<AppThemeKeys> themeKeys = AppThemeKeys.values.toList();

  void onMaxTimeChanged(int value) {
    SettingsController settingsController = SettingsController.of(context);
    if (value.round() >= AppVariables.INIT_TIME) {
      settingsController.maxTime = value.round();
    }
  }

  @override
  Widget build(BuildContext context) {
    SettingsController settingsController = SettingsController.of(context);

    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(
          top: AppVariables.MAIN_PADDING / 2,
          left: AppVariables.MAIN_PADDING,
          right: AppVariables.MAIN_PADDING,
          bottom: AppVariables.MAIN_PADDING * 1.5,
        ),
        decoration: BoxDecoration(
          color:
              SettingsController.of(context).currentTheme.dialogBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 4,
                width: MediaQuery.of(context).size.width * 0.12,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Row(
              children: [
                Icon(
                  Icons.settings_outlined,
                  size: 20,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'SETTINGS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            ...renderGroup(
              title: "customize theme",
              child: GridView.builder(
                itemCount: themeKeys.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  ThemeData? theme = ThemeList[themeKeys[index]] ??
                      ThemeList[AppThemeKeys.theme0];
                  bool isActive = themeKeys[index] ==
                      SettingsController.of(context).currentThemeKey;
                  String character = ThemeCharacter[themeKeys[index]] ?? "";

                  return GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        border: isActive
                            ? Border.all(
                                color: Colors.white,
                                width: 2,
                              )
                            : Border.all(
                                color: Colors.transparent,
                                width: 2,
                              ),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme!.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          character,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    onTap: () => {
                      Provider.of<SettingsController>(context, listen: false)
                          .setTheme(
                        themeKeys[index],
                      ),
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            ...renderGroup(
              title: "max time",
              subtitle: "${settingsController.maxTime} minutes",
              child: SliderTheme(
                data: SliderThemeData(
                  trackShape: CustomTrackShape(),
                  trackHeight: 1,
                ),
                child: Slider(
                  value: settingsController.maxTime.toDouble(),
                  max: 120,
                  min: AppVariables.INIT_TIME.toDouble(),
                  inactiveColor:
                      SettingsController.of(context).currentTheme.disabledColor,
                  activeColor: SettingsController.of(context)
                      .currentTheme
                      .indicatorColor,
                  thumbColor: SettingsController.of(context)
                      .currentTheme
                      .indicatorColor,
                  onChanged: (double value) {
                    onMaxTimeChanged(value.round());
                  },
                ),
              ),
            ),
            // ...renderGroup(title: "about me", subtitle: "Lewis Nguyen"),
            ...renderGroup(
              title: "extend time",
              subtitle: "5 minutes",
              child: SliderTheme(
                data: SliderThemeData(
                  trackShape: CustomTrackShape(),
                  trackHeight: 1,
                ),
                child: Slider(
                  value: 5,
                  max: 60,
                  min: 5,
                  inactiveColor:
                      SettingsController.of(context).currentTheme.disabledColor,
                  activeColor: SettingsController.of(context)
                      .currentTheme
                      .indicatorColor,
                  thumbColor: SettingsController.of(context)
                      .currentTheme
                      .indicatorColor,
                  onChanged: (double value) {},
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ActionButton(
              title: "Done",
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> renderGroup(
      {required String title, String? subtitle, Widget? child}) {
    return [
      Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      if (subtitle != null) ...[
        const SizedBox(
          height: 4,
        ),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
      ],
      const SizedBox(
        height: 12,
      ),
      child ?? Container(),
    ];
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
