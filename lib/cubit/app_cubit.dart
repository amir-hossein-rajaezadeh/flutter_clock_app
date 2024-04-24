import 'dart:math';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock/shared/sound_item_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:public_ip_address/public_ip_address.dart';
import '../screens/create_edit_alarm_page.dart';
import '../utils/my_colors.dart';
import '../utils/theme_detector.dart';
part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit()
      : super(
          AppState(
            volume: null,
            countryTimeZone: '',
            activeAlarmList: const [],
            alarmList: const [],
            actionCount: 0,
            assetAudio: '',
            creating: true,
            selectedDateTime: DateTime.now(),
            loopAudio: false,
            vibrate: false,
            loading: false,
          ),
        );
  late List<AlarmSettings> alarmList;
  List<int> activeAlarmListIndex = [];
  List<DropdownMenuItem<String>>? dropDownItemList = [
    DropdownMenuItem<String>(
      value: 'assets/alarms/marimba.mp3',
      child: soundDropDownValueTextWidget('Marimba'),
    ),
    DropdownMenuItem<String>(
      value: 'assets/alarms/nokia.mp3',
      child: soundDropDownValueTextWidget('Nokia'),
    ),
    DropdownMenuItem<String>(
      value: 'assets/alarms/mozart.mp3',
      child: soundDropDownValueTextWidget('Mozart'),
    ),
    DropdownMenuItem<String>(
      value: 'assets/alarms/star_wars.mp3',
      child: soundDropDownValueTextWidget('Star Wars'),
    ),
    DropdownMenuItem<String>(
      value: 'assets/alarms/one_piece.mp3',
      child: soundDropDownValueTextWidget('One Piece'),
    ),
  ];
  List<AlarmSettings> activeAlarmList = [];
  Future<void> getIP() async {
    bool calledFirstTime = false;
    calledFirstTime = true;
    if (calledFirstTime) {
      alarmList = Alarm.getAlarms();
    }
    emit(
      state.copyWith(
        actionCount: state.actionCount + 1,
        alarmList: alarmList,
        activeAlarmList: Alarm.getAlarms(),
      ),
    );

    IpAddress ipAddress = IpAddress();

    await ipAddress.getTimeZone().then(
          (value) => emit(
            state.copyWith(
              actionCount: state.actionCount + 1,
              countryTimeZone: value,
            ),
          ),
        );
  }

  Future<void> onTogglePressed(int id, int index, bool toggle) async {
    if (toggle) {
      activeAlarmList.remove(
        Alarm.getAlarm(id),
      );
      await Alarm.stop(id);

      emit(
        state.copyWith(
            actionCount: state.actionCount + 1,
            alarmList: alarmList,
            activeAlarmList: activeAlarmList),
      );
    } else {
      activeAlarmListIndex.add(id);

      final activeAlarmSettingItem = state.alarmList[index];

      await Alarm.set(alarmSettings: activeAlarmSettingItem);
      final activeAlarmList = Alarm.getAlarms();

      emit(
        state.copyWith(
          actionCount: state.actionCount + 1,
          alarmList: alarmList,
          activeAlarmList: activeAlarmList,
        ),
      );
    }
  }

  Future<void> navigateToAlarmScreen(
      AlarmSettings? settings, BuildContext context) async {
    await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ThemeDetector().isDarkModeEnabled(context)
          ? const Color(0xFF15264f)
          : MyColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.75,
          child: CreateEditScreen(alarmSettings: settings),
        );
      },
    );

    emit(
      state.copyWith(
          activeAlarmList: Alarm.getAlarms(),
          actionCount: state.actionCount + 1,
          alarmList: alarmList),
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

  void getAlarmList() {
    final activeAlarmList = Alarm.getAlarms();
    emit(
      state.copyWith(
        alarmList: alarmList,
          activeAlarmList: activeAlarmList, actionCount: state.actionCount + 1),
    );
  }

  Future<void> pickTime(BuildContext context) async {
    final res = await showTimePicker(
      initialTime: TimeOfDay.fromDateTime(state.selectedDateTime),
      context: context,
    );

    if (res != null) {
      final DateTime now = DateTime.now();
      emit(
        state.copyWith(
            actionCount: state.actionCount + 1,
            selectedDateTime: now.copyWith(
              hour: res.hour,
              minute: res.minute,
              second: 0,
              millisecond: 0,
              microsecond: 0,
            )),
      );

      if (state.selectedDateTime.isBefore(now)) {
        emit(
          state.copyWith(
            actionCount: state.actionCount + 1,
            selectedDateTime: state.selectedDateTime.add(
              const Duration(days: 1),
            ),
          ),
        );
      }
    }
  }

  Future<void> saveAlarm(BuildContext context, int? alarmId) async {
    final alarmSettings = AlarmSettings(
      id: alarmId ?? Random().nextInt(300000),
      dateTime: state.selectedDateTime,
      loopAudio: state.loopAudio,
      vibrate: state.vibrate,
      volume: state.volume,
      assetAudioPath: state.assetAudio,
      notificationTitle: 'Flutter Clock',
      notificationBody: 'Your alarm  is ringing!',
    );
    if (!state.creating) {
      alarmList.remove(
        Alarm.getAlarm(alarmId ?? 0),
      );
    }

    final bool createdSuccessfully = await Alarm.set(
      alarmSettings: alarmSettings,
    );
    activeAlarmList.add(alarmSettings);
    emit(
      state.copyWith(
        activeAlarmList: activeAlarmList + [alarmSettings],
        alarmList: alarmList,
        actionCount: state.actionCount + 1,
      ),
    );
    alarmList.add(
      alarmSettings,
    );

    emit(
      state.copyWith(
        activeAlarmList: activeAlarmList,
        alarmList: alarmList,
        actionCount: state.actionCount + 1,
      ),
    );

    if (createdSuccessfully) Navigator.pop(context, true);
    emit(
      state.copyWith(
        actionCount: state.actionCount + 1,
      ),
    );
  }

  String getDay() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference = state.selectedDateTime.difference(today).inDays;

    switch (difference) {
      case 0:
        return 'Today';
      case 1:
        return 'Tomorrow';
      case 2:
        return 'After tomorrow';
      default:
        return 'In $difference days';
    }
  }

  void setVolumeTrue(double value) {
    emit(
      state.copyWith(volume: value),
    );
  }

  void loopSwitch(bool value) {
    emit(state.copyWith(loopAudio: value));
  }

  void initState(AlarmSettings? alarmSettings) {
    emit(
      state.copyWith(
          creating: alarmSettings == null, actionCount: state.actionCount + 1),
    );

    if (state.creating) {
      emit(
        state.copyWith(
          actionCount: state.actionCount + 1,
          activeAlarmList: Alarm.getAlarms(),
          alarmList: alarmList,
          selectedDateTime: DateTime.now().add(
            const Duration(minutes: 1),
          ),
          loopAudio: true,
          vibrate: true,
          volume: null,
          assetAudio: 'assets/alarms/marimba.mp3',
        ),
      );
    } else {
      emit(state.copyWith(
        actionCount: state.actionCount + 1,
        selectedDateTime: alarmSettings!.dateTime,
        loopAudio: alarmSettings.loopAudio,
        vibrate: alarmSettings.vibrate,
        volume: alarmSettings.volume,
        assetAudio: alarmSettings.assetAudioPath,
      ));
    }
  }

  void setVibrate(bool value) {
    emit(
      state.copyWith(vibrate: value),
    );
  }

  void setAssetAudio(String value) {
    emit(
      state.copyWith(assetAudio: value),
    );
  }

  void setVolume(bool value) {
    emit(
      state.copyWith(volume: value ? 0.5 : null),
    );
  }

  void setAlarmValue(double value) {
    emit(
      state.copyWith(volume: value),
    );
  }

  Future<void> deleteAlarm(int id, BuildContext context) async {
    final alarmItem = Alarm.getAlarm(id);
    alarmList.remove(alarmItem);
    await Alarm.stop(id);
    emit(
      state.copyWith(
          alarmList: alarmList,
          activeAlarmList: Alarm.getAlarms(),
          actionCount: state.actionCount + 1),
    );
  }
}
