import 'package:flutter/material.dart';
import 'screens/habit_list_screen.dart';
import 'screens/edit_habit_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HabitListScreen(),
      routes: {
        '/edit_habit': (context) => EditHabitScreen(),
      },
    );
  }
}
