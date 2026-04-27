import 'package:flutter/material.dart';
import '../../../domain/models/moon_sighting.dart';

class MoonSightingTile extends StatelessWidget {
  final MoonSighting sighting;
  final VoidCallback? onTap;

  const MoonSightingTile({
    super.key,
    required this.sighting,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(
          Icons.brightness_1,
          color: Colors.black,
        ),
        title: const Text('New Moon Sighting'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recorded: ${sighting.recordedAt.toLocal().toString().split(' ')[0]}',
            ),
            const SizedBox(height: 4),
            Text(
              'Month Start: ${sighting.monthStart.toLocal().toString().split(' ')[0]}',
            ),
            if (sighting.notes != null && sighting.notes!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                'Note: ${sighting.notes}',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
        trailing: Icon(
          sighting.isActive ? Icons.star : Icons.star_border,
          color: sighting.isActive ? Colors.amber : Colors.grey,
        ),
      ),
    );
  }
}