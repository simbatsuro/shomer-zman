import 'package:flutter/material.dart';

class LunarGuide extends StatelessWidget {
  const LunarGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lunar Guide'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          _AccordionCard(
            title: 'Introduction to the Lunar Calendar',
            imagePath: 'assets/images/elohims_calendar.png',
            content:
                '.',
          ),

           _AccordionCard(
            title: 'Evidence From Scripture',
            imagePath: 'assets/images/sabbath_days.webp',
            content:
            ''
          ),

          _AccordionCard(
            title: 'How to Use Shomer Zman',
            imagePath: 'assets/images/sabbath_days.webp',
            content:
                'xx\n\n'
          ),        
        ],
      ),
    );
  }
}

class _AccordionCard extends StatelessWidget {
  final String title;
  final String content;
  final String? imagePath;

  const _AccordionCard({
    required this.title,
    required this.content,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath!,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}