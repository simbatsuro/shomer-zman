import '../../domain/services/lunar_engine.dart';
import '../models/event.dart';

class CalendarCell {
  final int lunarDay;
  final DateTime date;
  final List<Event> events;
  final bool isPlaceholder;

  CalendarCell({
    required this.lunarDay,
    required this.date,
    required this.events,
    this.isPlaceholder = false,
  });

  factory CalendarCell.empty(DateTime date) {
    return CalendarCell(
      lunarDay: 0,
      date: date,
      events: const [],
      isPlaceholder: true,
    );
  }
}

class CalendarWeek {
  final List<CalendarCell> days;

  CalendarWeek({required this.days});
}

class CalendarMapper {

  int getColumnForLunarDay(int lunarDay) {
    return (lunarDay + 5) % 7;
  }

  List<CalendarWeek> buildMonthGrid({
    required DateTime monthStart,
    required List<Event> events,
    required LunarEngine engine,
  }) {
    const int daysInMonth = 30;
    const int columns = 7;

    final List<CalendarWeek> weeks = [];

    List<CalendarCell?> currentRow = List.filled(columns, null);

    for (int lunarDay = 1; lunarDay <= daysInMonth; lunarDay++) {

      final DateTime lunarDayStart =
        monthStart.add(Duration(days: lunarDay - 1));

      // Move to next day's midnight
      final DateTime midnightDate = DateTime(
        lunarDayStart.year,
        lunarDayStart.month,
        lunarDayStart.day,
      ).add(const Duration(days: 1));

      final int column = (lunarDay + 5) % 7;

      final dayEvents = events.where((e) =>
          e.dateTime.year == midnightDate.year &&
          e.dateTime.month == midnightDate.month &&
          e.dateTime.day == midnightDate.day).toList();

      currentRow[column] = CalendarCell(
        lunarDay: lunarDay,
        date: midnightDate,
        events: dayEvents,
      );

      // When we complete a full row OR last day
      final bool endOfRow = column == 6;
      final bool lastDay = lunarDay == daysInMonth;

      if (endOfRow || lastDay) {
        weeks.add(
          CalendarWeek(
            days: currentRow.map((c) {
              return c ??
                  CalendarCell(
                    lunarDay: 0,
                    date: monthStart,
                    events: const [],
                    isPlaceholder: true,
                  );
            }).toList(),
          ),
        );
        
        currentRow = List.filled(columns, null);
      }
    }

    return weeks;
  }
}