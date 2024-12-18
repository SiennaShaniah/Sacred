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
            padding: EdgeInsets.only(left: 16.0, top: 15.0),
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
                .orderBy('date', descending: true)
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
                  childAspectRatio: 0.75,
                ),
                itemCount: devotionals.length,
                itemBuilder: (context, index) {
                  final devotional = devotionals[index];

                  return Card(
                    color: const Color(0xFFB4BA1C).withOpacity(0.5),
                    elevation: 3.0,
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                'lib/Images/bible3.jpg',
                                width: double.infinity,
                                height: 150,
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
                                  size: 30,
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
                              Text(
                                devotional['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                              const SizedBox(height: 8),
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

  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return "${parsedDate.toLocal()}".split(' ')[0];
  }

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Devotional: ',
                style: TextStyle(
                    color: Color(0xFFB4BA1C), fontWeight: FontWeight.bold),
              ),
              Text(
                devotional['title'],
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
                  Focus(
                    onFocusChange: (hasFocus) {},
                    child: TextFormField(
                      focusNode: dateFocusNode,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        hintText: "${selectedDate.toLocal()}".split(' ')[0],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xFFB4BA1C), width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black26, width: 1.5),
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
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFFB4BA1C),
                                  onPrimary: Colors.white,
                                  onSurface: Colors.black,
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Color(0xFFB4BA1C),
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != selectedDate) {
                          selectedDate = picked!;
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
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFB4BA1C), width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black26, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
      ),
    );
  }

  void _deleteDevotional(BuildContext context, String docId) {
    FirebaseFirestore.instance.collection('devotionals').doc(docId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Devotional deleted successfully!')),
    );
  }
}
