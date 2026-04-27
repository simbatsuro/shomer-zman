class MoonSighting {
  final String id;
  final DateTime recordedAt;
  final DateTime monthStart;
  final bool isActive;
  final String? notes;

  MoonSighting({
    required this.id,
    required this.recordedAt,
    required this.monthStart,
    required this.isActive,
    this.notes,
  });

  MoonSighting copyWith({
    String? id,
    DateTime? recordedAt,
    DateTime? monthStart,
    bool? isActive,
    String? notes,
  }) {
    return MoonSighting(
      id: id ?? this.id,
      recordedAt: recordedAt ?? this.recordedAt,
      monthStart: monthStart ?? this.monthStart,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recordedAt': recordedAt.toIso8601String(),
      'monthStart': monthStart.toIso8601String(),
      'isActive': isActive,
      'notes': notes,
    };
  }

  factory MoonSighting.fromMap(Map<String, dynamic> map) {
    return MoonSighting(
      id: map['id'] as String,
      recordedAt: DateTime.parse(map['recordedAt'] as String),
      monthStart: DateTime.parse(map['monthStart'] as String),
      isActive: map['isActive'] as bool,
      notes: map['notes'] as String?,
    );
  }
}