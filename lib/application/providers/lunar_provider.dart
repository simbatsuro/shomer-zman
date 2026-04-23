import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});