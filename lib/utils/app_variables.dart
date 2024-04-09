import 'package:flutter/material.dart';

class AppVariables {
  static const String APP_NAME = "Sleep Timer";
  static const String APP_VERSION = "1.0.0";

  static const double MAIN_PADDING = 24;
  static const double SLIDER_HEIGHT = 70;
  static const double MAIN_BORDER_RADIUS = 4;

  static const int MAX_TIME = 120;
  static const int INIT_TIME = 30;
  static const int EXTEND_TIME = 5;

  static final navigatorKey = GlobalKey<NavigatorState>();
}
