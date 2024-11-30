import 'package:flutter/material.dart';

class SongListTab extends StatelessWidget {
  SongListTab({super.key});

  final List<Map<String, String>> songs = [
    {
      "title": "Amazing Grace",
      "artist": "John Newton",
      "image": 'lib/Images/welcome.png',
    },
    {
      "title": "How Great Thou Art",
      "artist": "Carl Boberg",
      "image": 'lib/Images/welcome.png',
    },
    {
      "title": "Blessed Assurance",
      "artist": "Fanny J. Crosby",
      "image": 'lib/Images/welcome.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 32.0),
            child: const Text(
              'Song List',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];

              return Card(
                color: Colors.white,
                elevation: 3.0,
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset(
                      song["image"]!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    song["title"]!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    song["artist"]!,
                    style:
                        const TextStyle(fontSize: 14, color: Color(0xFFB4BA1C)),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (String value) {
                      if (value == 'edit') {
                        _showEditForm(context, song);
                      } else if (value == 'archive') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Archiving ${song["title"]}')),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: const [
                              Icon(Icons.edit, color: Color(0xFFB4BA1C)),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'archive',
                          child: Row(
                            children: const [
                              Icon(Icons.archive, color: Color(0xFFB4BA1C)),
                              SizedBox(width: 8),
                              Text('Archive'),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showEditForm(BuildContext context, Map<String, String> song) {
    final TextEditingController titleController =
        TextEditingController(text: song['title']);
    final TextEditingController artistController =
        TextEditingController(text: song['artist']);
    final TextEditingController imageController =
        TextEditingController(text: song['image']);
    final TextEditingController linkController = TextEditingController();

    String selectedKey = 'C';
    String selectedType = 'Worship';
    String selectedLanguage = 'English';

    // Declare the Chords and Lyrics controller here
    final TextEditingController chordsController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit Song: ${song["title"]}',
            style: const TextStyle(color: Color(0xFFB4BA1C)),
          ),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildBoxTextField(
                    controller: imageController,
                    label: 'Image Path',
                  ),
                  _buildBoxTextField(
                    controller: titleController,
                    label: 'Song Title',
                  ),
                  _buildBoxTextField(
                    controller: artistController,
                    label: 'Artist',
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedKey,
                    decoration: const InputDecoration(
                      labelText: 'Original Key',
                      border: OutlineInputBorder(),
                    ),
                    items: ['C', 'D', 'E', 'F', 'G', 'A', 'B']
                        .map((key) => DropdownMenuItem(
                              value: key,
                              child: Text(key),
                            ))
                        .toList(),
                    onChanged: (value) {
                      selectedKey = value!;
                    },
                  ),
                  const SizedBox(height: 12),
                  // Pass chordsController here
                  _buildBoxTextField(
                    controller: chordsController,
                    label: 'Chords and Lyrics',
                    maxLines: 5,
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Song Type',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Worship', 'Praise', 'Hymn']
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (value) {
                      selectedType = value!;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedLanguage,
                    decoration: const InputDecoration(
                      labelText: 'Song Language',
                      border: OutlineInputBorder(),
                    ),
                    items: ['English', 'Tagalog', 'Spanish']
                        .map((language) => DropdownMenuItem(
                              value: language,
                              child: Text(language),
                            ))
                        .toList(),
                    onChanged: (value) {
                      selectedLanguage = value!;
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildBoxTextField(
                    controller: linkController,
                    label: 'Link',
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
