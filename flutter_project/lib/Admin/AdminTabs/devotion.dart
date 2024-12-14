import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDailyDevotionalTab extends StatefulWidget {
  const AddDailyDevotionalTab({super.key});

  @override
  _AddDailyDevotionalTabState createState() => _AddDailyDevotionalTabState();
}

class _AddDailyDevotionalTabState extends State<AddDailyDevotionalTab> {
  // Controllers for the form fields
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bibleVerseController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  // Function to show Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFFB4BA1C), // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFB4BA1C), // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            '${pickedDate.toLocal()}'.split(' ')[0]; // Format: YYYY-MM-DD
      });
    }
  }

  // Function to save data to Firestore
  Future<void> _saveDevotional() async {
    final String date = _dateController.text;
    final String title = _titleController.text;
    final String bibleVerse = _bibleVerseController.text;
    final String body = _bodyController.text;

    if (date.isEmpty || title.isEmpty || bibleVerse.isEmpty || body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required!')),
      );
      return;
    }

    try {
      // Save to Firestore
      await FirebaseFirestore.instance.collection('devotionals').add({
        'date': date,
        'title': title,
        'bible_verse': bibleVerse,
        'body': body,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the form fields
      _clearForm();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Devotional saved successfully!')),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving devotional: $e')),
      );
    }
  }

  // Function to clear form fields
  void _clearForm() {
    _dateController.clear();
    _titleController.clear();
    _bibleVerseController.clear();
    _bodyController.clear();
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
              const Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      hintText: 'Select Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              const Color(0xFFB4BA1C), // Focused border color
                        ),
                      ),
                    ),
                    cursorColor: const Color(0xFFB4BA1C), // Cursor color
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Title',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Enter Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: const Color(0xFFB4BA1C),
                    ),
                  ),
                ),
                cursorColor: const Color(0xFFB4BA1C),
              ),
              const SizedBox(height: 20),
              const Text('Bible Verse',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _bibleVerseController,
                decoration: InputDecoration(
                  hintText: 'Enter Bible Verse',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: const Color(0xFFB4BA1C),
                    ),
                  ),
                ),
                cursorColor: const Color(0xFFB4BA1C),
              ),
              const SizedBox(height: 20),
              const Text('Body', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _bodyController,
                maxLines: 15,
                minLines: 6,
                decoration: InputDecoration(
                  hintText: 'Enter Devotional Body...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: const Color(0xFFB4BA1C),
                    ),
                  ),
                ),
                cursorColor: const Color(0xFFB4BA1C),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: _clearForm,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear',
                        style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB4BA1C),
                      minimumSize: const Size(100, 40),
                      foregroundColor: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _saveDevotional,
                    icon: const Icon(Icons.save),
                    label: const Text('Save',
                        style: TextStyle(color: Colors.black)),
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
