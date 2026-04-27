import 'package:flutter/material.dart';

class CycleCalendarGrid extends StatelessWidget {
  final List<DateTime> days;

  const CycleCalendarGrid({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        return Center(child: Text('${days[index].day}'));
      },
    );
  }
}