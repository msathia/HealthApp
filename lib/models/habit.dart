import 'dart:convert';

class Habit {
  final String id;
  final String name;
  final DateTime date;
  final bool completed;
  final List<bool> completionStatus;

  Habit({
    required this.id,
    required this.name,
    required this.date,
    required this.completionStatus,
    required this.completed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'completed': completed ? 1 : 0,
      'completionStatus': jsonEncode(completionStatus), // Serialize to JSON string
    };
  }

  static Habit fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      date: DateTime.parse(map['date']),
      completed: map['completed'] == 1,
      completionStatus: List<bool>.from(jsonDecode(map['completionStatus'] ?? '[]')), // Deserialize from JSON string
    );
  }
}
