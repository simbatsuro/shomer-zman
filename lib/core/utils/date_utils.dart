class DateUtilsHelper {
  static bool isBeforeSunset(DateTime dt) {
    return dt.hour < 18;
  }

  static DateTime stripTime(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }
}