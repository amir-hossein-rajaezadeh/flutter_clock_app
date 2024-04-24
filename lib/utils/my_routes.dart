import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter_clock/screens/main_page.dart';
import 'package:go_router/go_router.dart';
import '../screens/clock_page.dart';
import '../screens/create_edit_alarm_page.dart';
import '../screens/alarm_ring_page.dart';

class MyRoutes {
  final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => const MainPage(),
      ),
      GoRoute(
        path: "/clock",
        builder: (context, state) => ClockPage(
          callback: () {},
        ),
      ),
      GoRoute(
        path: "/createAlarm",
        builder: (context, state) => const CreateEditScreen(
          alarmSettings: null,
        ),
      ),
      GoRoute(
        path: "/ringAlarm",
        builder: (context, state) {
          AlarmSettings alarmSettings = state.extra as AlarmSettings;
          return AlarmRingScreen(
            alarmSettings: alarmSettings,
          );
        },
      ),
    ],
  );
}
