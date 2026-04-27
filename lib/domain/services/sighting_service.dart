import '../../core/utils/uuid_utils.dart';
import '../../data/local/sighting_box.dart';
import '../models/moon_sighting.dart';
import 'lunar_engine.dart';

class SightingService {
  final MoonSightingBox _box = MoonSightingBox();

  Future<MoonSighting> recordSighting(DateTime sightingTime) async {
    // 1. Compute month start (normalised lunar anchor)
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

    // 4. Store it (Map<String, dynamic>)
    await _box.save(sighting.id, sighting.toMap());

    return sighting;
  }

  MoonSighting? getActiveSighting() {
    final raw = _box.getActive();
    if (raw == null) return null;

    // 🔥 FIX: force safe typing boundary
    final map = Map<String, dynamic>.from(raw);

    return MoonSighting.fromMap(map);
  }
}