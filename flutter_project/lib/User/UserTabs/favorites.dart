import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'myfavoritesChordsAndLyrics.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> favoriteSongs = [];
  List<Map<String, dynamic>> filteredSongs = [];
  String selectedLanguage = 'All Languages';
  String selectedType = 'All Types';
  String? selectedArtist;
  String searchQuery = "";
  List<String> artists = [];

  @override
  void initState() {
    super.initState();
    fetchFavoriteSongs();
  }

  Future<void> fetchFavoriteSongs() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        print('Fetching favorite songs for user: $userId');

        final favoritesSnapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('favorites')
            .get();

        if (favoritesSnapshot.docs.isEmpty) {
          print('No favorite songs found for user');
        } else {
          print('Found ${favoritesSnapshot.docs.length} favorite songs');
        }

        final favoriteSongIds = favoritesSnapshot.docs
            .map((doc) => doc['songId'] as String?)
            .whereType<String>() // Ensure it's not null
            .toList();

        final songsSnapshot = await _firestore
            .collection('songs')
            .where(FieldPath.documentId, whereIn: favoriteSongIds)
            .get();

        setState(() {
          favoriteSongs = songsSnapshot.docs.map((doc) {
            return {
              'title': doc['title'] ?? 'Untitled',
              'artist': doc['artist'] ?? 'Unknown Artist',
              'image': doc['imagePath'] ?? '',
              'isFavorite': true,
              'id': doc.id,
              'type': doc['type'] ?? 'Unknown',
              'language': doc['language'] ?? 'Unknown',
              'originalkey': doc['originalkey'] ?? 'Unknown',
              'link': doc['link'] ?? '',
              'chordsAndLyrics': doc['chordsAndLyrics'] ?? '',
            };
          }).toList();

          filteredSongs = List.from(favoriteSongs);

          artists = favoriteSongs
              .map((song) => song['artist'] as String?)
              .whereType<String>()
              .toSet()
              .toList();
        });
      } else {
        print('User is not logged in');
      }
    } catch (e) {
      print('Error fetching favorite songs: $e');
    }
  }

  void _filterByLanguage(String language) {
    setState(() {
      selectedLanguage = language;
      _applyFilters();
    });
  }

  void _filterByType(String type) {
    setState(() {
      selectedType = type;
      _applyFilters();
    });
  }

  void _filterByArtist(String? artist) {
    setState(() {
      selectedArtist = artist;
      _applyFilters();
    });
  }

  void _applyFilters() {
    filteredSongs = favoriteSongs.where((song) {
      final matchesLanguage = selectedLanguage == 'All Languages' ||
          song['language'] == selectedLanguage;
      final matchesType =
          selectedType == 'All Types' || song['type'] == selectedType;
      final matchesArtist =
          selectedArtist == null || song['artist'] == selectedArtist;
      final matchesSearchQuery = searchQuery.isEmpty ||
          song['title'].toLowerCase().contains(searchQuery) ||
          song['artist'].toLowerCase().contains(searchQuery);

      return matchesLanguage &&
          matchesType &&
          matchesArtist &&
          matchesSearchQuery;
    }).toList();
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
                const Divider(color: Color(0xFFB4BA1C)),
                ListTile(
                  title: const Text('Type'),
                  onTap: () {
                    Navigator.pop(context);
                    _showTypeFilterDialog();
                  },
                ),
                const Divider(color: Color(0xFFB4BA1C)),
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
                  'Favorites',
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
                  searchQuery = query.toLowerCase();
                  _applyFilters();
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
                      song['title'] ?? 'Untitled',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      song['artist'] ?? 'Unknown Artist',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB4BA1C),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyfavoritesChordsAndLyrics(
                            title: song['title'],
                            artist: song['artist'],
                            originalkey: song['originalkey'],
                            link: song['link'],
                            chordsAndLyrics: song['chordsAndLyrics'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
