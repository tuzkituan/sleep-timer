import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
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

  void onClose() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(
          top: AppVariables.MAIN_PADDING / 4,
          bottom: AppVariables.MAIN_PADDING / 4,
        ),
        decoration: BoxDecoration(
          color:
              SettingsController.of(context).currentTheme.dialogBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: [
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 16,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(
                top: AppVariables.MAIN_PADDING,
                left: AppVariables.MAIN_PADDING,
                right: AppVariables.MAIN_PADDING,
                bottom: AppVariables.MAIN_PADDING,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...renderGroup(
                    title: "customize theme",
                    child: GridView.builder(
                      itemCount: themeKeys.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
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
                        String character =
                            ThemeCharacter[themeKeys[index]] ?? "";

                        return GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme!.primaryColor,
                              borderRadius: BorderRadius.circular(
                                AppVariables.MAIN_BORDER_RADIUS,
                              ),
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
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                              character,
                              width: double.infinity,
                            ),
                          ),
                          onTap: () => {
                            Provider.of<SettingsController>(context,
                                    listen: false)
                                .setTheme(
                              themeKeys[index],
                            ),
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> renderGroup(
      {required String title, String? subtitle, Widget? child}) {
    return [
      Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Colors.grey[400]!,
        ),
      ),
      if (subtitle != null) ...[
        const SizedBox(
          height: 12,
        ),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
      ],
      if (child != null) ...[
        const SizedBox(
          height: 16,
        ),
        child,
      ]
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
