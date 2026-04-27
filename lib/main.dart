// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'app.dart';
// import 'data/local/hive_init.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await HiveInit.init();

//   runApp(
//     const ProviderScope(
//       child: App(),
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/local/hive_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveInit.init();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}