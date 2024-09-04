import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitListScreen extends StatefulWidget {
  @override
  _HabitListScreenState createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  List<Habit> habits = [
    Habit(
      id: '1',
      name: 'Example Habit',
      completionStatus: [false, false, false, false, false],
    ),
  ];

  void _toggleHabitCompletion(String habitId, int dayIndex) {
    setState(() {
      habits = habits.map((habit) {
        if (habit.id == habitId) {
          List<bool> newStatus = List.from(habit.completionStatus);
          newStatus[dayIndex] = !newStatus[dayIndex];
          return Habit(
            id: habit.id,
            name: habit.name,
            completionStatus: newStatus,
          );
        }
        return habit;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Tracker'),
      ),
      body: ListView.builder(
        itemCount: habits.length,
        itemBuilder: (context, index) {
          final habit = habits[index];
          return ListTile(
            title: Text(habit.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                5,
                (i) => GestureDetector(
                  onTap: () => _toggleHabitCompletion(habit.id, i),
                  child: Container(
                    width: 20,
                    height: 20,
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          habit.completionStatus[i] ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            onTap: () async {
              final result = await Navigator.pushNamed(
                context,
                '/edit_habit',
                arguments: habit,
              );
              if (result != null) {
                setState(() {
                  if (result == 'delete') {
                    habits.removeWhere((h) => h.id == habit.id);
                  } else {
                    final updatedHabit = result as Habit;
                    final index =
                        habits.indexWhere((h) => h.id == updatedHabit.id);
                    if (index != -1) {
                      habits[index] = updatedHabit;
                    }
                  }
                });
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            '/edit_habit',
            arguments: null,
          );
          if (result != null) {
            setState(() {
              habits.add(result as Habit);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
