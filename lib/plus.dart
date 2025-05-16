import 'package:flutter/material.dart';

class Plus extends StatefulWidget {
  const Plus({super.key});

  @override
  State<Plus> createState() => _PlusState();
}

class _PlusState extends State<Plus> {
  String? selectedOption;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  void saveReminder() {
    if (titleController.text.trim().isEmpty || selectedDate == null || selectedTime == null) {
      return;
    }

    final reminder = {
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'date': selectedDate,
      'time': selectedTime,
    };

    Navigator.pop(context, reminder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("notestash."),
        backgroundColor: Colors.black54,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButton<String>(
              value: selectedOption,
              hint: const Text("Select an option"),
              items: const [
                DropdownMenuItem(value: "Reminder", child: Text("Add a Reminder")),
              ],
              onChanged: (value) {
                setState(() => selectedOption = value);
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: titleController,
              maxLength: 30,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              maxLength: 200,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() => selectedDate = picked);
                }
              },
              child: Text(selectedDate == null ? "Select Date" : selectedDate.toString().split(' ')[0]),
            ),
            ElevatedButton(
              onPressed: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() => selectedTime = picked);
                }
              },
              child: Text(selectedTime == null ? "Select Time" : selectedTime!.format(context)),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: saveReminder,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}