import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clock/cubit/app_cubit.dart';
import 'package:flutter_clock/shared/alarm_item_widget.dart';
import 'package:flutter_clock/shared/appbar_widget.dart';
import 'package:flutter_clock/shared/no_alarm_widget.dart';

class AlarmListPage extends StatelessWidget {
  final void Function() onClockPress;

  const AlarmListPage({super.key, required this.onClockPress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildAlarmListAppBar(context, onClockPress),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (state.alarmList.isEmpty)
                      buildNoAlarmWidget(context)
                    else
                      Expanded(
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            ListView.separated(
                              padding: const EdgeInsets.only(top: 0),
                              shrinkWrap: true,
                              itemCount: state.alarmList.length,
                              itemBuilder: (context, index) {
                                final alarmItem = state.alarmList[index];
                                final toggleValue =
                                    state.activeAlarmList.contains(alarmItem);
                                return buildAlarmItem(
                                    context, alarmItem, index, toggleValue);
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(
                                  height: 16,
                                );
                              },
                            ),
                          ],
                        ),
                      )
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class RecordItem extends StatelessWidget {
  const RecordItem({
    super.key,
    required Color fontColor,
    required double smallFontSpacing,
    required this.day,
  })  : _fontColor = fontColor,
        _smallFontSpacing = smallFontSpacing;

  final Color _fontColor;
  final double _smallFontSpacing;
  final String day;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Color(0xffdde9f7),
        width: 1.5,
      ))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            day,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: _fontColor),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: <Widget>[
              Text(
                "01/21/2019",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    letterSpacing: _smallFontSpacing,
                    color: _fontColor),
              ),
              const SizedBox(
                width: 25,
              ),
              Expanded(
                child: Text(
                  "45.3 MINUTES",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      letterSpacing: _smallFontSpacing,
                      color: _fontColor),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class GraphPainter extends CustomPainter {
  Paint trackBarPaint = Paint()
    ..color = const Color(0xff818aab)
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 12;

  Paint trackPaint = Paint()
    ..color = const Color(0xffdee6f1)
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 12;

  @override
  void paint(Canvas canvas, Size size) {
    List val = [
      size.height * 0.8,
      size.height * 0.5,
      size.height * 0.9,
      size.height * 0.8,
      size.height * 0.5,
    ];
    double origin = 8;

    Path trackBarPath = Path();
    Path trackPath = Path();

    for (int i = 0; i < val.length; i++) {
      trackPath.moveTo(origin, size.height);
      trackPath.lineTo(origin, 0);

      trackBarPath.moveTo(origin, size.height);
      trackBarPath.lineTo(origin, val[i]);

      origin = origin + size.width * 0.22;
    }

    canvas.drawPath(trackPath, trackPaint);
    canvas.drawPath(trackBarPath, trackBarPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
