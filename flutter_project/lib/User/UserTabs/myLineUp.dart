import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'lyricsChords.dart'; // Import intl package

class MyLineUp extends StatelessWidget {
  const MyLineUp({super.key});

  // Add a lineup to Firestore
  Future<void> _addLineUp(String lineupTitle, BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final timestamp = FieldValue.serverTimestamp();

      try {
        // Add the new lineup to Firestore with an empty songs array
        await FirebaseFirestore.instance.collection('myLineUp').add({
          'userId': userId,
          'lineUpName': lineupTitle,
          'timestamp': timestamp,
          'songs': [], // Initialize the songs array
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lineup "$lineupTitle" added successfully!')),
        );
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add lineup')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to add a lineup')),
      );
    }
  }

  // Delete a lineup from Firestore
  Future<void> _deleteLineUp(String lineupId, BuildContext context) async {
    try {
      // Delete the selected lineup from Firestore
      await FirebaseFirestore.instance
          .collection('myLineUp')
          .doc(lineupId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Line Up deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete lineup')),
      );
    }
  }

  // Show the dialog to add a new lineup
  void _showAddLineUpDialog(BuildContext context) {
    final TextEditingController lineupController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: const Text('Add Line Up Title',
              style: TextStyle(color: Colors.black)),
          content: TextField(
            controller: lineupController,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Enter Line Up Title',
              hintStyle: const TextStyle(color: Colors.black),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB4BA1C)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB4BA1C), width: 2.0),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB4BA1C)),
              onPressed: () {
                final lineupTitle = lineupController.text;
                if (lineupTitle.isNotEmpty) {
                  _addLineUp(lineupTitle, context); // Add the new lineup
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Title cannot be empty!')),
                  );
                }
              },
              child: const Text('Add', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text('Please log in to view and add your lineups.'),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, top: 15.0),
              child: Text(
                'My Line Up',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('myLineUp')
                  .where('userId',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No lineups available.'));
                }

                final lineups = snapshot.data!.docs;
                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: lineups.length,
                  itemBuilder: (context, index) {
                    final lineup = lineups[index];
                    final lineupTitle = lineup['lineUpName'];
                    final lineupId = lineup.id;

                    // Format the timestamp to only show the date
                    final timestamp = lineup['timestamp'].toDate();
                    final formattedDate =
                        DateFormat('MM/dd/yyyy').format(timestamp);

                    return GestureDetector(
                      onTap: () {
                        // Navigate to the new page showing the lineup's songs
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LineUpDetailsPage(lineupId: lineupId),
                          ),
                        );
                      },
                      child: Card(
                        color: const Color(0xFFB4BA1C).withOpacity(0.5),
                        elevation: 3.0,
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.asset(
                                      'lib/Images/bible.jpg',
                                      width: double.infinity,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: PopupMenuButton<String>(
                                      icon: const Icon(Icons.more_vert,
                                          color: Colors.black, size: 30),
                                      onSelected: (value) {
                                        if (value == 'delete') {
                                          _deleteLineUp(lineupId, context);
                                        }
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return [
                                          const PopupMenuItem<String>(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete,
                                                    color: Color(0xFFB4BA1C)),
                                                SizedBox(width: 8),
                                                Text('Delete'),
                                              ],
                                            ),
                                          ),
                                        ];
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lineupTitle,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddLineUpDialog(context),
        backgroundColor: const Color(0xFFB4BA1C),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

class LineUpDetailsPage extends StatefulWidget {
  final String lineupId;

  const LineUpDetailsPage({super.key, required this.lineupId});

  @override
  _LineUpDetailsPageState createState() => _LineUpDetailsPageState();
}

class _LineUpDetailsPageState extends State<LineUpDetailsPage> {
  late List<dynamic> songs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lineup Songs'),
        backgroundColor: const Color(0xFFB4BA1C),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('myLineUp')
            .doc(widget.lineupId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No songs available.'));
          }

          final lineupData = snapshot.data!;
          songs = List<dynamic>.from(lineupData['songs'] ?? []);

          if (songs.isEmpty) {
            return const Center(child: Text('No songs in this lineup.'));
          }

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                Expanded(
                  child: ReorderableListView(
                    onReorder: _onReorder,
                    children: List.generate(songs.length, (index) {
                      final song = songs[index];
                      return Card(
                        key: ValueKey(song['songTitle']),
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
                                'lib/Images/bible.jpg', // Placeholder image
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            song['songTitle'] ?? 'Untitled',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          subtitle: Text(
                            song['songArtist'] ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Color(0xFFB4BA1C),
                            ),
                          ),
                          onTap: () {
                            // Navigate to the song details or lyrics page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainChordsAndLyrics(
                                  title: song['songTitle'] ?? 'Untitled',
                                  artist: song['songArtist'] ?? 'Unknown',
                                  originalkey: song['songOriginalKey'] ??
                                      'C', // Default key if null
                                  link: song['songLink'] ?? '',
                                  chordsAndLyrics:
                                      song['songChordsAndLyrics'] ?? '',
                                ),
                              ),
                            );
                          },
                          trailing: PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Color(0xFFB4BA1C),
                            ),
                            onSelected: (value) {
                              if (value == 'remove') {
                                _removeSongFromLineup(song['songTitle']);
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem<String>(
                                  value: 'remove',
                                  child: const Text('Remove Song'),
                                ),
                              ];
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Handle reordering of the songs
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final song = songs.removeAt(oldIndex);
      songs.insert(newIndex, song);

      // Optionally, update the order in Firestore
      FirebaseFirestore.instance
          .collection('myLineUp')
          .doc(widget.lineupId)
          .update({'songs': songs});
    });
  }

  // Remove song from the selected lineup
  Future<void> _removeSongFromLineup(String songTitle) async {
    try {
      // Find the song to be removed (we are assuming the song object has more fields than just title)
      final songToRemove = songs.firstWhere(
        (song) => song['songTitle'] == songTitle,
        orElse: () => null,
      );

      if (songToRemove != null) {
        // Remove the exact song object from the Firestore lineup
        await FirebaseFirestore.instance
            .collection('myLineUp')
            .doc(widget.lineupId)
            .update({
          'songs': FieldValue.arrayRemove([songToRemove]),
        });

        // Update the local songs list after removal
        setState(() {
          songs.remove(songToRemove);
        });
      }
    } catch (e) {
      print('Error removing song: $e');
    }
  }
}
