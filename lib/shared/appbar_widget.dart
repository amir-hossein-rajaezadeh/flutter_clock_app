import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/app_cubit.dart';
import '../utils/theme_config.dart';
import '../utils/theme_detector.dart';

Container buildAlarmListAppBar(
    BuildContext contex, void Function()? onClockPress) {
  return Container(
    height: 35,
    margin: const EdgeInsets.only(top: 55, left: 20, right: 20),
    child: onClockPress == null
        ? Align(
            alignment: Alignment.topLeft,
            child: ThemeSwitcher(
              clipper: const ThemeSwitcherCircleClipper(),
              builder: (context) {
                return GestureDetector(
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 4,
                            blurRadius: 6,
                            offset: const Offset(0, 0),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white),
                    child: Icon(
                      ThemeDetector().isDarkModeEnabled(context)
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode,
                      color: Colors.grey.shade700,
                      size: 22,
                    ),
                  ),
                  onTapDown: (details) {
                    ThemeSwitcher.of(context).changeTheme(
                      theme: ThemeModelInheritedNotifier.of(context)
                                  .theme
                                  .brightness ==
                              Brightness.light
                          ? darkTheme
                          : lightTheme,
                      offset: details.localPosition,
                    );
                  },
                );
              },
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onClockPress,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 4,
                          blurRadius: 6,
                          offset: const Offset(0, 0),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white),
                  child: const Icon(
                    CupertinoIcons.clock,
                    size: 22,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () =>
                    contex.read<AppCubit>().navigateToAlarmScreen(null, contex),
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 4,
                          blurRadius: 6,
                          offset: const Offset(0, 0),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white),
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
  );
}
