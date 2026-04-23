class MoonSighting {
  final String id;
  final DateTime recordedAt;
  final DateTime monthStart;
  final bool isActive;

  MoonSighting({
    required this.id,
    required this.recordedAt,
    required this.monthStart,
    required this.isActive,
  });
}