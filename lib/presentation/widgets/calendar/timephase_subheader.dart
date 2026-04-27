import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers/now_provider.dart';
import '../../../application/providers/sighting_provider.dart';
import '../../../core/constants/time_constants.dart';
import '../../../core/utils/time_phase_utils.dart';
import '../../../domain/models/moon_sighting.dart';
import '../../../domain/services/calendar_mapper.dart';
import '../../../domain/services/lunar_engine.dart';

class TimePhaseSubHeader extends ConsumerWidget {
  const TimePhaseSubHeader({super.key});

  // ---------------- RESOLVE SIGHTING ----------------
  MoonSighting? resolveSighting(List<MoonSighting> sightings) {
    if (sightings.isEmpty) return null;

    // 1. active
    final active = sightings.where((s) => s.isActive).toList();
    if (active.isNotEmpty) return active.first;

    // 2. latest
    final sorted = [...sightings]
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

    return sorted.first;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(nowProvider).maybeWhen(
      data: (value) => value,
      orElse: () => DateTime.now(),
    );

    // ✅ LIST-BASED PROVIDER
    final sightings = ref.watch(sightingProvider);
    final sighting = resolveSighting(sightings);

    final defaultStart = DateTime(
      now.year,
      now.month,
      now.day,
      TimeConstants.sunsetHour,
    );

    final monthStart = sighting?.monthStart ?? defaultStart;

    final engine = LunarEngine(monthStart);
    final mapper = CalendarMapper();

    final currentLunarDay = engine.getLunarDay(now);
    final currentColumn = mapper.getColumnForLunarDay(currentLunarDay);

    final phaseIndex = TimePhaseUtils.getPhaseIndex(now);
    final progress = TimePhaseUtils.getPhaseProgress(now);

    return Row(
      children: List.generate(7, (dayIndex) {
        return Expanded(
          child: _SubHeaderCell(
            isTodayColumn: dayIndex == currentColumn,
            phaseIndex: phaseIndex,
            progress: progress,
          ),
        );
      }),
    );
  }
}

class _SubHeaderCell extends StatelessWidget {
  final bool isTodayColumn;
  final int phaseIndex;
  final double progress;

  const _SubHeaderCell({
    required this.isTodayColumn,
    required this.phaseIndex,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18,
      child: Row(
        children: List.generate(4, (index) {
          return Expanded(
            child: _PhaseBlock(
               key: ValueKey(index +1 ), // Added to silence Dart lint warning (unused_element_parameter)
              phase: index + 1,
              isActivePhase: index == phaseIndex,
              showMarker: isTodayColumn,
              progress: progress,
            ),
          );
        }),
      ),
    );
  }
}

class _PhaseBlock extends StatelessWidget {
  final int phase;
  final bool isActivePhase;
  final bool showMarker;
  final double progress;

  const _PhaseBlock({
    super.key,
    required this.phase,
    required this.isActivePhase,
    required this.showMarker,
    required this.progress,
  });

  // ---------------- GRADIENT ----------------
  static const List<Color> dayCycleGradient = [

    // 🌇 SUNSET // 🌆 EVENING
    Color(0xFF7A9EE6),
    Color(0xFF8FA6E0),
    // Color(0xFF8FA6E0),
    Color(0xFF6E7AC8),
    Color(0xFF5E66B8),

    // 🌌 NIGHT (deepening blue)
    Color(0xFF4B52A6),
    Color(0xFF3F4594),
    Color(0xFF343A84),
    Color(0xFF2A2F74),

    // 🌑 MIDNIGHT 
    Color(0xFF212564),
    Color(0xFF1A1E58),
    Color(0xFF14184C),
    Color(0xFF101342),

    // 🌘 EARLY MORNING (pre-dawn lift, still cool)
    Color(0xFF13204F),
    Color(0xFF1B2E63),
    Color(0xFF243D78),
    Color(0xFF2E4F8F),

    // 🌅 DAWN
    // Color(0xFF5E66B8),
    // Color(0xFF6E7AC8),
    Color(0xFF7A9EE6),
    Color(0xFF7BC2EE),

    // 🌤 MORNING (clear sky, rising brightness)
    Color(0xFF8FD3F5),
    Color(0xFF9FDBF7),
    Color(0xFFB0E3FA),
    Color(0xFFC2EBFD),

    // ☀️ MIDDAY (neutral peak, least atmospheric colour)
    Color(0xFFBFE9FF),
    Color(0xFFB3E3FF),
    Color(0xFFA6DDFF),
    Color(0xFF9AD7FF),

    // 🌇 AFTERNOON (slight warming, still clean blue)
    Color(0xFF8ECDF6),
    Color(0xFF7FBEEE),
    Color(0xFF70AFE6),
    Color(0xFF63A2DE),

    // 🔁 SUNSET LOOP BACK (bridges into start seamlessly)
    Color(0xFF5AA9E6),
    Color(0xFF63B0EA),
    Color(0xFF63B0EA),
    Color(0xFF6AAAE9),
    Color(0xFF72A4E8),
    Color(0xFF7A9EE6),
      
    //Source: Inspired by Scott Thrift from
    //https://www.thisiscolossal.com/2016/06/this-24-hour-clock-gradually-transitions-you-from-dusk-to-dawn/#:~:text=Instead%20of%20being%20a%20slave,by%20watching%20numbers%20tick%20by.

  ];

  List<Color> _getPhaseGradient(int phase) {
    final total = dayCycleGradient.length;
    final segment = total ~/ 4;

    final start = (phase - 1) * segment;
    final end = (phase == 4) ? total : start + segment;

    return dayCycleGradient.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getPhaseGradient(phase);

    return Stack(
      children: [
        // Background gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: colors,
            ),
          ),
        ),

        // Light overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.18),
                Colors.white.withValues(alpha: 0.06),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.18),
              ],
              stops: const [0.0, 0.25, 0.6, 1.0],
            ),
          ),
        ),

        // Marker
        if (showMarker && isActivePhase)
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Positioned(
                      left: progress * constraints.maxWidth,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 3,
                        color: Colors.yellow.shade400,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}