import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<DateTime, List<Map<String, dynamic>>> events = {};
  int selectedTab = 0;
  final List<Map<String, dynamic>> reminders = [];

  Future<void> _navigateToAddReminder() async {
    final reminder = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Plus()),
    );

    if (reminder != null) {
      setState(() {
        final dateKey = DateTime(
          reminder['date'].year,
          reminder['date'].month,
          reminder['date'].day,
        );

        if (!events.containsKey(dateKey)) {
          events[dateKey] = [];
        }
        events[dateKey]!.add(reminder);
        reminders.add({
          ...reminder,
          'done': false,
          'color': Colors.primaries[reminders.length % Colors.primaries.length],
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final greetings = DateTime.now().hour < 12
        ? "Good Morning!"
        : DateTime.now().hour < 18
        ? "Good Afternoon!"
        : "Good Evening!";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          backgroundColor: Colors.black38,
          title: const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              "notestash.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.search, color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: _navigateToAddReminder,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.black38,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text("MAIN", style: TextStyle(color: Colors.white)),
                  Text("CAL", style: TextStyle(color: Colors.white)),
                  Text("PDF", style: TextStyle(color: Colors.white)),
                  Text("NOTE", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              color: Colors.grey[100],
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    greetings,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 400,
                    width: double.infinity,
                    color: Colors.white,
                    child: TableCalendar(
                      firstDay: DateTime.utc(2000, 1, 1),
                      lastDay: DateTime.utc(2100, 12, 31),
                      focusedDay: DateTime.now(),
                      eventLoader: (day) {
                        final key = DateTime(day.year, day.month, day.day);
                        return events[key] ?? [];
                      },
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, date, remindersForDay) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: remindersForDay.take(3).map((event) {
                              final reminder = event as Map<String, dynamic>;
                              final color = (reminder['color'] ?? Colors.orange) as Color;
                              return Container(
                                width: 6,
                                height: 6,
                                margin: const EdgeInsets.symmetric(horizontal: 1),
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      calendarStyle: const CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Colors.deepOrange,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Colors.black38,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: reminders.map((reminder) {
                      final title = reminder['title'];
                      final time = reminder['time'].format(context);
                      final date = reminder['date'].toString().split(' ')[0];
                      final color = reminder['color'] as Color;
                      final done = reminder['done'] as bool;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 5,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      decoration: done ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                  Text(
                                    "$time – $date",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  reminder['done'] = !done;
                                  reminders.remove(reminder);
                                  reminders.add(reminder);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: done ? color : Colors.grey[400],
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(6),
                                child: Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}