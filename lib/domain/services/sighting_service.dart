import '../../core/utils/uuid_utils.dart';
import '../models/moon_sighting.dart';
import '../../data/local/sighting_box.dart';
import 'lunar_engine.dart';

class SightingService {
  final SightingBox _box = SightingBox();
  // final LunarEngine _engine = LunarEngine();

  Future<MoonSighting> recordSighting(DateTime sightingTime) async {
    // 1. Compute month start (nearest 18:00)
    // final monthStart = _engine.getMonthStart(sightingTime);

    final monthStart = LunarEngine.normaliseSighting(sightingTime);

    // 2. Deactivate previous sightings
    await _box.clearActiveFlags();

    // 3. Create new sighting
    final sighting = MoonSighting(
      id: UuidUtils.generate(),
      recordedAt: sightingTime,
      monthStart: monthStart,
      isActive: true,
    );

    // 4. Store it
    await _box.save(sighting.id, sighting.toMap());

    return sighting;
  }

  MoonSighting? getActiveSighting() {
    final data = _box.getActive();
    if (data == null) return null;

    return MoonSighting.fromMap(data);
  }
}