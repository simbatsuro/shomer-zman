import '../constants/time_constants.dart';

class TimePhaseUtils {

  static int _minutesSinceLunarStart(DateTime now) {
    // Find today's Ssnset (18:00)
    final todaySunset = DateTime(
      now.year,
      now.month,
      now.day,
      TimeConstants.sunsetHour,
    );

    // If before sunset (18:00), use yesterday's sunset (18:00)
    final lunarStart = now.isBefore(todaySunset)
        ? todaySunset.subtract(const Duration(days: 1))
        : todaySunset;

    return now.difference(lunarStart).inMinutes;
  }

  static int getPhaseIndex(DateTime now) {
    final m = _minutesSinceLunarStart(now);
    return m ~/ 360; // 0–3
  }

  static double getPhaseProgress(DateTime now) {
    final m = _minutesSinceLunarStart(now);
    final offset = m % 360;
    return offset / 360.0;
  }
}