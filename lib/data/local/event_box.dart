import 'package:hive/hive.dart';

class EventBox {
  final Box box = Hive.box('events');

  void save(String id, Map data) {
    box.put(id, data);
  }

  List<Map> getAll() {
    return box.values.cast<Map>().toList();
  }
}