part of 'app_cubit.dart';

// ignore: must_be_immutable
class AppState extends Equatable {
  final int actionCount;
  final bool loading;
  final String countryTimeZone;
  final List<AlarmSettings> activeAlarmList;
  final List<AlarmSettings> alarmList;
  final bool creating;
  final DateTime selectedDateTime;
  final bool loopAudio;
  final bool vibrate;
  late double? volume;
  final String assetAudio;

  AppState(
      {required this.loading,
      required this.actionCount,
      required this.countryTimeZone,
      required this.activeAlarmList,
      required this.alarmList,
      required this.creating,
      required this.selectedDateTime,
      required this.loopAudio,
      required this.vibrate,
      required this.volume,
      required this.assetAudio,
     });

  AppState copyWith({
    bool? loading,
    String? countryTimeZone,
    int? actionCount,
    List<AlarmSettings>? alarmList,
    List<AlarmSettings>? activeAlarmList,
    bool? creating,
    DateTime? selectedDateTime,
    bool? loopAudio,
    bool? vibrate,
    double? volume,
    String? assetAudio,
  }) {
    return AppState(
      countryTimeZone: countryTimeZone ?? this.countryTimeZone,
      activeAlarmList: activeAlarmList ?? this.activeAlarmList,
      alarmList: alarmList ?? this.alarmList,
      actionCount: actionCount ?? this.actionCount,
      creating: creating ?? this.creating,
      selectedDateTime: selectedDateTime ?? this.selectedDateTime,
      loopAudio: loopAudio ?? this.loopAudio,
      vibrate: vibrate ?? this.vibrate,
      volume: volume ?? this.volume,
      assetAudio: assetAudio ?? this.assetAudio,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [
        countryTimeZone,
        alarmList,
        alarmList,
        actionCount,
        creating,
        selectedDateTime,
        loopAudio,
        vibrate,
        volume,
        assetAudio,
        loading,
      ];
}
