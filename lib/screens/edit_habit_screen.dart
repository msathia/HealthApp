import 'package:flutter/material.dart';
import '../models/habit.dart';

class EditHabitScreen extends StatefulWidget {
  @override
  EditHabitScreenState createState() => EditHabitScreenState();
}

class EditHabitScreenState extends State<EditHabitScreen> {
  late TextEditingController _nameController;
  Habit? habit;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    habit = ModalRoute.of(context)!.settings.arguments as Habit?;
    if (habit != null) {
      _nameController.text = habit!.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveHabit() {
    final name = _nameController.text;
    if (name.isNotEmpty) {
      if (habit == null) {
        habit = Habit(
          id: DateTime.now().toString(),
          name: name,
          completionStatus: List.filled(5, false),
        );
      } else {
        habit = Habit(
          id: habit!.id,
          name: name,
          completionStatus: habit!.completionStatus,
        );
      }
      Navigator.pop(context, habit);
    }
  }

  void _deleteHabit() {
    Navigator.pop(context, 'delete');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(habit == null ? 'Add Habit' : 'Edit Habit'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Habit Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveHabit,
              child: Text('Save Habit'),
            ),
            if (habit != null) ...[
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _deleteHabit,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('Delete Habit'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
