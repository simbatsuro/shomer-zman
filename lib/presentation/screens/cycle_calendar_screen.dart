import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/event_provider.dart';
import '../../application/providers/sighting_provider.dart';
import '../../core/config/app_defaults.dart';
import '../../domain/models/moon_sighting.dart';
import '../../domain/services/calendar_mapper.dart';
import '../../domain/services/lunar_engine.dart';

import '../widgets/calendar/lunar_calendar_grid.dart';
import '../widgets/calendar/calendar_header.dart';
import '../widgets/calendar/timephase_subheader.dart';

class CycleCalendarScreen extends ConsumerWidget {
  const CycleCalendarScreen({super.key});

  static const int cycleLength = 29;
  static const int totalCycles = 13;

  // ---------------- FORMAT ----------------
  String formatSighting(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year} at '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }

  // ---------------- RESOLVE LOGIC ----------------
  MoonSighting? resolveSighting(List<MoonSighting> sightings) {
    if (sightings.isEmpty) return null;

    // 1. active sighting
    final active = sightings.where((s) => s.isActive).toList();
    if (active.isNotEmpty) return active.first;

    // 2. latest sighting
    final sorted = [...sightings]
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

    return sorted.first;
  }

  // ---------------- PICKER ----------------
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

    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );

    if (time == null || !context.mounted) return;

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventProvider);

    // ✅ now a LIST
    final sightings = ref.watch(sightingProvider);

    final sighting = resolveSighting(sightings);

    final defaultSighting = DateTime(
      AppDefaults.defaultYear,
      AppDefaults.defaultMonth,
      AppDefaults.defaultDay,
      AppDefaults.defaultHour,
    );

    final anchor = sighting?.monthStart ?? defaultSighting;

    return Scaffold(
      appBar: AppBar(title: const Text('Year Planner')),

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

      body: SafeArea(
        child: PageView.builder(
          itemCount: totalCycles,
          controller: PageController(initialPage: 0),
          itemBuilder: (context, index) {
            // 🔥 shift cycles
            final shiftedStart = anchor.add(
              Duration(days: index * cycleLength),
            );

            final engine = LunarEngine(shiftedStart);
            final mapper = CalendarMapper();

            final weeks = mapper.buildMonthGrid(
              monthStart: shiftedStart,
              events: events,
              engine: engine,
            );

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: buildSightingInfo(sighting),
                ),

                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    index == 0
                        ? 'Month 1 ~6030 FC'
                        : 'Month ${index + 1} ~6030 FC',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),

                const CalendarHeader(),
                const TimePhaseSubHeader(),
                const SizedBox(height: 6),

                Expanded(
                  child: LunarCalendarGrid(weeks: weeks),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ---------------- UI INFO CARD ----------------
  Widget buildSightingInfo(MoonSighting? sighting) {
    final isDefault = sighting == null;

    if (isDefault) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Using default sighting (no active or recent sightings)',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.brightness_3, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              formatSighting(sighting.recordedAt),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}