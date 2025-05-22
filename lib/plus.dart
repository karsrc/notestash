import 'package:flutter/material.dart';
import 'app_colors.dart';

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

  String selectedUnit = 'pages';
  bool isHabit = true;

  IconData selectedIcon = Icons.flag;
  Color selectedColor = const Color(0xFF999DF6);
  String selectedInterval = 'Every day';
  List<String> selectedDays = [];

  final List<String> intervals = ['Every day', 'Weekdays', 'Weekends', 'Custom'];
  final List<String> units = ['pages', 'ml', 'km', 'minutes', 'calories'];
  final List<IconData> icons = [
    Icons.book,
    Icons.favorite,
    Icons.person,
    Icons.shopping_bag,
    Icons.coffee,
    Icons.flash_on,
    Icons.pets,
    Icons.fitness_center,
    Icons.bubble_chart,
    Icons.music_note,
    Icons.spa,
    Icons.lightbulb,
  ];

  Color get primaryTextColor =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFF9F1E8)
          : const Color(0xFF3C4F76);

  Color get secondaryTextColor =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFF5F0D9)
          : const Color(0xFFB9B7C9);

  OutlineInputBorder getBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: secondaryTextColor),
      borderRadius: BorderRadius.circular(12),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _totalAmountController.dispose();
    _dailyTargetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    final colorPalette = [
      appColors.rose,
      appColors.coral,
      appColors.peach,
      appColors.sand,
      appColors.mint,
      appColors.sage,
      appColors.fog,
      appColors.steel,
      appColors.lavender,
      appColors.lilac,
      appColors.wine,
      appColors.slate,
      appColors.gold,
      appColors.seafoam,
    ];

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: primaryTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Let's start a new goal",
          style: TextStyle(color: primaryTextColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Name",
              hintText: "Type goal name",
              labelStyle: TextStyle(color: secondaryTextColor),
              hintStyle: TextStyle(color: secondaryTextColor),
              border: getBorder(),
              enabledBorder: getBorder(),
              focusedBorder: getBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descController,
            decoration: InputDecoration(
              labelText: "Description",
              hintText: "Describe your goal",
              labelStyle: TextStyle(color: secondaryTextColor),
              hintStyle: TextStyle(color: secondaryTextColor),
              border: getBorder(),
              enabledBorder: getBorder(),
              focusedBorder: getBorder(),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedInterval,
            items: intervals.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value, style: TextStyle(color: primaryTextColor)),
              );
            }).toList(),
            onChanged: (val) {
              setState(() => selectedInterval = val!);
            },
            decoration: InputDecoration(
              labelText: "Repeat Interval",
              labelStyle: TextStyle(color: secondaryTextColor),
              border: getBorder(),
              enabledBorder: getBorder(),
              focusedBorder: getBorder(),
            ),
            dropdownColor: scaffoldBg,
          ),

          if (selectedInterval == 'Custom')
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Wrap(
                spacing: 10,
                runSpacing: 8,
                children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
                  final isSelected = selectedDays.contains(day);
                  return ChoiceChip(
                    label: Text(day),
                    selected: isSelected,
                    selectedColor: selectedColor.withOpacity(0.6),
                    onSelected: (selected) {
                      setState(() {
                        selected
                            ? selectedDays.add(day)
                            : selectedDays.remove(day);
                      });
                    },
                    backgroundColor: scaffoldBg,
                    labelStyle: TextStyle(color: primaryTextColor),
                    shape: StadiumBorder(
                      side: BorderSide(color: selectedColor),
                    ),
                  );
                }).toList(),
              ),
            ),

          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Track as habit?",
                  style: TextStyle(color: primaryTextColor, fontWeight: FontWeight.w500)),
              Switch(
                value: isHabit,
                activeColor: selectedColor,
                onChanged: (val) => setState(() => isHabit = val),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text("Set goal details:", style: TextStyle(color: primaryTextColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              if (!isHabit)
                Expanded(
                  child: TextField(
                    controller: _totalAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Total",
                      hintText: "100",
                      labelStyle: TextStyle(color: secondaryTextColor),
                      hintStyle: TextStyle(color: secondaryTextColor),
                      border: getBorder(),
                      enabledBorder: getBorder(),
                      focusedBorder: getBorder(),
                    ),
                  ),
                ),
              if (!isHabit) const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _dailyTargetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Per day",
                    hintText: "10",
                    labelStyle: TextStyle(color: secondaryTextColor),
                    hintStyle: TextStyle(color: secondaryTextColor),
                    border: getBorder(),
                    enabledBorder: getBorder(),
                    focusedBorder: getBorder(),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          Text("Pick a color", style: TextStyle(color: primaryTextColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: colorPalette.map((color) {
              return GestureDetector(
                onTap: () => setState(() => selectedColor = color),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: selectedColor == color
                        ? Border.all(color: primaryTextColor, width: 3)
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),
          Text("Pick an icon", style: TextStyle(color: primaryTextColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            physics: const NeverScrollableScrollPhysics(),
            children: icons.map((icon) {
              final isSelected = selectedIcon == icon;
              return GestureDetector(
                onTap: () => setState(() => selectedIcon = icon),
                child: Container(
                  decoration: BoxDecoration(
                    color: scaffoldBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? selectedColor : secondaryTextColor,
                      width: isSelected ? 3 : 1.2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: isSelected ? selectedColor : primaryTextColor,
                      size: 26,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              final goal = {
                'title': _nameController.text.trim(),
                'description': _descController.text.trim(),
                'icon': selectedIcon,
                'color': selectedColor,
                'interval': selectedInterval == 'Custom' ? 'custom' : selectedInterval.toLowerCase(),
                'weekDays': selectedInterval == 'Custom' ? selectedDays : null,
                'isHabit': isHabit,
                'dailyTarget': int.tryParse(_dailyTargetController.text) ?? 10,
                'total': isHabit ? null : int.tryParse(_totalAmountController.text) ?? 100,
                'unit': null,
                'addedOn': DateTime.now(),
                'progress': 0,
              };
              Navigator.pop(context, goal);
            },
            child: const Text("Save Goal", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}

