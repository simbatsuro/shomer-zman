import '../constants/time_constants.dart';

class DateUtilsHelper {
  static bool isBeforeSunset(DateTime dt) {
    return dt.hour < TimeConstants.sunsetHour;
  }

  static DateTime stripTime(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }
}