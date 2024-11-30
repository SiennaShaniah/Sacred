import 'package:flutter/material.dart';

class DailyDevotionalListTab extends StatelessWidget {
  const DailyDevotionalListTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for daily devotionals
    final List<Map<String, String>> devotionals = [
      {
        "title": "Devotional Title 1",
        "date": "2024-11-28",
        "bibleVerse": "John 3:16",
        "body": "This is the body of the devotional.",
        "image": 'lib/Images/welcome.png', // Local image path
      },
      {
        "title": "Devotional Title 2",
        "date": "2024-11-27",
        "bibleVerse": "Psalm 23:1",
        "body": "This is the body of another devotional.",
        "image": 'lib/Images/welcome.png', // Local image path
      },
      {
        "title": "Devotional Title 3",
        "date": "2024-11-26",
        "bibleVerse": "Proverbs 3:5",
        "body": "This is a devotional body.",
        "image": 'lib/Images/welcome.png', // Local image path
      },
    ];

    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, top: 32.0),
            child: Text(
              'Daily Devotionals',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.75,
            ),
            itemCount: devotionals.length,
            itemBuilder: (context, index) {
              final devotional = devotionals[index];

              return Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                elevation: 3.0,
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(
                            devotional["image"]!,
                            width: double.infinity,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: PopupMenuButton<String>(
                            onSelected: (String value) {
                              if (value == 'edit') {
                                _showEditForm(context, devotional);
                              } else if (value == 'delete') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Deleting ${devotional["title"]}'),
                                  ),
                                );
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                const PopupMenuItem<String>(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit,
                                          color: Color(0xFFB4BA1C)),
                                      SizedBox(width: 8),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete,
                                          color: Color(0xFFB4BA1C)),
                                      SizedBox(width: 8),
                                      Text('Delete'),
                                    ],
                                  ),
                                ),
                              ];
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            devotional["title"]!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            devotional["date"]!,
                            style: const TextStyle(
                                fontSize: 14, color: Color(0xFFB4BA1C)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Function to show the edit form popup
  void _showEditForm(BuildContext context, Map<String, String> devotional) {
    final TextEditingController titleController =
        TextEditingController(text: devotional['title']);
    final TextEditingController bibleVerseController =
        TextEditingController(text: devotional['bibleVerse']);
    final TextEditingController bodyController =
        TextEditingController(text: devotional['body']);
    DateTime selectedDate = DateTime.parse(devotional['date']!);

    final FocusNode dateFocusNode = FocusNode();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit Devotional: ${devotional["title"]}',
            style: const TextStyle(color: Color(0xFFB4BA1C)),
          ),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Date Picker as TextField
                  Focus(
                    onFocusChange: (hasFocus) {
                      if (!hasFocus) {
                        // You can change the border color after focus loss if needed
                      }
                    },
                    child: TextFormField(
                      focusNode: dateFocusNode,
                      readOnly: true, // Prevent keyboard from showing
                      decoration: InputDecoration(
                        labelText: 'Date',
                        hintText: "${selectedDate.toLocal()}".split(' ')[0],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: dateFocusNode.hasFocus
                                ? Color(0xFFB4BA1C)
                                : Colors.black26,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                      ),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null && picked != selectedDate) {
                          selectedDate = picked;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildBoxTextField(
                    controller: titleController,
                    label: 'Title',
                  ),
                  const SizedBox(height: 12),
                  _buildBoxTextField(
                    controller: bibleVerseController,
                    label: 'Bible Verse',
                  ),
                  const SizedBox(height: 12),
                  _buildBoxTextField(
                    controller: bodyController,
                    label: 'Body',
                    maxLines: 5,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Updated ${titleController.text}')),
                );
                Navigator.of(context).pop();
              },
              child: const Text(
                'Update',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB4BA1C),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper method to create box-styled text fields
  Widget _buildBoxTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
      ),
    );
  }
}
