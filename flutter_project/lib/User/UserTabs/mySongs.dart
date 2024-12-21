import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_project/User/UserTabs/addMySong.dart'; // Import MainChordsAndLyrics page
import 'package:flutter_project/User/UserTabs/mysonglyricsandchords.dart';
import 'userEditMySong.dart'; // Import the UserMySongEdit page

class Mysongs extends StatefulWidget {
  const Mysongs({super.key});

  @override
  _MysongsState createState() => _MysongsState();
}

class _MysongsState extends State<Mysongs> {
  List<Map<String, dynamic>> songs = [];
  List<Map<String, dynamic>> filteredSongs = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  Future<void> fetchSongs() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('userAddSong').get();

      setState(() {
        songs = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'title': doc['songTitle'] ?? 'Untitled', // Default value if null
            'artist': doc['songArtist'] ?? 'Unknown', // Default value if null
            'image': 'lib/Images/bible.jpg', // Default local image
            'songTitle':
                doc['songTitle'] ?? 'Untitled', // Default value if null
            'songArtist':
                doc['songArtist'] ?? 'Unknown', // Default value if null
            'songOriginalKey':
                doc['songOriginalKey'] ?? 'C', // Default value if null
            'songLink': doc['songLink'] ?? '', // Default value if null
            'songChordsAndLyrics':
                doc['songChordsAndLyrics'] ?? '', // Default value if null
          };
        }).toList();
        filteredSongs = songs;
      });
    } catch (e) {
      print('Error fetching songs: $e');
    }
  }

  void onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      if (_searchQuery.isEmpty) {
        filteredSongs = songs;
      } else {
        filteredSongs = songs.where((song) {
          return song['title']!
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              song['artist']!
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());
        }).toList();
      }
    });
  }

  void onAddSong() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMySongTab(),
      ),
    );
  }

  void onEditSong(String songId) {
    FirebaseFirestore.instance
        .collection('userAddSong')
        .doc(songId)
        .get()
        .then((doc) {
      if (doc.exists) {
        // Get the data from the document
        final songData = doc.data();

        if (songData != null) {
          // Pass the song data and the document ID to the edit screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserMySongEdit(
                songData: {
                  'id': doc.id, // Pass the Firestore document ID here
                  ...songData, // Merge the song data
                },
              ),
            ),
          );
        } else {
          print("Song data is null.");
        }
      } else {
        print("Song not found.");
      }
    }).catchError((e) {
      print("Error fetching song: $e");
    });
  }

  void onDeleteSong(String songId) {
    FirebaseFirestore.instance.collection('userAddSong').doc(songId).delete();
    setState(() {
      songs.removeWhere((song) => song['id'] == songId);
      filteredSongs = songs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Songs',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: Colors.black),
            ),
            SizedBox(height: 16.0),
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
            Expanded(
              child: ListView.builder(
                itemCount: filteredSongs.length,
                itemBuilder: (context, index) {
                  final song = filteredSongs[index];

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
                          width: 120,
                          height: 150,
                          child: Image.asset(
                            song['image'],
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
                      // Add onTap to navigate to MainChordsAndLyrics page
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Mysonglyricsandchords(
                              songTitle: song['songTitle'],
                              songArtist: song['songArtist'],
                              songOriginalKey: song['songOriginalKey'],
                              songLink: song['songLink'],
                              songChordsAndLyrics: song['songChordsAndLyrics'],
                            ),
                          ),
                        );
                      },
                      trailing: PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: Color(0xFFB4BA1C),
                        ),
                        onSelected: (value) {
                          if (value == 'edit') {
                            onEditSong(song['id']);
                          } else if (value == 'delete') {
                            onDeleteSong(song['id']);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
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
