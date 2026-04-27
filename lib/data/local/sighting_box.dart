import 'package:hive/hive.dart';

class MoonSightingBox {
  static const String _boxName = 'moon_sightings';

  Box get _box => Hive.box(_boxName);

  /// Save or update a sighting
  Future<void> save(String id, Map<String, dynamic> data) async {
    await _box.put(id, data);
  }

  /// Get all sightings (safe typed)
  List<Map<String, dynamic>> getAll() {
    return _box.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  /// Get sighting by id
  Map<String, dynamic>? getById(String id) {
    final raw = _box.get(id);

    if (raw == null) return null;

    return Map<String, dynamic>.from(raw);
  }

  /// Get active sighting (where isActive == true)
  Map<String, dynamic>? getActive() {
    for (final entry in _box.values) {
      final map = Map<String, dynamic>.from(entry);

      if (map['isActive'] == true) {
        return map;
      }
    }
    return null;
  }

  /// Deactivate all sightings
  Future<void> clearActiveFlags() async {
    for (final key in _box.keys) {
      final raw = _box.get(key);

      if (raw == null) continue;

      final map = Map<String, dynamic>.from(raw);
      map['isActive'] = false;

      await _box.put(key, map);
    }
  }

  /// Delete a sighting
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  /// Clear everything (use carefully)
  Future<void> clearAll() async {
    await _box.clear();
  }
}