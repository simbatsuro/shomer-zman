import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/moon_sighting.dart';
import '../../domain/services/sighting_service.dart';

class SightingNotifier extends StateNotifier<MoonSighting?> {
  final SightingService _service;

  SightingNotifier(this._service) : super(null) {
    loadActive();
  }

  void loadActive() {
    state = _service.getActiveSighting();
  }

  Future<void> recordNow() async {
    final sighting = await _service.recordSighting(DateTime.now());
    state = sighting;
  }

  Future<void> recordCustom(DateTime time) async {
    final sighting = await _service.recordSighting(time);
    state = sighting;
  }
}

final sightingProvider =
    StateNotifierProvider<SightingNotifier, MoonSighting?>(
  (ref) => SightingNotifier(SightingService()),
);

