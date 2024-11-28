import 'package:flutter/material.dart';

class SongListTab extends StatelessWidget {
  const SongListTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for the song list
    final List<Map<String, String>> songs = [
      {
        "title": "Amazing Grace",
        "artist": "John Newton",
        "image": 'lib/Images/welcome.png', // Local image path
      },
      {
        "title": "Amazing Grace",
        "artist": "John Newton",
        "image": 'lib/Images/welcome.png', // Local image path
      },
      {
        "title": "Amazing Grace",
        "artist": "John Newton",
        "image": 'lib/Images/welcome.png', // Local image path
      },
    ];

    return Column(
      children: [
        // Title Text aligned to start
        const Align(
          alignment: Alignment.centerLeft, // Align text to the left
          child: Padding(
            padding: EdgeInsets.only(
                left: 16.0, top: 32.0), // Add left and top padding
            child: Text(
              'Song List',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black, // You can change the color if needed
              ),
            ),
          ),
        ),

        // List of Songs
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0), // Reduced padding between items
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];

              return Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                elevation: 3.0,
                margin: const EdgeInsets.symmetric(
                    vertical: 4.0), // Reduced vertical margin
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5), // 10px radius
                    child: Image.asset(
                      song["image"]!, // Use Image.asset for local images
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Editing ${song["title"]}')),
                        );
                      } else if (value == 'archive') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Archiving ${song["title"]}')),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Color(0xFFB4BA1C)),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'archive',
                          child: Row(
                            children: [
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
}
