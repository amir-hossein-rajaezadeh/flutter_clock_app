import 'dart:async';
import 'package:flutter_clock/utils/theme_detector.dart';
import 'clock_dial_painter.dart';
import 'clock_hands.dart';
import 'clock_text.dart';
import 'package:flutter/material.dart';

typedef TimeProducer = DateTime Function();

class Clock extends StatefulWidget {
  final Color circleColor;
  final Color shadowColor;

  final ClockText clockText;

  final TimeProducer getCurrentTime;
  final Duration updateDuration;

  const Clock(
      {super.key,
      this.circleColor = const Color(0xffe1ecf7),
      this.shadowColor = const Color(0xffd9e2ed),
      this.clockText = ClockText.arabic,
      this.getCurrentTime = getSystemTime,
      this.updateDuration = const Duration(seconds: 1)});

  static DateTime getSystemTime() {
    return DateTime.now();
  }

  @override
  State<StatefulWidget> createState() {
    return _Clock();
  }
}

class _Clock extends State<Clock> {
  late Timer _timer;
  late DateTime dateTime;

  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();
    _timer = Timer.periodic(widget.updateDuration, setTime);
  }

  void setTime(Timer timer) {
    setState(() {
      dateTime = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: buildClockCircle(context),
    );
  }

  Container buildClockCircle(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ThemeDetector().isDarkModeEnabled(context)
            ? const Color(0xFF15264f)
            : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(right: 30, left: 30, top: 30),
              width: double.infinity,
              child: CustomPaint(
                painter: ClockDialPainter(
                    clockText: widget.clockText, context: context),
              ),
            ),
            ClockHands(
              dateTime: dateTime,
            ),
          ],
        ),
      ),
    );
  }
}
