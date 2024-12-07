import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainList extends StatefulWidget {
  const MainList({super.key});

  @override
  State<MainList> createState() => _MainListState();
}

class _MainListState extends State<MainList> {
  List<Map<String, dynamic>> songs = [];
  List<String> artistList = []; // List to store artists
  String? selectedArtist;
  String? selectedType;
  String? selectedLanguage;

  // Initialize the list of songs
  @override
  void initState() {
    super.initState();
    fetchSongs();
    fetchArtists(); // Fetch artists for filtering
  }

  // Fetch songs data from Firestore
  Future<void> fetchSongs() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('songs').get();

      setState(() {
        songs = querySnapshot.docs.map((doc) {
          return {
            'title': doc['title'],
            'artist': doc['artist'],
            'image': doc['imagePath'],
            'isFavorite': doc['isFavorite'] ?? false,
            'id': doc.id,
            'type':
                doc['type'], // Assume songs have 'type' and 'language' fields
            'language': doc['language'],
          };
        }).toList();
      });
    } catch (e) {
      print("Error fetching songs: $e");
    }
  }

  // Fetch artists from Firestore
  Future<void> fetchArtists() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('artists').get();

      setState(() {
        artistList = querySnapshot.docs.map((doc) {
          return doc['name'] as String; // Explicitly cast the field to a String
        }).toList();
        artistList.insert(
            0, 'All Artists'); // Add 'All Artists' as the first option
      });
    } catch (e) {
      print("Error fetching artists: $e");
    }
  }

  // Toggle favorite state and update Firestore
  Future<void> toggleFavorite(String songId, bool currentFavoriteStatus) async {
    try {
      await FirebaseFirestore.instance.collection('songs').doc(songId).update({
        'isFavorite': !currentFavoriteStatus,
      });

      fetchSongs(); // Refresh after update
    } catch (e) {
      print("Error updating favorite: $e");
    }
  }

  // Show filter dialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Songs'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Filter by Artist
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
              // Filter by Type
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
              // Filter by Language
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
                Navigator.of(context).pop(); // Close the dialog
                fetchSongs(); // Re-fetch songs after applying filter
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
                Navigator.of(context)
                    .pop(); // Close dialog without applying filter
                fetchSongs(); // Re-fetch all songs
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
                  'Song List',
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

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: (query) {
                fetchSongs(); // Fetch songs again when search query changes
              },
              decoration: InputDecoration(
                hintText: 'Search songs...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFFB4BA1C)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Color(0xFFB4BA1C)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:
                      const BorderSide(color: Color(0xFFB4BA1C), width: 2.0),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8.0),

          // Song List (No filters)
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
                      child: Container(
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
