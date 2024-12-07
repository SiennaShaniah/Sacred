import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SongListTab extends StatefulWidget {
  const SongListTab({super.key});

  @override
  State<SongListTab> createState() => _SongListTabState();
}

class _SongListTabState extends State<SongListTab> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> songs = [];
  List<Map<String, dynamic>> filteredSongs = [];
  String selectedLanguage = 'All Languages';
  String selectedType = 'All Types';
  String? selectedArtist;

  @override
  void initState() {
    super.initState();
    _loadSongs(); // Load songs from Firestore
  }

  Future<void> _loadSongs() async {
    try {
      final snapshot = await _firestore.collection('songs').get();
      setState(() {
        songs = snapshot.docs.map((doc) {
          return {
            "id": doc.id,
            "title": doc['title'] ?? 'No Title',
            "artist": doc['artist'] ?? 'Unknown Artist',
            "image": doc['imagePath'] ?? '',
            "language": doc['language'] ?? 'Unknown Language',
            "type": doc['type'] ?? 'Unknown Type',
            "original_key": doc.data().containsKey('original_key')
                ? doc['original_key']
                : 'N/A',
            "chords": doc['chords'] ?? 'N/A',
            "lyrics": doc['lyrics'] ?? '',
            "song_link": doc['song_link'] ?? '',
          };
        }).toList();
        filteredSongs = List.from(songs); // Initially display all songs
      });
    } catch (e) {
      print("Error loading songs: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading songs: $e")),
      );
    }
  }

  void _filterByLanguage(String language) {
    setState(() {
      selectedLanguage = language;
      if (language == 'All Languages') {
        filteredSongs = List.from(songs);
      } else {
        filteredSongs =
            songs.where((song) => song['language'] == language).toList();
      }
    });
  }

  void _filterByType(String type) {
    setState(() {
      selectedType = type;
      if (type == 'All Types') {
        filteredSongs = List.from(songs);
      } else {
        filteredSongs = songs.where((song) => song['type'] == type).toList();
      }
    });
  }

  void _filterByArtist(String? artist) {
    setState(() {
      selectedArtist = artist;
      if (artist == null) {
        filteredSongs = List.from(songs);
      } else {
        filteredSongs =
            songs.where((song) => song['artist'] == artist).toList();
      }
    });
  }

  Future<void> _deleteSong(String songId) async {
    await _firestore.collection('songs').doc(songId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Song deleted successfully')),
    );
    _loadSongs(); // Reload songs
  }

  Future<void> _updateSong(
      String songId, Map<String, dynamic> updatedData) async {
    await _firestore.collection('songs').doc(songId).update(updatedData);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Song updated successfully')),
    );
    _loadSongs(); // Reload songs
  }

  Future<void> _showSortOptions() async {
    // Get all songs from Firestore
    final snapshot = await _firestore.collection('songs').get();

    // Extract artist names and remove duplicates using a Set
    Set<String> artistsSet = {};
    for (var doc in snapshot.docs) {
      artistsSet.add(doc['artist'].toString());
    }

    // Convert the set to a list
    List<String> artists = artistsSet.toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sort Options"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // All Songs Option
                ListTile(
                  title: Text('All Songs'),
                  onTap: () {
                    setState(() {
                      filteredSongs = List.from(songs); // Reset to all songs
                    });
                    Navigator.of(context).pop();
                  },
                ),
                Divider(),

                // Artist Dropdown Option
                ListTile(
                  title: Text('Artist'),
                  subtitle: Text(selectedArtist ?? 'Select Artist'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Select Artist"),
                          content: SingleChildScrollView(
                            child: Column(
                              children: artists.map((artist) {
                                return ListTile(
                                  title: Text(artist),
                                  onTap: () {
                                    _filterByArtist(artist);
                                    Navigator.of(context).pop();
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                Divider(),

                // Language Dropdown Option
                ListTile(
                  title: Text('Language'),
                  subtitle: Text(selectedLanguage),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Select Language"),
                          content: SingleChildScrollView(
                            child: Column(
                              children:
                                  ['English', 'Tagalog', 'Cebuano'].map((lang) {
                                return ListTile(
                                  title: Text(lang),
                                  onTap: () {
                                    _filterByLanguage(lang);
                                    Navigator.of(context).pop();
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                Divider(),

                // Type Dropdown Option
                ListTile(
                  title: Text('Type'),
                  subtitle: Text(selectedType),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Select Type"),
                          content: SingleChildScrollView(
                            child: Column(
                              children:
                                  ['Praise and Worship', 'Hymnal'].map((type) {
                                return ListTile(
                                  title: Text(type),
                                  onTap: () {
                                    _filterByType(type);
                                    Navigator.of(context).pop();
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title with Funnel Icon for Sorting
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
                icon: Icon(Icons.filter_alt_outlined, color: Color(0xFFB4BA1C)),
                onPressed: _showSortOptions, // Open sort options on click
              ),
            ],
          ),
        ),

        // Song List
        Expanded(
          child: ListView.builder(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            itemCount: filteredSongs.length,
            itemBuilder: (context, index) {
              final song = filteredSongs[index];

              return Card(
                color: Colors.white,
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      song["image"],
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    song["title"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    song["artist"],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFB4BA1C),
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (String value) {
                      if (value == 'edit') {
                        _showEditForm(context, song);
                      } else if (value == 'delete') {
                        _deleteSong(song["id"]);
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
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Color(0xFFB4BA1C)),
                              SizedBox(width: 8),
                              Text('Delete'),
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

  void _showEditForm(BuildContext context, Map<String, dynamic> song) {
    TextEditingController titleController =
        TextEditingController(text: song['title']);
    TextEditingController artistController =
        TextEditingController(text: song['artist']);
    TextEditingController languageController =
        TextEditingController(text: song['language']);
    TextEditingController typeController =
        TextEditingController(text: song['type']);
    TextEditingController imageUrlController =
        TextEditingController(text: song['image']);
    TextEditingController originalKeyController =
        TextEditingController(text: song['original_key']);
    TextEditingController chordsController =
        TextEditingController(text: song['chords']);
    TextEditingController lyricsController =
        TextEditingController(text: song['lyrics']);
    TextEditingController songLinkController =
        TextEditingController(text: song['song_link']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Song'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField('Title', titleController),
                _buildTextField('Artist', artistController),
                _buildTextField('Language', languageController),
                _buildTextField('Type', typeController),
                _buildTextField('Image URL', imageUrlController),
                _buildTextField('Original Key', originalKeyController),
                _buildTextField('Chords', chordsController),
                _buildTextField('Lyrics', lyricsController),
                _buildTextField('Song Link', songLinkController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Prepare the updated song data
                Map<String, dynamic> updatedSong = {
                  'title': titleController.text,
                  'artist': artistController.text,
                  'language': languageController.text,
                  'type': typeController.text,
                  'image': imageUrlController.text,
                  'original_key': originalKeyController.text,
                  'chords': chordsController.text,
                  'lyrics': lyricsController.text,
                  'song_link': songLinkController.text,
                };

                // Update the song in Firestore
                _updateSong(song['id'], updatedSong);
                Navigator.of(context).pop();
              },
              child: const Text('Save Changes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
