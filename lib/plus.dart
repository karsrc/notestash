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

  IconData selectedIcon = Icons.flag;
  Color selectedColor = const Color(0xFF999DF6);
  String selectedInterval = 'Every day';
  List<String> selectedDays = [];

  final List<String> intervals = ['Every day', 'Weekdays', 'Weekends', 'Custom'];
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
          ? const Color(0xFFF9F1E8) // rgba(249,241,232,255)
          : const Color(0xFF3C4F76);

  Color get secondaryTextColor =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFF5F0D9) // rgba(245,240,217,255)
          : const Color(0xFFB9B7C9);

  OutlineInputBorder getBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: secondaryTextColor),
      borderRadius: BorderRadius.circular(12),
    );
  }

  Future<void> showCustomDaySelector() async {
    final options = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Days'),
          content: Wrap(
            spacing: 10,
            children: options.map((day) {
              final selected = selectedDays.contains(day);
              return ChoiceChip(
                label: Text(day),
                selected: selected,
                onSelected: (value) {
                  setState(() {
                    value ? selectedDays.add(day) : selectedDays.remove(day);
                  });
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Done"),
            )
          ],
        );
      },
    );
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
              labelStyle: TextStyle(color: secondaryTextColor),
              border: getBorder(),
              enabledBorder: getBorder(),
              focusedBorder: getBorder(),
              hintText: "Type goal name",
              hintStyle: TextStyle(color: secondaryTextColor),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descController,
            decoration: InputDecoration(
              labelText: "Description",
              labelStyle: TextStyle(color: secondaryTextColor),
              border: getBorder(),
              enabledBorder: getBorder(),
              focusedBorder: getBorder(),
              hintText: "Describe your goal",
              hintStyle: TextStyle(color: secondaryTextColor),
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
            onChanged: (val) async {
              if (val == 'Custom') {
                await showCustomDaySelector();
              }
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
                    color: selectedColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected ? Border.all(color: primaryTextColor, width: 3) : null,
                  ),
                  child: Center(child: Icon(icon, color: Colors.black, size: 30)),
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
                'title': _nameController.text,
                'description': _descController.text,
                'icon': selectedIcon,
                'color': selectedColor,
                'interval': selectedInterval == 'Custom' ? 'custom' : selectedInterval.toLowerCase(),
                'weekDays': selectedInterval == 'Custom' ? selectedDays : null,
                'isHabit': true,
                'addedOn': DateTime.now(),
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

