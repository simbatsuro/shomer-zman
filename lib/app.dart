import 'package:flutter/material.dart';
import 'presentation/screens/calendar_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shomer Zman',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const CalendarScreen(),
    );
  }
}