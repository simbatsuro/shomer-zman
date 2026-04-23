import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/event.dart';

class EventNotifier extends StateNotifier<List<Event>> {
  EventNotifier() : super([]);

  void addEvent(Event event) {
    state = [...state, event];
  }
}

final eventProvider =
  StateNotifierProvider<EventNotifier, List<Event>>(
    (ref) => EventNotifier(),
);

