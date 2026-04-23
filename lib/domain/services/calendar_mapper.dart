import '../models/event.dart';
import '../../domain/services/lunar_engine.dart';

class CalendarCell {
  final int lunarDay;
  final DateTime date;
  final List<Event> events;

  CalendarCell({
    required this.lunarDay,
    required this.date,
    required this.events,
  });

  factory CalendarCell.empty(DateTime date) {
    return CalendarCell(
      lunarDay: 0,
      date: date,
      events: const [],
    );
  }
}

class CalendarWeek {
  final List<CalendarCell> days;

  CalendarWeek({required this.days});
}

class CalendarMapper {
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
      final DateTime date =
          monthStart.add(Duration(days: lunarDay - 1));

      final int column = (lunarDay + 5) % 7;

      final dayEvents = events.where((e) =>
          e.dateTime.year == date.year &&
          e.dateTime.month == date.month &&
          e.dateTime.day == date.day).toList();

      currentRow[column] = CalendarCell(
        lunarDay: lunarDay,
        date: date,
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