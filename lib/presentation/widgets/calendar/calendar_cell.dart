import 'package:flutter/material.dart';
import '../../../domain/services/calendar_mapper.dart';

class CalendarCellWidget extends StatelessWidget {
  final CalendarCell cell;

  const CalendarCellWidget({
    super.key,
    required this.cell,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Lunar Day (Top Left)
          Text(
            '${cell.lunarDay.toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 2),

          // 🔹 Gregorian Date (small)
          Text(
            '${cell.date.day.toString().padLeft(2, '0')}/${cell.date.month.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),

          const Spacer(),

          // 🔹 Events (stacked)
          ...cell.events.take(3).map(
                (event) => Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

          // Optional: show "+ more"
          if (cell.events.length > 3)
            Text(
              '+${cell.events.length - 3} more',
              style: const TextStyle(fontSize: 9),
            ),
        ],
      ),
    );
  }
}