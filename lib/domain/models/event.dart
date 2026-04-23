class Event {
  final String id;
  final String title;
  final DateTime dateTime;
  final List<int> reminderOffsets;

  Event({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.reminderOffsets,
  });
}