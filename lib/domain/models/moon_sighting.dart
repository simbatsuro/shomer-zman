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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recordedAt': recordedAt.toIso8601String(),
      'monthStart': monthStart.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory MoonSighting.fromMap(Map map) {
    return MoonSighting(
      id: map['id'],
      recordedAt: DateTime.parse(map['recordedAt']),
      monthStart: DateTime.parse(map['monthStart']),
      isActive: map['isActive'],
    );
  }
}