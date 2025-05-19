import 'package:flutter/material.dart';

class AddGoalPage extends StatefulWidget {
  const AddGoalPage({super.key});

  @override
  State<AddGoalPage> createState() => _AddGoalPageState();
}

class _AddGoalPageState extends State<AddGoalPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _dailyTargetController = TextEditingController();

  Color selectedColor = const Color(0xFF999DF6);
  IconData selectedIcon = Icons.flag;
  bool isRepetitive = false;
  bool isHabit = false;
  String selectedUnit = 'pages';
  List<String> selectedWeekDays = [];

  final List<String> units = [
    'pages',
    'ml',
    'km',
    'minutes',
    'calories',
  ];

  final darkText = const Color(0xFF2F3A5A);

  final List<Color> pastelColors = [
    Color(0xFF999DF6),
    Color(0xFFF6BF2E),
    Color(0xFFF7D98A),
    Color(0xFFD1E8F5),
    Color(0xFFB2E4D5),
    Color(0xFFF9D3C8),
    Color(0xFFE4D7F2),
    Color(0xFFF4E1E6),
    Color(0xFFFCEEDA),
  ];

  final List<IconData> icons = [
    Icons.directions_run,
    Icons.book,
    Icons.local_drink,
    Icons.fastfood,
    Icons.bedtime,
    Icons.self_improvement,
    Icons.headphones,
    Icons.check,
    Icons.fitness_center,
    Icons.lunch_dining,
    Icons.spa,
    Icons.timer,
    Icons.bubble_chart,
    Icons.brightness_7,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F1E9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Text(
                "Let's start a new goal",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: darkText),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                maxLength: 20,
                decoration: InputDecoration(
                  labelText: "Goal name",
                  border: const OutlineInputBorder(),
                  labelStyle: TextStyle(color: darkText),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Description (optional)",
                  border: const OutlineInputBorder(),
                  labelStyle: TextStyle(color: darkText),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Repeat?", style: TextStyle(fontSize: 16, color: darkText)),
                  Switch(
                    value: isRepetitive,
                    activeColor: Color(0xFF999DF6),
                    onChanged: (val) => setState(() => isRepetitive = val),
                  ),
                ],
              ),

              if (isRepetitive)
                Wrap(
                  spacing: 10,
                  children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                      .map((day) => ChoiceChip(
                    label: Text(day),
                    selected: selectedWeekDays.contains(day),
                    selectedColor: Color(0xFF999DF6),
                    onSelected: (selected) {
                      setState(() {
                        selected
                            ? selectedWeekDays.add(day)
                            : selectedWeekDays.remove(day);
                      });
                    },
                  ))
                      .toList(),
                ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Track as habit?", style: TextStyle(fontSize: 16, color: darkText)),
                  Switch(
                    value: isHabit,
                    activeColor: Color(0xFF999DF6),
                    onChanged: (val) => setState(() => isHabit = val),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Text("Set goal details:", style: TextStyle(color: darkText, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _totalAmountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Total",
                        labelStyle: TextStyle(color: darkText),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedUnit,
                      items: units.map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => selectedUnit = val!),
                      decoration: InputDecoration(
                        labelText: "Unit",
                        labelStyle: TextStyle(color: darkText),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _dailyTargetController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Per day",
                        labelStyle: TextStyle(color: darkText),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              Text("Pick a color:", style: TextStyle(color: darkText)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: pastelColors.map((color) {
                  return GestureDetector(
                    onTap: () => setState(() => selectedColor = color),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: selectedColor == color
                            ? Border.all(width: 3, color: darkText)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),
              Text("Pick an icon:", style: TextStyle(color: darkText)),
              const SizedBox(height: 12),

              Wrap(
                spacing: 18,
                runSpacing: 18,
                children: icons.map((icon) {
                  return GestureDetector(
                    onTap: () => setState(() => selectedIcon = icon),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: selectedIcon == icon ? darkText : Colors.grey[300],
                      child: Icon(icon, color: Colors.white, size: 28),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 36),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkText,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.pop(context, {
                    'name': _nameController.text.trim(),
                    'description': _descController.text.trim(),
                    'color': selectedColor,
                    'icon': selectedIcon,
                    'interval': isHabit
                        ? 'habit'
                        : isRepetitive
                        ? 'custom'
                        : 'once',
                    'weekDays': selectedWeekDays,
                    'isHabit': isHabit,
                    'progress': 0,
                    'total': int.tryParse(_totalAmountController.text) ?? 100,
                    'dailyTarget': int.tryParse(_dailyTargetController.text) ?? 10,
                    'unit': selectedUnit,
                  });
                },
                child: const Text("Create Goal", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
