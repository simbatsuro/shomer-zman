import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/event_provider.dart';
import '../../application/providers/lunar_provider.dart';
import '../../domain/services/lunar_engine.dart';
import '../../domain/services/calendar_mapper.dart';

import '../widgets/calendar/lunar_calendar_grid.dart';
import '../widgets/calendar/calendar_header.dart';
import '../widgets/shared/debug_placeholder.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(nowProvider);
    final events = ref.watch(eventProvider);

    // TODO: Replace with actual stored sighting
    // final monthStart = DateTime(now.year, now.month, now.day, 18);
    final monthStart = DateTime(now.year, 4, 18, 18);

    final engine = LunarEngine(monthStart);

    final mapper = CalendarMapper();

    final weeks = mapper.buildMonthGrid(
      monthStart: monthStart,
      events: events,
      engine: engine,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Shomer Zman')),
      body: Column(
        children: [
          const CalendarHeader(),
          Expanded(
            child: LunarCalendarGrid(weeks: weeks),
          ),
        ],
      ),
    );
  }
}