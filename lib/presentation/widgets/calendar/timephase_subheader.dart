import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers/now_provider.dart';
import '../../../application/providers/sighting_provider.dart';
import '../../../core/constants/time_constants.dart';
import '../../../core/utils/time_phase_utils.dart';
import '../../../domain/services/calendar_mapper.dart';
import '../../../domain/services/lunar_engine.dart';

class TimePhaseSubHeader extends ConsumerWidget {
  const TimePhaseSubHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final now = ref.watch(nowProvider).maybeWhen(
      data: (value) => value,
      orElse: () => DateTime.now(),
    );

    // ref.watch(nowProvider).whenData((now) {
    //   debugPrint('NOW: $now');
    // });

    final sighting = ref.watch(sightingProvider);

    final monthStart = sighting?.monthStart ??
        DateTime(now.year, now.month, now.day, TimeConstants.sunsetHour);

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

  static const List<Color> dayCycleGradient = [
    Color(0xFF6B7A99),
    Color(0xFF6B7A99),
    Color(0xFF1C2A4A),
    Color(0xFF0B1D3A),
    Color(0xFF162B55),
    Color(0xFF2F3E6E),
    Color(0xFF5A6FA3),
    Color(0xFF9BB7D4),
    Color(0xFF8EC5E8),
    Color(0xFF8EC5E8),
    Color(0xFF6FA8DC),
    Color(0xFF6FA8DC),
    //Source: Inspired by Scott Thrift from
    //https://www.thisiscolossal.com/2016/06/this-24-hour-clock-gradually-transitions-you-from-dusk-to-dawn/#:~:text=Instead%20of%20being%20a%20slave,by%20watching%20numbers%20tick%20by.

  ];

  List<Color> _getPhaseGradient(int phase) {
    final int total = dayCycleGradient.length;
    final int segment = total ~/ 4;

    final int start = (phase - 1) * segment;
    final int end = (phase == 4) ? total : start + segment;

    return dayCycleGradient.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getPhaseGradient(phase);

    return Stack(
      children: [
        // Background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: colors,
            ),
          ),
        ),

        // Overlay
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
                        // color: Colors.yellow[300],
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