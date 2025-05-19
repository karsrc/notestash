import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'plus.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: const Color(0xFFF8F1E9),
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: const Color(0xFF3C4F76),
        displayColor: const Color(0xFF3C4F76),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: Color(0xFF3C4F76)),
        hintStyle: TextStyle(color: Color(0xFF3C4F76)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF3C4F76)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF3C4F76), width: 2),
        ),
      ),
    ),
    home: const GoalsPage(),
  ));
}

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  final Color highlightColor = const Color(0xFFC3CBF7);
  final Color backgroundColor = const Color(0xFFF8F1E9);
  final Color headerTextColor = const Color(0xFF3A3F5F);
  final Color textDarkBlue = const Color(0xFF2F3A5A);

  List<Map<String, dynamic>> allGoals = [];

  // 🔽 Get today (Mon, Tue...) from phone
  String get currentDay => DateFormat('E').format(DateTime.now());

  List<Map<String, dynamic>> get todayGoals {
    return allGoals.where((goal) {
      final interval = goal['interval'] ?? 'once';
      final bool isHabit = goal['isHabit'] ?? false;

      if (isHabit) return true;

      if (interval == 'custom') {
        final List<dynamic> days = goal['weekDays'] ?? [];
        return days.contains(currentDay);
      }

      if (interval == 'once') {
        final DateTime? addedOn = goal['addedOn'];
        if (addedOn == null) return false;
        final now = DateTime.now();
        return addedOn.year == now.year &&
            addedOn.month == now.month &&
            addedOn.day == now.day;
      }

      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    CircleAvatar(radius: 16, backgroundColor: Colors.grey),
                    Row(
                      children: [
                        Icon(Icons.search, size: 28),
                        SizedBox(width: 16),
                        Icon(Icons.menu, size: 28),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Welcome,\n(User name)",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: headerTextColor,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Tabs
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      buildTab("Main Page", active: true),
                      buildTab("Analytics"),
                      buildTab("Calendar"),
                      buildTab("PDF reader"),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Calendar
                TableCalendar(
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2100, 12, 31),
                  focusedDay: DateTime.now(),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: highlightColor,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: highlightColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Goals header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your goals for today",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: headerTextColor,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AddGoalPage()),
                        );

                        if (result != null && result is Map<String, dynamic>) {
                          setState(() {
                            result['addedOn'] = DateTime.now(); // used for "once" goal
                            allGoals.add(result);
                          });
                        }
                      },
                    )
                  ],
                ),

                const SizedBox(height: 16),

                // Show goals
                todayGoals.isEmpty
                    ? Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Text(
                    "No goals for today. Tap + to add one!",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                )
                    : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                  ),
                  itemCount: todayGoals.length,
                  itemBuilder: (context, index) {
                    final goal = todayGoals[index];
                    return buildGoalCard(goal);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTab(String label, {bool active = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: active ? highlightColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Color darken(Color color, [double amount = 0.3]) {
    final hsl = HSLColor.fromColor(color);
    final darker = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darker.toColor();
  }

  Widget buildGoalCard(Map<String, dynamic> goal) {
    final String title = goal['name'];
    final bool isHabit = goal['isHabit'] ?? false;
    final int total = goal['total'] ?? 100;
    final int progress = goal['progress'] ?? 0;
    final int dailyTarget = goal['dailyTarget'] ?? 10;
    final String unit = goal['unit'] ?? '';
    final Color color = goal['color'] as Color;
    final IconData icon = goal['icon'] as IconData;
    final textColor = darken(color, 0.3);

    final int showTotal = isHabit ? dailyTarget : total;
    final String label = "$progress / $showTotal $unit";

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: (progress / showTotal).clamp(0.0, 1.0),
                backgroundColor: Colors.white.withOpacity(0.4),
                color: textColor,
                minHeight: 6,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: textColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}
