import 'package:hive/hive.dart';

class SightingBox {
  final Box box = Hive.box('sightings');

  Future<void> save(String id, Map data) async {
    await box.put(id, data);
  }

  List<Map> getAll() {
    return box.values.cast<Map>().toList();
  }

  Future<void> clearActiveFlags() async {
    for (var key in box.keys) {
      final item = Map<String, dynamic>.from(box.get(key));
      item['isActive'] = false;
      await box.put(key, item);
    }
  }

  Map? getActive() {
    try {
      return box.values
          .cast<Map>()
          .firstWhere((e) => e['isActive'] == true);
    } catch (_) {
      return null;
    }
  }
}