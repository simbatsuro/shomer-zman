// import '../../core/constants/time_constants.dart';

// class LunarEngine {
//   final DateTime monthStart;

//   LunarEngine(this.monthStart);

//   /// Computes lunar day using 18:00-anchored days
//   int getLunarDay(DateTime now) {
//     final lunarStart = normaliseSighting(monthStart);

//     final days = now.difference(lunarStart).inDays;
//     final lunarDay = days + 1;

//     return lunarDay < 1 ? 1 : lunarDay;
//   }

//   int getDayOfWeek(int lunarDay) {
//     return ((lunarDay - 1) % 7) + 1;
//   }

//   int getColumnForLunarDay(int lunarDay) {
//     return ((lunarDay + 5) % 7) + 1;
//   }

//   /// Anchors sighting to nearest absolute 18:00
//   /// Rule: 06:00 rolls forward
//   DateTime normaliseSighting(DateTime sighting) {
//     final today18 = DateTime(
//       sighting.year,
//       sighting.month,
//       sighting.day,
//       TimeConstants.sunsetHour, // 18:00
//     );

//     final cutoff = DateTime(
//       sighting.year,
//       sighting.month,
//       sighting.day,
//       6, // 06:00 pivot
//     );

//     if (sighting.isBefore(cutoff)) {
//       return today18.subtract(const Duration(days: 1));
//     } else {
//       return today18;
//     }
//   }
// }


import '../../core/constants/time_constants.dart';

class LunarEngine {
  final DateTime monthStart; // MUST already be normalised



  LunarEngine(this.monthStart) {
    assert(
      monthStart.hour == 18 &&
      monthStart.minute == 0 &&
      monthStart.second == 0,
      'monthStart must be exactly 18:00:00',
    );
  }

  /// Computes lunar day using 18:00-anchored days
  int getLunarDay(DateTime now) {
    final days = now.difference(monthStart).inDays;
    final lunarDay = days + 1;

    return lunarDay < 1 ? 1 : lunarDay;
  }

  int getDayOfWeek(int lunarDay) {
    return ((lunarDay - 1) % 7) + 1;
  }

  int getColumnForLunarDay(int lunarDay) {
    return ((lunarDay + 5) % 7) + 1;
  }

  /// ONLY used when recording a sighting
  static DateTime normaliseSighting(DateTime sighting) {
    final today18 = DateTime(
      sighting.year,
      sighting.month,
      sighting.day,
      TimeConstants.sunsetHour,
    );

    final cutoff = DateTime(
      sighting.year,
      sighting.month,
      sighting.day,
      6,
    );

    if (sighting.isBefore(cutoff)) {
      return today18.subtract(const Duration(days: 1));
    } else {
      return today18;
    }
  }
} 