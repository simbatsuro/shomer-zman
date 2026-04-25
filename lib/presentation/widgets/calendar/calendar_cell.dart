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

    if (cell.isPlaceholder) {
      return const SizedBox.expand();
    }

    return Container(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 16,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final colWidth = constraints.maxWidth / 4;

                return Stack(
                  children: [
                    // Invisible 4-column grid (keeps alignment)
                    Row(
                      children: const [
                        Expanded(child: SizedBox()),
                        Expanded(child: SizedBox()),
                        Expanded(child: SizedBox()),
                        Expanded(child: SizedBox()),
                      ],
                    ),

                    // Lunar day spanning col1 + col2
                    Positioned(
                      left: 0,
                      width: colWidth * 2,
                      child: Text(
                        cell.lunarDay.toString().padLeft(2, '0'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          SizedBox(
            height: 14,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final colWidth = constraints.maxWidth / 4;

                return Stack(
                  children: [
                    // keep 4-column structure
                    Row(
                      children: const [
                        Expanded(child: SizedBox()),
                        Expanded(child: SizedBox()),
                        Expanded(child: SizedBox()),
                        Expanded(child: SizedBox()),
                      ],
                    ),

                    // 🔥 Gregorian date spans 2 columns
                    Positioned(
                      left: colWidth,           // start at column 2
                      width: colWidth * 2,
                      child: Container(
                        padding: const EdgeInsets.only(left: 4),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Colors.grey.withValues(alpha: 0.35),
                              width: 1,
                            ),
                          ),
                        ),
                        // span column 2 + 3
                        child: Text(
                          '${cell.date.day.toString().padLeft(2, '0')}/${cell.date.month.toString().padLeft(2, '0')}',
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}