import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/moon_sighting.dart';
import '../../domain/services/sighting_service.dart';

class SightingNotifier extends StateNotifier<List<MoonSighting>> {
  SightingNotifier(this._service) : super([]) {
    loadActive();
  }

  final SightingService _service;

  // ---------------- LOAD INITIAL DATA ----------------
  void loadActive() {
    final active = _service.getActiveSighting();

    if (active != null) {
      state = [active];
    } else {
      state = [];
    }
  }

  // ---------------- RECORD NOW ----------------
  Future<void> recordNow() async {
    final sighting = await _service.recordSighting(DateTime.now());

    _applyNewSighting(sighting);
  }

  // ---------------- RECORD CUSTOM ----------------
  Future<void> recordCustom(DateTime date) async {
    final sighting = await _service.recordSighting(date);

    _applyNewSighting(sighting);
  }

  // ---------------- INTERNAL STATE UPDATE ----------------
  void _applyNewSighting(MoonSighting sighting) {
    state = [
      ...state.map((s) => s.copyWith(isActive: false)),
      sighting,
    ];
  }

  // ---------------- SET FROM STORAGE ----------------
  void setSightings(List<MoonSighting> list) {
    state = list;
  }
}

// ---------------- PROVIDER ----------------
final sightingProvider =
    StateNotifierProvider<SightingNotifier, List<MoonSighting>>(
  (ref) => SightingNotifier(SightingService()),
);