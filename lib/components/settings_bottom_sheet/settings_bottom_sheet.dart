import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sleep_timer/themes.dart';
import 'package:sleep_timer/utils/app_variables.dart';

class SettingsBottomSheet extends StatefulWidget {
  SettingsBottomSheet({super.key});

  @override
  State<SettingsBottomSheet> createState() => _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends State<SettingsBottomSheet> {
  List<AppThemeKeys> themeKeys = AppThemeKeys.values.toList();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(AppVariables.MAIN_PADDING),
      decoration: BoxDecoration(
        color: AppTheme.of(context).currentTheme.dialogBackgroundColor,
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
          const Text(
            'customize theme',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          GridView.builder(
            itemCount: themeKeys.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              ThemeData? theme =
                  ThemeList[themeKeys[index]] ?? ThemeList[AppThemeKeys.theme0];
              bool isActive =
                  themeKeys[index] == AppTheme.of(context).currentThemeKey;
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
                    padding: const EdgeInsets.all(8),
                    child: SvgPicture.asset(
                      ThemeCharacter[themeKeys[index]]!,
                      width: double.infinity,
                    ),
                  ),
                ),
                onTap: () => {
                  Provider.of<AppTheme>(context, listen: false).setTheme(
                    themeKeys[index],
                  ),
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
