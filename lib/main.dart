import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'plus.dart';
import 'app_colors.dart';
import 'theme.dart';
import 'calendar.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.system,
    theme: lightTheme,
    darkTheme: darkTheme,
    home: const GoalsPage(),
  ));
}

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  final List<Map<String, dynamic>> allGoals = [];

  final PageController _pageController = PageController();
  int currentTabIndex = 0;

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

  void _onTabTap(int index) {
    setState(() => currentTabIndex = index);
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final primary = theme.primaryColor;
    final bgColor = theme.scaffoldBackgroundColor;
    final iconColor = theme.iconTheme.color ?? primary;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                          onTap: () => _onTabTap(0),
                          child: buildTab(context, "Main Page",
                              active: currentTabIndex == 0),
                        ),
                        GestureDetector(
                          onTap: () => _onTabTap(1),
                          child: buildTab(context, "Analytics",
                              active: currentTabIndex == 1),
                        ),
                        GestureDetector(
                          onTap: () => _onTabTap(2),
                          child: buildTab(context, "Calendar",
                              active: currentTabIndex == 2),
                        ),
                        GestureDetector(
                          onTap: () => _onTabTap(3),
                          child: buildTab(context, "PDF reader",
                              active: currentTabIndex == 3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildMainGoalsContent(theme, textColor),
                  const Center(child: Text("Analytics Page")),
                  const CalendarPage(),
                  const Center(child: Text("PDF Reader Placeholder")),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: theme.bottomAppBarTheme.color,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: Icon(Icons.bar_chart, color: iconColor),
                  onPressed: () {}),
              const SizedBox(width: 40),
              IconButton(
                  icon: Icon(Icons.person, color: iconColor),
                  onPressed: () {}),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: theme.textTheme.bodyMedium?.color,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            Icons.add,
            color: theme.bottomAppBarTheme.color,
          ),
          onPressed: _onAddGoal,
        ),
      ),
    );
  }

  Widget _buildMainGoalsContent(ThemeData theme, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
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
                style: TextStyle(
                    fontSize: 16,
                    color: theme.textTheme.bodySmall?.color),
              ),
            )
                : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
              ),
              itemCount: todayGoals.length,
              itemBuilder: (context, index) {
                final goal = todayGoals[index];
                return buildGoalCard(goal, context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGoalCard(Map<String, dynamic> goal, BuildContext context) {
    final String title = goal['title'] ?? 'Untitled';
    final bool isHabit = goal['isHabit'] ?? false;
    final int total = goal['total'] ?? 100;
    final int dailyTarget = goal['dailyTarget'] ?? 10;
    final int progress = goal['progress'] ?? 0;
    final String unit = goal['unit'] ?? '';
    final Color color = goal['color'] ?? Theme.of(context).primaryColor;
    final IconData icon = goal['icon'] ?? Icons.flag;

    final int showTotal = isHabit ? dailyTarget : total;
    final String label = "$progress / $showTotal ${isHabit ? '' : unit}";

    Color darken(Color c, [double amount = 0.3]) {
      final hsl = HSLColor.fromColor(c);
      return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
    }

    final Color textColor = darken(color, 0.3);

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
              Text(label, style: TextStyle(fontSize: 12, color: textColor)),
            ],
          )
        ],
      ),
    );
  }
}

Widget buildTab(BuildContext context, String label, {bool active = false}) {
  final theme = Theme.of(context);
  final Color primary = theme.primaryColor;
  final Color inactiveBg = theme.scaffoldBackgroundColor;
  final Color activeText = theme.textTheme.bodyLarge?.color ?? Colors.white;
  final Color inactiveText = primary;
  final Color borderColor = primary.withOpacity(0.8);

  return Padding(
    padding: const EdgeInsets.only(right: 12),
    child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: active ? primary : inactiveBg,
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
