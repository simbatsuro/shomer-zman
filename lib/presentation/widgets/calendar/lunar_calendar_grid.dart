import 'package:flutter/material.dart';
import '../../../domain/services/calendar_mapper.dart';
import 'calendar_row.dart';
import '../shared/debug_placeholder.dart';

class LunarCalendarGrid extends StatelessWidget {
  final List<CalendarWeek> weeks;

  const LunarCalendarGrid({super.key, required this.weeks});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: weeks.map((week) {
        return CalendarRow(week: week);
      }).toList(),
    );
//     return Expanded(
//   child:  const DebugPlaceholder()
// );
  }
}