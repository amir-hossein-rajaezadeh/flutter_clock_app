import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';

class ThemeDetector {
  bool isDarkModeEnabled(BuildContext context) {
    int brightness =
        ThemeModelInheritedNotifier.of(context).theme.brightness.index;

    bool isDarkModeEnabled = brightness == 0;

    return isDarkModeEnabled;
  }
}
