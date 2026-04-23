import '../../core/constants/time_constants.dart';

class LunarEngine {
  final DateTime monthStart;

  LunarEngine(this.monthStart);

  int getLunarDay(DateTime now) {
    int days = now.difference(monthStart).inDays;
    int lunarDay = days + 1;

    if (now.hour < TimeConstants.sunsetHour) {
      lunarDay -= 1;
    }

    return lunarDay < 1 ? 1 : lunarDay;
  }

  int getDayOfWeek(int lunarDay) {
    return ((lunarDay - 1) % 7) + 1;
  }

  int getColumnForLunarDay(int lunarDay) {
  return ((lunarDay + 5) % 7) + 1;
}


  DateTime normalizeSighting(DateTime sighting) {
    return DateTime(
      sighting.year,
      sighting.month,
      sighting.day,
      TimeConstants.sunsetHour,
    );
  }
}