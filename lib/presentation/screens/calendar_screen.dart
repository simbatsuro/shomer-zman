import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/event_provider.dart';
import '../../application/providers/lunar_provider.dart';
import '../../application/providers/sighting_provider.dart';
import '../../domain/models/moon_sighting.dart';
import '../../domain/services/lunar_engine.dart';
import '../../domain/services/calendar_mapper.dart';

import '../widgets/calendar/lunar_calendar_grid.dart';
import '../widgets/calendar/calendar_header.dart';
import '../widgets/calendar/calendar_timephase_subheader.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  String formatSighting(DateTime dt) {
    final date =
        '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year}';

    final time =
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';

    return '$date at $time';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(nowProvider);
    final events = ref.watch(eventProvider);
    final sighting = ref.watch(sightingProvider);

    final monthStart = sighting?.monthStart ??
        DateTime(now.year, 4, 19, 18);

    final engine = LunarEngine(monthStart);
    final mapper = CalendarMapper();

    final weeks = mapper.buildMonthGrid(
      monthStart: monthStart,
      events: events,
      engine: engine,
    );

    Future<void> showCustomSightingPicker(
      BuildContext context,
      WidgetRef ref,
    ) async {
      final now = DateTime.now();

      final date = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
      );

      if (date == null) return;

      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );

      if (time == null) return;

      final sightingDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      await ref
          .read(sightingProvider.notifier)
          .recordCustom(sightingDateTime);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Shomer Zman')),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'now',
            onPressed: () {
              ref.read(sightingProvider.notifier).recordNow();
            },
            child: const Icon(Icons.brightness_3),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'custom',
            onPressed: () {
              showCustomSightingPicker(context, ref);
            },
            child: const Icon(Icons.edit_calendar),
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildSightingInfo(sighting),
          ),

          const CalendarHeader(),
          const TimePhaseSubHeader(),

          Expanded(
            child: LunarCalendarGrid(weeks: weeks),
          ),
        ],
      ),
    );
  }

  Widget buildSightingInfo(MoonSighting? sighting) {
    if (sighting == null) {
      return const Text(
        'No moon sighting recorded',
        style: TextStyle(fontSize: 12),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Last Moon Sighting',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          formatSighting(sighting.recordedAt),
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }
}