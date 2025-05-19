import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'plus.dart';

final ThemeData _lightTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFF8F1E9),
  primaryColor: const Color(0xFF3C4F76),
  iconTheme: const IconThemeData(color: Color(0xFF3C4F76)),
  textTheme: ThemeData.light().textTheme.apply(
    bodyColor: Color(0xFF3C4F76),
    displayColor: Color(0xFF3C4F76),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Color(0xFFF1E8E2),
    elevation: 0,
  ),
);

final ThemeData _darkTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFF2B2739),
  primaryColor: const Color(0xFFE5E4F0),
  iconTheme: const IconThemeData(color: Color(0xFFE5E4F0)),
  textTheme: ThemeData.dark().textTheme.apply(
    bodyColor: Color(0xFFE5E4F0),
    displayColor: Color(0xFFB9B7C9),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Color(0xFF7566EA),
    elevation: 0,
  ),
);

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.system,
    theme: _lightTheme,
    darkTheme: _darkTheme,
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
  final List<Map<String, dynamic>> allGoals = [];

  String get currentDay => DateFormat('E').format(DateTime.now());

  String get dynamicGreeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good morning";
    if (hour < 18) return "Good afternoon";
    return "Good evening";
  }

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

  void _onAddGoal() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddGoalPage()),
    );
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        result['addedOn'] = DateTime.now();
        allGoals.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final iconColor = isDark
        ? const Color(0xFFFFF4EC)
        : const Color(0xFF4F5267);

    final fabBackground = isDark
        ? const Color(0xFF7566EA)
        : const Color(0xFFF1E8E2);

    final fabIcon = isDark
        ? const Color(0xFFFFF4EC)
        : const Color(0xFF4F5267);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                    "$dynamicGreeting,\n(User name)",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

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

                TableCalendar(
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2100, 12, 31),
                  focusedDay: DateTime.now(),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                  ),
                  calendarStyle: CalendarStyle(
                    weekendTextStyle: TextStyle(color: textColor),
                    defaultTextStyle: TextStyle(color: textColor),
                    todayDecoration: BoxDecoration(color: highlightColor, shape: BoxShape.circle),
                    selectedDecoration: BoxDecoration(color: highlightColor, shape: BoxShape.circle),
                  ),
                ),

                const SizedBox(height: 24),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Your goals for today",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

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

      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.bar_chart, color: iconColor),
                onPressed: () {},
              ),
              const SizedBox(width: 40),
              IconButton(
                icon: Icon(Icons.person, color: iconColor),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: fabBackground,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(Icons.add, color: fabIcon),
          onPressed: _onAddGoal,
        ),
      ),
    );
  }
}


Widget buildTab(String label, {bool active = false}) {
  return Padding(
    padding: const EdgeInsets.only(right: 12),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFC3CBF7) : Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
  );
}

Color darken(Color color, [double amount = 0.3]) {
  final hsl = HSLColor.fromColor(color);
  return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
}

Widget buildGoalCard(Map<String, dynamic> goal) {
  final String title = goal['name'];
  final bool isHabit = goal['isHabit'] ?? false;
  final int total = goal['total'] ?? 100;
  final int dailyTarget = goal['dailyTarget'] ?? 10;
  final int progress = goal['progress'] ?? 0;
  final String unit = goal['unit'] ?? '';
  final Color color = goal['color'] as Color;
  final IconData icon = goal['icon'] as IconData;

  final int showTotal = isHabit ? dailyTarget : total;
  final textColor = darken(color);
  final String label = "$progress / $showTotal $unit";

  return Container(
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
    padding: const EdgeInsets.all(16),
    child: Stack(
      children: [
        Align(alignment: Alignment.topRight, child: Icon(icon, color: Colors.white, size: 20)),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: (progress / showTotal).clamp(0.0, 1.0),
              backgroundColor: Colors.white.withOpacity(0.4),
              color: textColor,
              minHeight: 6,
            ),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: textColor)),
          ],
        ),
      ],
    ),
  );
}
