import 'package:flutter/material.dart';
import '../../../domain/services/calendar_mapper.dart';
import 'calendar_cell.dart';

class CalendarRow extends StatelessWidget {
  final CalendarWeek week;

  const CalendarRow({super.key, required this.week});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: week.days.map((day) {
          return Expanded(
            child: CalendarCellWidget(cell: day),
          );
        }).toList(),
      ),
    );
  }
}