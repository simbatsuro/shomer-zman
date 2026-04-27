import '../local/sighting_box.dart';
import '../../domain/models/moon_sighting.dart';

class MoonSightingRepository {
  final MoonSightingBox storage;

  MoonSightingRepository(this.storage);

  Future<void> add(MoonSighting sighting) async {
    await storage.save(sighting.id, sighting.toMap());
  }

  Future<List<MoonSighting>> getAll() async {
    final rawList = storage.getAll();

    return rawList.map(MoonSighting.fromMap).toList();
  }

  Future<List<MoonSighting>> getLast13Months() async {
    final raw = storage.getAll();

    return raw
      .map((map) => MoonSighting.fromMap(map))
      .where((s) {
        final diff = DateTime.now().difference(s.recordedAt).inDays;
        return diff <= (13 * 29.53);
      })
      .toList();
  }
}