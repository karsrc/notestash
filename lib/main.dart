import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'plus.dart';
import 'app_colors.dart';
import 'theme.dart';

final ThemeData _lightTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFF8F1E9),
  primaryColor: const Color(0xFFC3CCF7),
  iconTheme: const IconThemeData(color: Color(0xFF3C4F76)),
  textTheme: ThemeData.light().textTheme.apply(
    bodyColor: const Color(0xFF3C4F76),
    displayColor: const Color(0xFF3C4F76),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Color(0xFFC3CCF7),
    elevation: 0,
  ),
  extensions: <ThemeExtension<dynamic>>[
    const AppColors(
      rose: Color(0xFFD99FA6),
      coral: Color(0xFFF4A896),
      peach: Color(0xFFF5C6AA),
      sand: Color(0xFFE8B888),
      mint: Color(0xFFC7D8B6),
      sage: Color(0xFFAAC3A7),
      fog: Color(0xFFD6DBE1),
      steel: Color(0xFFA1B2C6),
      lavender: Color(0xFFB6A6D8),
      lilac: Color(0xFFD1B9E2),
      wine: Color(0xFF8D5D67),
      slate: Color(0xFF5A7684),
      gold: Color(0xFFAA8C5F),
      seafoam: Color(0xFF99C1B1),
    ),
  ],
);

final ThemeData _darkTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFF2B2739),
  primaryColor: const Color(0xFF7566EA),
  iconTheme: const IconThemeData(color: Color(0xFFE5E4F0)),
  textTheme: ThemeData.dark().textTheme.apply(
    bodyColor: const Color(0xFFE5E4F0),
    displayColor: const Color(0xFFE5E4F0),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Color(0xFF7566EA),
    elevation: 0,
  ),
  extensions: <ThemeExtension<dynamic>>[
    const AppColors(
      rose: Color(0xFFD99FA6),
      coral: Color(0xFFF4A896),
      peach: Color(0xFFF5C6AA),
      sand: Color(0xFFE8B888),
      mint: Color(0xFFC7D8B6),
      sage: Color(0xFFAAC3A7),
      fog: Color(0xFFD6DBE1),
      steel: Color(0xFFA1B2C6),
      lavender: Color(0xFFB6A6D8),
      lilac: Color(0xFFD1B9E2),
      wine: Color(0xFF8D5D67),
      slate: Color(0xFF5A7684),
      gold: Color(0xFFAA8C5F),
      seafoam: Color(0xFF99C1B1),
    ),
  ],
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

  Color get primaryTextColor =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFF9F1E8) // rgba(249,241,232,255)
          : const Color(0xFF3C4F76);

  Color get secondaryTextColor =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFF5F0D9) // rgba(245,240,217,255)
          : const Color(0xFFB9B7C9);

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? const Color(0xFFFFF4EC) : const Color(0xFF4F5267);
    final fabBackground = isDark ? const Color(0xFF7566EA) : const Color(0xFFF1E8E2);
    final fabIcon = isDark ? const Color(0xFFFFF4EC) : const Color(0xFF4F5267);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.search, size: 28, color: iconColor),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "$dynamicGreeting,\n(User name)",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      buildTab(context, "Main Page", active: true),
                      buildTab(context, "Analytics"),
                      buildTab(context, "Calendar"),
                      buildTab(context, "PDF reader"),
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
                    titleTextStyle: TextStyle(
                      color: primaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    weekendTextStyle: TextStyle(color: primaryTextColor),
                    defaultTextStyle: TextStyle(color: primaryTextColor),
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Your goals for today",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: primaryTextColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                todayGoals.isEmpty
                    ? Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Text(
                    "No goals for today. Tap + to add one!",
                    style: TextStyle(
                      fontSize: 16,
                      color: secondaryTextColor,
                    ),
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
        color: isDark ? const Color(0xFF7566EA) : const Color(0xFFC3CCF7),
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

  Widget buildGoalCard(Map<String, dynamic> goal) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Colors.black12 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF7566EA)
              : const Color(0xFF3B4E75),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(goal['icon'] ?? Icons.flag, size: 28, color: primaryTextColor),
          const SizedBox(height: 8),
          Text(
            goal['title'] ?? 'Untitled',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryTextColor,
            ),
          ),
          const Spacer(),
          Text(
            goal['unit'] != null ? "0 / ${goal['unit']}" : "In Progress",
            style: TextStyle(
              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildTab(BuildContext context, String label, {bool active = false}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final Color activeBg = isDark ? const Color(0xFF7566EA) : const Color(0xFFC3CCF7);
  final Color inactiveBg = isDark ? Colors.transparent : const Color(0xFFF8F1E9);
  final Color activeText = isDark ? const Color(0xFFE5E4F0) : Colors.white;
  final Color inactiveText = isDark ? const Color(0xFF7566EA) : const Color(0xFF3C4F76);
  final Color borderColor = isDark ? const Color(0xFF7566EA) : const Color(0xFF3B4E75);

  return Padding(
    padding: const EdgeInsets.only(right: 12),
    child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: active ? activeBg : inactiveBg,
        borderRadius: BorderRadius.circular(20),
        border: active ? null : Border.all(color: borderColor, width: 1.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: active ? activeText : inactiveText,
        ),
      ),
    ),
  );
}
