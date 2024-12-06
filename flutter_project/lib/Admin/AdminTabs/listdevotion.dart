import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DailyDevotionalListTab extends StatelessWidget {
  const DailyDevotionalListTab({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('devotionals')
                .orderBy('date', descending: true) // Sort by date
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No devotionals found.'));
              }

              final devotionals = snapshot.data!.docs;

              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.75, // Adjust this value if necessary
                ),
                itemCount: devotionals.length,
                itemBuilder: (context, index) {
                  final devotional = devotionals[index];

                  return Card(
                    color:
                        const Color(0xFFB4BA1C).withOpacity(0.5), // 50% opacity
                    elevation: 3.0,
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Column(
                      mainAxisSize: MainAxisSize
                          .max, // Allow card to take available height
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                'lib/Images/bible3.jpg', // Local image path
                                width: double.infinity,
                                height: 150, // Increased height for the image
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: PopupMenuButton<String>(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                  size: 30, // Bigger size for the menu button
                                ),
                                onSelected: (String value) {
                                  if (value == 'edit') {
                                    _showEditForm(context, devotional);
                                  } else if (value == 'delete') {
                                    _deleteDevotional(context, devotional.id);
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
                              // Title text now takes more space
                              Text(
                                devotional['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                overflow: TextOverflow
                                    .ellipsis, // Truncate if text overflows
                                softWrap:
                                    true, // Allow text to wrap to the next line
                              ),
                              const SizedBox(
                                  height: 8), // Space between title and date
                              // Formatted Date
                              Text(
                                _formatDate(devotional['date']),
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Function to format date string (remove T00:00:00)
  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return "${parsedDate.toLocal()}"
        .split(' ')[0]; // Returns only the date part
  }

  // Function to show the edit form popup
  void _showEditForm(BuildContext context, QueryDocumentSnapshot devotional) {
    final TextEditingController titleController =
        TextEditingController(text: devotional['title']);
    final TextEditingController bibleVerseController =
        TextEditingController(text: devotional['bible_verse']);
    final TextEditingController bodyController =
        TextEditingController(text: devotional['body']);
    DateTime selectedDate = DateTime.parse(devotional['date']);

    final FocusNode dateFocusNode = FocusNode();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Aligning to the left
            children: [
              const Text(
                'Edit Devotional: ',
                style: TextStyle(
                    color: Color(0xFFB4BA1C), fontWeight: FontWeight.bold),
              ),
              Text(
                devotional['title'], // Display the dynamic title here
                style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
              ),
            ],
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
                                ? const Color(0xFFB4BA1C)
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
                // Update Firestore
                FirebaseFirestore.instance
                    .collection('devotionals')
                    .doc(devotional.id)
                    .update({
                  'title': titleController.text,
                  'bible_verse': bibleVerseController.text,
                  'body': bodyController.text,
                  'date': selectedDate.toIso8601String(),
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Updated ${titleController.text}')),
                );
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB4BA1C),
              ),
              child: const Text(
                'Update',
                style: TextStyle(color: Colors.black),
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

  // Function to delete the devotional from Firestore
  void _deleteDevotional(BuildContext context, String docId) {
    FirebaseFirestore.instance.collection('devotionals').doc(docId).delete();

    // Show snackbar using the correct context
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Devotional deleted successfully!')),
    );
  }
}
