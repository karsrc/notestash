import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> goals = [];

  void _addTestGoal() {
    setState(() {
      goals.add({
        'title': 'Go for a walk',
        'time': '15:30 - Today',
        'color': Colors.red,
        'done': true,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
      ),
      body: ListView.builder(
        itemCount: goals.length,
        itemBuilder: (context, index) {
          final goal = goals[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: goal['color'],
            ),
            title: Text(goal['title']),
            subtitle: Text(goal['time']),
            trailing: Icon(
              goal['done'] ? Icons.check_circle : Icons.radio_button_unchecked,
              color: goal['done'] ? Colors.green : Colors.grey,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTestGoal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
