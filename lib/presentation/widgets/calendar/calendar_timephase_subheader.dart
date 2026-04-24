import 'package:flutter/material.dart';

class TimePhaseSubHeader extends StatelessWidget {
  const TimePhaseSubHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(7, (index) {
        return const Expanded(
          child: _SubHeaderCell(),
        );
      }),
    );
  }
}

class _SubHeaderCell extends StatelessWidget {
  const _SubHeaderCell();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: Row(
        children: const [
          Expanded(child: _PhaseBlock(phase: 1)),
          Expanded(child: _PhaseBlock(phase: 2)),
          Expanded(child: _PhaseBlock(phase: 3)),
          Expanded(child: _PhaseBlock(phase: 4)),
        ],
      ),
    );
  }
}


class _PhaseBlock extends StatelessWidget {
  final int phase;

  const _PhaseBlock({super.key, required this.phase});

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

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // 🔹 Horizontal gradient (time progression — subtle)
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: colors,
        ),
      ),
      child: Container(
        
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
    );
  }
}