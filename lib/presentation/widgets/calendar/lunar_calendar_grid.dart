import 'package:flutter/material.dart';

import '../../../domain/services/calendar_mapper.dart';
import 'calendar_cell.dart';

class LunarCalendarGrid extends StatelessWidget {
  final List<CalendarWeek> weeks;

  const LunarCalendarGrid({
    super.key,
    required this.weeks,
  });

  @override
  Widget build(BuildContext context) {
    // Flatten weeks → cells
    final allDays = weeks.expand((w) => w.days).toList();

    return GridView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: allDays.length,

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,

        // 🔥 spacing replaces margin
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,

        // 🔥 THIS controls height
        childAspectRatio: 1.2,
      ),

      itemBuilder: (context, index) {
        final cell = allDays[index];

        return CalendarCellWidget(cell: cell);
      },
    );

    // //  return Expanded(
    // //    child:  const DebugPlaceholder()
    // //   );
  }
}