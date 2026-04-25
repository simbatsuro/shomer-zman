import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowProvider = StreamProvider<DateTime>((ref) async* {
  while (true) {
    yield DateTime.now();
    await Future.delayed(const Duration(seconds: 10));
  }
});