import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDate = DateTime.now();

  final List<Map<String, dynamic>> mockEvents = [
    {
      'title': 'Chemistry',
      'start': DateTime(2025, 5, 23, 7, 0),
      'end': DateTime(2025, 5, 23, 8, 15),
      'color': const Color(0xFFB3E5FC),
    },
    {
      'title': 'English',
      'start': DateTime(2025, 5, 23, 8, 25),
      'end': DateTime(2025, 5, 23, 9, 45),
      'color': const Color(0xFFFFCC80),
    },
    {
      'title': 'Short test',
      'start': DateTime(2025, 5, 23, 8, 25),
      'end': DateTime(2025, 5, 23, 9, 45),
      'color': const Color(0xFFCE93D8),
    },
    {
      'title': 'Polish',
      'start': DateTime(2025, 5, 23, 9, 45),
      'end': DateTime(2025, 5, 23, 10, 0),
      'color': const Color(0xFFFFFF8D),
    },
  ];

  void _changeWeek(int direction) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: direction * 7));
    });
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  List<DateTime> get currentWeek {
    final start = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }

  List<Map<String, dynamic>> get eventsToday {
    return mockEvents.where((e) {
      final d = e['start'] as DateTime;
      return d.year == selectedDate.year &&
          d.month == selectedDate.month &&
          d.day == selectedDate.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.white;
    final bgColor = theme.scaffoldBackgroundColor;

    return Container(
      color: bgColor,
      child: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: const Icon(Icons.arrow_left), onPressed: () => _changeWeek(-1)),
                GestureDetector(
                  onTap: _pickDate,
                  child: Text(
                    DateFormat("EEEE, d'th of' MMMM y").format(selectedDate),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(icon: const Icon(Icons.arrow_right), onPressed: () => _changeWeek(1)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: currentWeek.map((date) {
                final isSelected = date.day == selectedDate.day &&
                    date.month == selectedDate.month &&
                    date.year == selectedDate.year;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedDate = date),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? theme.primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            DateFormat('E').format(date).toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: isSelected ? 14 : 12,
                              color: isSelected ? Colors.white : textColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isSelected ? 16 : 14,
                              color: isSelected ? Colors.white : textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: 48,
                  itemBuilder: (context, index) {
                    final hour = index ~/ 2;
                    final minute = (index % 2) * 30;
                    final time = TimeOfDay(hour: hour, minute: minute);
                    final label = time.format(context);

                    return SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(label, style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.6))),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: textColor.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ...eventsToday.map((event) {
                  final DateTime start = event['start'];
                  final DateTime end = event['end'];
                  final String title = event['title'];
                  final color = event['color'] ?? theme.primaryColor;

                  final totalMinutesFromStart = start.hour * 60 + start.minute;
                  final durationMinutes = end.difference(start).inMinutes;

                  final double topOffset = (totalMinutesFromStart / 30) * 40;
                  final double height = (durationMinutes / 30) * 40;

                  return Positioned(
                    top: topOffset,
                    left: 70,
                    right: 12,
                    child: Container(
                      height: height,
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          if (durationMinutes > 30)
                            Text(
                              '${DateFormat.Hm().format(start)} - ${DateFormat.Hm().format(end)}',
                              style: const TextStyle(fontSize: 11),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
