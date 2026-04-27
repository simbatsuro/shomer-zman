import 'package:flutter/material.dart';

class AddMoonSightingSheet extends StatefulWidget {
  final Function(DateTime date, String? notes) onSave;

  const AddMoonSightingSheet({
    super.key,
    required this.onSave,
  });

  @override
  State<AddMoonSightingSheet> createState() => _AddMoonSightingSheetState();
}

class _AddMoonSightingSheetState extends State<AddMoonSightingSheet> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController notesController = TextEditingController();

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Add New Moon Sighting',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Select Date'),
            subtitle: Text(
              selectedDate.toLocal().toString().split(' ')[0],
            ),
            onTap: pickDate,
          ),

          TextField(
            controller: notesController,
            decoration: const InputDecoration(
              labelText: 'Notes (optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onSave(
                  selectedDate,
                  notesController.text.trim().isEmpty
                      ? null
                      : notesController.text.trim(),
                );
                Navigator.pop(context);
              },
              child: const Text('Save Sighting'),
            ),
          ),
        ],
      ),
    );
  }
}