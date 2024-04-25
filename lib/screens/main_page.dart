import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import 'alarm_list_page.dart';
import 'clock_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    const Tab(
      text: "Clock",
      icon: Icon(CupertinoIcons.clock, size: 35),
    ),
    const Tab(
      text: "RECORDS",
      icon: Icon(CupertinoIcons.list_bullet, size: 35),
    ),
    const Tab(
      text: "Settings",
      icon: Icon(CupertinoIcons.settings, size: 35),
    ),
  ];

  late TabController _tabController;
  static StreamSubscription<AlarmSettings>? subscription;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: myTabs.length);
    if (Alarm.android) {
      checkAndroidNotificationPermission();
      checkAndroidScheduleExactAlarmPermission();
    }
    subscription ??=
        Alarm.ringStream.stream.listen((alarmSettings) => navigateToRingScreen(
              alarmSettings,
            ));
    super.initState();
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
 {    if (context.mounted) {
   context.push("/ringAlarm", extra: alarmSettings);
 }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        body: DefaultTabController(
          initialIndex: 0,
          length: myTabs.length,
          child: ThemeSwitchingArea(
            child: Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        Center(
                          child: ClockPage(
                            callback: () {
                              _tabController.animateTo(1);
                            },
                          ),
                        ),
                        Center(
                          child: AlarmListPage(
                            onClockPress: () {
                              _tabController.animateTo(0);
                            },
                          ),
                        ),
                        const Center(
                          child: Text(
                            "Setting Screen",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 95,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      child: TabBar(
                        indicatorWeight: 15,
                        enableFeedback: true,
                        tabs: myTabs,
                        controller: _tabController,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not '}granted.',
      );
    }
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 0, 50, 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              context.push("/createAlarm");
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 5,
            highlightElevation: 3,
            child: const Text(
              "+",
              style: TextStyle(
                  color: Color(0xff253165),
                  fontWeight: FontWeight.w700,
                  fontSize: 25),
            ),
          )
        ],
      ),
    );
  }
}

Future<void> checkAndroidNotificationPermission() async {
  final status = await Permission.notification.status;
  if (status.isDenied) {
    alarmPrint('Requesting notification permission...');
    final res = await Permission.notification.request();
    alarmPrint(
      'Notification permission ${res.isGranted ? '' : 'not '}granted.',
    );
  }
}

Future<void> checkAndroidExternalStoragePermission() async {
  final status = await Permission.storage.status;
  if (status.isDenied) {
    alarmPrint('Requesting external storage permission...');
    final res = await Permission.storage.request();
    alarmPrint(
      'External storage permission ${res.isGranted ? '' : 'not'} granted.',
    );
  }
}

Future<void> checkAndroidScheduleExactAlarmPermission() async {
  final status = await Permission.scheduleExactAlarm.status;
  alarmPrint('Schedule exact alarm permission: $status.');
  if (status.isDenied) {
    alarmPrint('Requesting schedule exact alarm permission...');
    final res = await Permission.scheduleExactAlarm.request();
    alarmPrint(
      'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.',
    );
  }
}
