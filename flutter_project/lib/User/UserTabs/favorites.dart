import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<Map<String, dynamic>> songs = [
    {
      'title': 'Amazing Grace',
      'artist': 'John Newton',
      'image': 'https://example.com/image.jpg',
      'isFavorite': true,
      'id': '1',
      'type': 'Hymnal',
      'language': 'English',
    },
    {
      'title': 'How Great Thou Art',
      'artist': 'Carl Boberg',
      'image': 'https://example.com/image2.jpg',
      'isFavorite': false,
      'id': '2',
      'type': 'Praise and Worship',
      'language': 'English',
    },
    // Add more sample songs here
  ];

  List<String> artistList = ['John Newton', 'Carl Boberg', 'Matt Redman'];
  String? selectedArtist;
  String? selectedType;
  String? selectedLanguage;

  void toggleFavorite(String songId, bool currentFavoriteStatus) {
    setState(() {
      // Toggle the favorite status for the song
      final song = songs.firstWhere((song) => song['id'] == songId);
      song['isFavorite'] = !currentFavoriteStatus;
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Songs'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedArtist,
                hint: const Text('Select Artist'),
                onChanged: (value) {
                  setState(() {
                    selectedArtist = value;
                  });
                },
                items: artistList
                    .map((artist) => DropdownMenuItem<String>(
                          value: artist,
                          child: Text(artist),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedType,
                hint: const Text('Select Type'),
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                  });
                },
                items: <String>['Praise and Worship', 'Hymnals']
                    .map((type) => DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedLanguage,
                hint: const Text('Select Language'),
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value;
                  });
                },
                items: <String>['English', 'Tagalog', 'Cebuano']
                    .map((language) => DropdownMenuItem<String>(
                          value: language,
                          child: Text(language),
                        ))
                    .toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Apply filters (if any)
                setState(() {});
              },
              child: const Text('Apply Filter'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedArtist = null;
                  selectedType = null;
                  selectedLanguage = null;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Clear Filter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with filter icon
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Favorite Songs',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.filter_list,
                    color: Color(0xFFB4BA1C),
                  ),
                  onPressed: _showFilterDialog,
                ),
              ],
            ),
          ),

          // Song List
          Expanded(
            child: ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];

                // Apply filter logic here (example)
                if ((selectedArtist != null &&
                        selectedArtist != 'All Artists' &&
                        song['artist'] != selectedArtist) ||
                    (selectedType != null && song['type'] != selectedType) ||
                    (selectedLanguage != null &&
                        song['language'] != selectedLanguage)) {
                  return Container(); // Skip this song if it doesn't match the filter
                }

                return Card(
                  color: Colors.white,
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 100,
                        height: 100,
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
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      song['artist']!,
                      style: const TextStyle(
                        fontSize: 12,
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
                      onPressed: () {
                        toggleFavorite(song['id'], song['isFavorite']);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
