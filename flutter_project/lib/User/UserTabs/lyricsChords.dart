import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore
import 'dart:async';

class MainChordsAndLyrics extends StatefulWidget {
  final String title;
  final String artist;
  final String originalkey;
  final String link;
  final String chordsAndLyrics;

  const MainChordsAndLyrics({
    super.key,
    required this.title,
    required this.artist,
    required this.originalkey,
    required this.link,
    required this.chordsAndLyrics,
  });

  @override
  _MainChordsAndLyricsState createState() => _MainChordsAndLyricsState();
}

class _MainChordsAndLyricsState extends State<MainChordsAndLyrics> {
  bool isPlaying = false;
  late ScrollController _scrollController;
  double _fontSize = 16.0;
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    _scrollController =
        ScrollController(); // Initialize the ScrollController here
  }

  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to launch URL
  Future<void> _launchURL() async {
    final url = widget.link;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Function to handle play and pause behavior
  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });

    if (isPlaying) {
      _scrollTimer = Timer.periodic(Duration(seconds: 2), (timer) {
        _scrollToNextLine();
      });
    } else {
      _scrollTimer?.cancel();
    }
  }

  void _scrollToNextLine() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.offset + 20,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _zoomIn() {
    setState(() {
      if (_fontSize < 30.0) {
        _fontSize += 2.0;
      }
    });
  }

  void _zoomOut() {
    setState(() {
      if (_fontSize > 10.0) {
        _fontSize -= 2.0;
      }
    });
  }

  // Fetch lineups of the user
  Future<List<Map<String, dynamic>>> _getUserLineups() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return [];
    }

    String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      // Fetch lineups from Firestore
      QuerySnapshot snapshot = await _firestore
          .collection('myLineUp')
          .where('userId', isEqualTo: userId)
          .get();

      List<Map<String, dynamic>> lineups = [];
      snapshot.docs.forEach((doc) {
        lineups.add({
          'lineUpName': doc['lineUpName'],
          'lineUpId': doc.id,
        });
      });

      print("Fetched lineups: $lineups"); // Debugging line
      return lineups;
    } catch (e) {
      print("Error fetching lineups: $e"); // Error handling and debugging
      return [];
    }
  }

  // Add song to selected lineup
  void _addSongToLineup(String lineupId) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Define the song details to add to the lineup
      var song = {
        'songTitle': widget.title,
        'songArtist': widget.artist,
        'songLink': widget.link,
        'songChordsAndLyrics': widget.chordsAndLyrics,
        'songOriginalKey': widget.originalkey,
      };

      // Add the song to the selected lineup
      await _firestore.collection('myLineUp').doc(lineupId).update({
        'songs': FieldValue.arrayUnion([song]),
      });

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Song added to the lineup')),
      );
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add song to lineup: $e')),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB4BA1C),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0))),
            const SizedBox(height: 4),
            Text(widget.artist,
                style: const TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 73, 69, 69))),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                color: Color(0xFF363636)),
            onPressed: _togglePlayPause,
          ),
          IconButton(
              icon: const Icon(Icons.zoom_in, color: Color(0xFF363636)),
              onPressed: _zoomIn),
          IconButton(
              icon: const Icon(Icons.zoom_out, color: Color(0xFF363636)),
              onPressed: _zoomOut),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xFF363636)),
            onSelected: (value) async {
              if (value == 'Add to lineup') {
                // Fetch user lineups and display a dialog
                List<Map<String, dynamic>> lineups = await _getUserLineups();
                if (lineups.isEmpty) {
                  // Show a message if no lineups are found
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('No lineups found. Please create one first.')),
                  );
                } else {
                  // Show a dialog with the list of lineups
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Select Lineup'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: lineups.map((lineup) {
                            return ListTile(
                              title: Text(lineup['lineUpName']),
                              onTap: () {
                                // Add the song to the selected lineup
                                _addSongToLineup(lineup['lineUpId']);
                                Navigator.pop(context);
                              },
                            );
                          }).toList(),
                        ),
                      );
                    },
                  );
                }
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'Add to lineup',
                  child: Text('Add to lineup'),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text('Original Key: ${widget.originalkey}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black)),
              const SizedBox(height: 10),
              Text(widget.chordsAndLyrics,
                  style: TextStyle(fontSize: _fontSize, color: Colors.black)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _launchURL,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                child: Text('Open Song Link',
                    style: TextStyle(color: Color(0xFFB4BA1C))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
