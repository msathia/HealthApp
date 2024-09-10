import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../helpers/database_helper.dart';
// Added for DateTime formatting

class HabitListScreen extends StatefulWidget {
  @override
  HabitListScreenState createState() => HabitListScreenState();
}

class HabitListScreenState extends State<HabitListScreen> {
  List<Habit> habits = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final loadedHabits = await DatabaseHelper.instance.getHabits();
    
    if (loadedHabits.isEmpty) {
      // Add an example habit if the list is empty (first launch)
      final exampleHabit = Habit(
        id: '',  // Change this line from null to an empty string
        name: 'Example: Daily Exercise',
        date: DateTime.now(),
        completed: false,
        completionStatus: List.filled(5, false),
      );
      await DatabaseHelper.instance.insertHabit(exampleHabit);
      loadedHabits.add(exampleHabit);
    }

    setState(() {
      habits = loadedHabits;
    });
  }

  void _toggleHabitCompletion(Habit habit, int index) async {
    final updatedCompletionStatus = List<bool>.from(habit.completionStatus);
    updatedCompletionStatus[index] = !updatedCompletionStatus[index];

    final updatedHabit = Habit(
      id: habit.id,
      name: habit.name,
      date: habit.date,
      completed: updatedCompletionStatus.any((status) => status),
      completionStatus: updatedCompletionStatus,
    );

    setState(() {
      // Update the habit in the local list
      final habitIndex = habits.indexWhere((h) => h.id == habit.id);
      if (habitIndex != -1) {
        habits[habitIndex] = updatedHabit;
      }
    });

    // Update the habit in the database
    await DatabaseHelper.instance.updateHabit(updatedHabit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Tracker'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Padding(
              padding: EdgeInsets.only(right: 22.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: List.generate(
                  5,
                  (index) {
                    final date = DateTime.now().subtract(Duration(days: 4 - index));
                    return Container(
                      width: 20,
                      height: 20,
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: Text(
                          _getDayAbbreviation(date.weekday), // Change this line
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
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
                        onTap: () => _toggleHabitCompletion(habit, i),
                        child: Container(
                          width: 20,
                          height: 20,
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: habit.completionStatus[i]
                                ? Colors.green
                                : Colors.red,
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
          ),
        ],
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
        child: Center(
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  String _getDayAbbreviation(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'M';
      case DateTime.tuesday:
        return 'T';
      case DateTime.wednesday:
        return 'W';
      case DateTime.thursday:
        return 'T';
      case DateTime.friday:
        return 'F';
      case DateTime.saturday:
        return 'S';
      case DateTime.sunday:
        return 'S';
      default:
        return '';
    }
  }
}
