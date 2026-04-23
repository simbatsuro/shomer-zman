import 'package:flutter/material.dart';

class DebugPlaceholder extends StatelessWidget {
  const DebugPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Hello World',
        style: TextStyle(
          fontSize: 12,
          color: Colors.green,
        ),
      ),
    );
  }
}