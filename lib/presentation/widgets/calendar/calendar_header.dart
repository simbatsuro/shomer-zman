import 'package:flutter/material.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({super.key});

  static const List<_HeaderColumn> _columns = [
    _HeaderColumn('One'),
    _HeaderColumn('Two'),
    _HeaderColumn('Three'),
    _HeaderColumn('Four'),
    _HeaderColumn('Five'),
    _HeaderColumn('Six / Preparation'),
    _HeaderColumn('Shabbat'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      child: Row(
        children: _columns.map((col) {
          return Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Text(
                col.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _HeaderColumn {
  final String label;

  const _HeaderColumn(this.label);
}