import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'editSong.dart';

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
  List<String> artists = []; // List to store artists

  @override
  void initState() {
    super.initState();
    _loadSongs();
    _loadArtists(); // Load artists from Firestore
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
            "chordsAndLyrics": doc.data().containsKey('chordsAndLyrics')
                ? doc['chordsAndLyrics']
                : '',
            "song_link":
                doc.data().containsKey('song_link') ? doc['song_link'] : '',
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

  Future<void> _loadArtists() async {
    try {
      final snapshot = await _firestore.collection('artists').get();
      setState(() {
        artists = snapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (e) {
      print("Error loading artists: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading artists: $e")),
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

  Future<void> _archiveSong(String songId) async {
    await _firestore.collection('songs').doc(songId).update({
      'archived': true, // Mark the song as archived
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Song archived successfully')),
    );
    _loadSongs(); // Reload songs
  }

  void _navigateToEditSongScreen(Map<String, dynamic> songData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSong(songData: songData), // Passing songData
      ),
    );
  }

  void _showSortOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sort By'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  title: const Text('Language'),
                  onTap: () {
                    Navigator.pop(context);
                    _showLanguageSortDialog(); // Show language filter options
                  },
                ),
                Divider(), // Divider added
                ListTile(
                  title: const Text('Type'),
                  onTap: () {
                    Navigator.pop(context);
                    _showTypeSortDialog(); // Show type filter options
                  },
                ),
                Divider(), // Divider added
                ListTile(
                  title: const Text('Artist'),
                  onTap: () {
                    Navigator.pop(context);
                    _showArtistSortDialog(); // Show artist filter options
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLanguageSortDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('All Languages'),
                onTap: () {
                  Navigator.pop(context);
                  _filterByLanguage('All Languages');
                },
              ),
              ListTile(
                title: const Text('English'),
                onTap: () {
                  Navigator.pop(context);
                  _filterByLanguage('English');
                },
              ),
              ListTile(
                title: const Text('Tagalog'),
                onTap: () {
                  Navigator.pop(context);
                  _filterByLanguage('Tagalog');
                },
              ),
              ListTile(
                title: const Text('Cebuano'),
                onTap: () {
                  Navigator.pop(context);
                  _filterByLanguage('Cebuano');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTypeSortDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('All Types'),
                onTap: () {
                  Navigator.pop(context);
                  _filterByType('All Types');
                },
              ),
              ListTile(
                title: const Text('Praise And Worship'),
                onTap: () {
                  Navigator.pop(context);
                  _filterByType('Praise And Worship');
                },
              ),
              ListTile(
                title: const Text('Hymnal'),
                onTap: () {
                  Navigator.pop(context);
                  _filterByType('Hymnal');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showArtistSortDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Artist'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('All Artists'),
                onTap: () {
                  Navigator.pop(context);
                  _filterByArtist(null);
                },
              ),
              // Dynamically generate artist filter options
              ...artists.map((artist) {
                return ListTile(
                  title: Text(artist),
                  onTap: () {
                    Navigator.pop(context);
                    _filterByArtist(artist);
                  },
                );
              }).toList(),
            ],
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
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 8.0), // Reduced vertical padding
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
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 8.0), // Reduced vertical padding
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
                        _navigateToEditSongScreen(song);
                      } else if (value == 'archive') {
                        _archiveSong(song["id"]);
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
