import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'lyricsChords.dart';

class MainList extends StatefulWidget {
  const MainList({super.key});

  @override
  State<MainList> createState() => _MainListState();
}

class _MainListState extends State<MainList> {
  List<Map<String, dynamic>> songs = [];
  List<Map<String, dynamic>> filteredSongs = [];
  String selectedLanguage = 'All Languages';
  String selectedType = 'All Types';
  String? selectedArtist;
  List<String> artists = []; // List to store artists

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  Future<void> fetchSongs() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print("User not authenticated");
      return;
    }

    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('songs').get();

      final fetchedSongs = querySnapshot.docs.map((doc) async {
        var artistName = 'Unknown';
        if (doc['artist'] != null) {
          artistName = doc['artist'];
        }

        // Check if the song is in the user's favorites
        final favoritesSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('favorites')
            .doc(doc.id)
            .get();

        bool isFavorite = favoritesSnapshot.exists;

        return {
          'title': doc['title'],
          'artist': artistName,
          'image': doc['imagePath'],
          'isFavorite': isFavorite,
          'id': doc.id,
          'type': doc['type'],
          'language': doc['language'],
          'originalkey': doc['originalkey'],
          'link': doc['link'],
          'chordsAndLyrics': doc['chordsAndLyrics'],
        };
      }).toList();

      final resolvedSongs = await Future.wait(fetchedSongs);

      setState(() {
        songs = resolvedSongs;
        filteredSongs = List.from(songs);
        artists =
            songs.map((song) => song['artist'] as String).toSet().toList();
      });
    } catch (e) {
      print("Error fetching songs: $e");
    }
  }

  void _filterByLanguage(String language) {
    setState(() {
      selectedLanguage = language;
      filteredSongs = songs.where((song) {
        return language == 'All Languages' || song['language'] == language;
      }).toList();
    });
  }

  void _filterByType(String type) {
    setState(() {
      selectedType = type;
      filteredSongs = songs.where((song) {
        return type == 'All Types' || song['type'] == type;
      }).toList();
    });
  }

  void _filterByArtist(String? artist) {
    setState(() {
      selectedArtist = artist;
      filteredSongs = songs.where((song) {
        return artist == null || song['artist'] == artist;
      }).toList();
    });
  }

  void _showFilterOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter By'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  title: const Text('Language'),
                  onTap: () {
                    Navigator.pop(context);
                    _showLanguageFilterDialog();
                  },
                ),
                Divider(color: Color(0xFFB4BA1C)),
                ListTile(
                  title: const Text('Type'),
                  onTap: () {
                    Navigator.pop(context);
                    _showTypeFilterDialog();
                  },
                ),
                Divider(color: Color(0xFFB4BA1C)),
                ListTile(
                  title: const Text('Artist'),
                  onTap: () {
                    Navigator.pop(context);
                    _showArtistFilterDialog();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLanguageFilterDialog() {
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

  void _showTypeFilterDialog() {
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

  void _showArtistFilterDialog() {
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
              ...artists.map((artist) {
                return ListTile(
                  title: Text(artist),
                  onTap: () {
                    Navigator.pop(context);
                    _filterByArtist(artist);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Future<void> toggleFavorite(String songId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print("User not authenticated");
      return;
    }

    final favoritesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites');
    final songIndex = filteredSongs.indexWhere((song) => song['id'] == songId);

    if (songIndex == -1) return;

    final isCurrentlyFavorite = filteredSongs[songIndex]['isFavorite'];

    try {
      if (isCurrentlyFavorite) {
        // If the song is already in favorites, remove it
        await favoritesRef.doc(songId).delete();
        setState(() {
          filteredSongs[songIndex]['isFavorite'] = false;
        });
      } else {
        // If the song is not in favorites, add it
        await favoritesRef.doc(songId).set({
          'songId': songId,
          'timestamp': FieldValue.serverTimestamp(),
        });
        setState(() {
          filteredSongs[songIndex]['isFavorite'] = true;
        });
      }
    } catch (e) {
      print("Error updating favorite: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    Icons.filter_alt_outlined,
                    color: Color(0xFFB4BA1C),
                  ),
                  onPressed: _showFilterOptions,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  final searchQuery = query.toLowerCase();
                  filteredSongs = songs.where((song) {
                    final title = song['title']?.toLowerCase() ?? '';
                    final artist = song['artist']?.toLowerCase() ?? '';
                    return title.contains(searchQuery) ||
                        artist.contains(searchQuery);
                  }).toList();
                });
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
                          toggleFavorite(song['id']);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainChordsAndLyrics(
                              title: song['title'],
                              artist: song['artist'],
                              originalkey: song['originalkey'],
                              link: song['link'],
                              chordsAndLyrics: song['chordsAndLyrics'],
                            ),
                          ),
                        );
                      }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
