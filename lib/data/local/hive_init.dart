import 'package:hive_flutter/hive_flutter.dart';

class HiveInit {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox('events');
    await Hive.openBox('sightings');
  }
}