import 'package:flutter/material.dart';
import 'package:flutter_project/User/UserTabs/addMySong.dart'; // Replace with your actual import path for AddMySongTab

class Mysongs extends StatelessWidget {
  const Mysongs({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for songs
    final List<Map<String, dynamic>> songs = [
      {
        'id': '1',
        'title': 'Amazing Grace',
        'artist': 'John Newton',
        'image': 'https://example.com/image1.jpg',
        'isFavorite': true,
      },
      {
        'id': '2',
        'title': 'How Great Thou Art',
        'artist': 'Carl Boberg',
        'image': 'https://example.com/image2.jpg',
        'isFavorite': false,
      },
    ];

    // Callbacks to handle actions
    void onFilterPressed() {
      // Handle filter logic
      print('Filter button pressed');
    }

    void onSearchChanged(String query) {
      // Handle search query change
      print('Search query: $query');
    }

    void onToggleFavorite(String id, bool isFavorite) {
      // Handle toggle favorite logic
      print('Toggled favorite for song $id, new state: $isFavorite');
    }

    // Action when floating button is pressed
    void onAddSong() {
      // Navigate to AddMySongTab when the floating action button is pressed
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddMySongTab()), // AddMySongTab should be the screen you want to navigate to
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Songs',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Color(0xFFB4BA1C)),
            onPressed: onFilterPressed,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search songs...',
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFFB4BA1C)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Color(0xFFB4BA1C)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Color(0xFFB4BA1C), width: 2.0),
                  ),
                ),
              ),
            ),

            // Song List
            Expanded(
              child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];

                  return Card(
                    color: Colors.white,
                    elevation: 6.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 12.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: Image.network(
                            song['image'] ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        song['title']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      subtitle: Text(
                        song['artist']!,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Color(0xFFB4BA1C),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          song['isFavorite']
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: song['isFavorite']
                              ? const Color(0xFFB4BA1C)
                              : Colors.grey,
                        ),
                        onPressed: () => onToggleFavorite(
                          song['id'],
                          song['isFavorite'],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddSong,
        backgroundColor: const Color(0xFFB4BA1C),
        child: const Icon(Icons.add),
      ),
    );
  }
}
