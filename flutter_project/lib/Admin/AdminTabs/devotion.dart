import 'package:flutter/material.dart';

class AddDailyDevotionalTab extends StatefulWidget {
  const AddDailyDevotionalTab({super.key});

  @override
  _AddDailyDevotionalTabState createState() => _AddDailyDevotionalTabState();
}

class _AddDailyDevotionalTabState extends State<AddDailyDevotionalTab> {
  // Controller for the Date TextField
  TextEditingController _dateController = TextEditingController();

  // Function to show Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        // Format the selected date and update the controller text
        _dateController.text =
            '${pickedDate.toLocal()}'.split(' ')[0]; // Example: 2024-11-28
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Add Daily Devotional',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Date Field with Date Picker
              const Text(
                'Date',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => _selectDate(context), // Trigger date picker
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      hintText: 'Select Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title Field
              const Text(
                'Title',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Bible Verse Field
              const Text(
                'Bible Verse',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Bible Verse',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Body Field with Adjusted Height
              const Text(
                'Body',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                maxLines: 15, // Adjust height by increasing maxLines
                minLines: 6, // Set minimum lines for height
                decoration: InputDecoration(
                  hintText: 'Enter Devotional Body...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Buttons Section
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle Clear logic
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text(
                      'Clear',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB4BA1C),
                      minimumSize: const Size(100, 40),
                      foregroundColor: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle Save logic
                    },
                    icon: const Icon(Icons.save),
                    label: const Text(
                      'Save',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB4BA1C),
                      minimumSize: const Size(100, 40),
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
