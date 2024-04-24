import 'package:alarm/alarm.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clock/cubit/app_cubit.dart';
import 'package:flutter_clock/utils/my_routes.dart';
import 'utils/theme_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isPlatformDark =
        WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    final initTheme = isPlatformDark ? darkTheme : lightTheme;
    return BlocProvider(
      create: (context) => AppCubit(),
      child: ThemeProvider(
        initTheme: initTheme,
        builder: (_, myTheme) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: MyRoutes().router,
            title: 'Flutter Clock',
            theme: myTheme,
          );
        },
      ),
    );
  }
}
