import 'package:uuid/uuid.dart';

class UuidUtils {
  static final _uuid = Uuid();

  static String generate() => _uuid.v4();
}