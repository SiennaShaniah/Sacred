import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      // Get the current logged-in user's ID
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        print('Fetching favorite songs for user: $userId'); // Debugging user ID

        final querySnapshot = await _firestore
            .collection('songs')
            .where('isFavorite', isEqualTo: true)
            .where('userId', isEqualTo: userId) // Filter by user ID
            .get();

        if (querySnapshot.docs.isEmpty) {
          print('No favorite songs found for user'); // Debugging: No data found
        } else {
          print(
              'Found ${querySnapshot.docs.length} favorite songs'); // Debugging query results
        }

        setState(() {
          favoriteSongs = querySnapshot.docs.map((doc) {
            return {
              'title': doc['title'],
              'artist': doc['artist'],
              'image': doc['imagePath'],
              'isFavorite': doc['isFavorite'] ?? false,
              'id': doc.id,
              'type': doc['type'],
              'language': doc['language'],
            };
          }).toList();

          filteredSongs = List.from(favoriteSongs);

          // Get unique artists for filtering
          artists = favoriteSongs
              .map((song) => song['artist'] as String)
              .toSet()
              .toList();
        });
      } else {
        print('User is not logged in'); // Debugging: No user logged in
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

  Future<void> toggleFavorite(String songId, bool currentFavoriteStatus) async {
    try {
      await _firestore.collection('songs').doc(songId).update({
        'isFavorite': !currentFavoriteStatus,
      });
      fetchFavoriteSongs();
    } catch (e) {
      print('Error updating favorite status: $e');
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
