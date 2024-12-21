import 'package:flutter/material.dart';

import 'tooltab.dart/chordlibrary.dart';
import 'tooltab.dart/metronome.dart';
import 'tooltab.dart/tuner.dart';

class Tools extends StatelessWidget {
  const Tools({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tools'),
        automaticallyImplyLeading: false, // Removes the back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.all(
                    16.0), // Add more space around the card content
                title: const Text('Chord Library'),
                subtitle: const Text('Browse and search for chords'),
                leading: Icon(
                  Icons.library_music,
                  color: Color(0xFFB4BA1C), // Custom icon color
                ),
                onTap: () {
                  // Navigate to the Chord Library screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChordLibrary()),
                  );
                },
              ),
            ),
            Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: const Text('Metronome'),
                subtitle: const Text('Use a metronome to set the tempo'),
                leading: Icon(
                  Icons.access_time, // Changed from access_time to music_note
                  color: Color(0xFFB4BA1C), // Custom icon color
                ),
                onTap: () {
                  // Navigate to Metronome screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MetronomePage()),
                  );
                },
              ),
            ),
            Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: const Text('Guitar Tuner'),
                subtitle: const Text('Tune your guitar using the tuner'),
                leading: Icon(
                  Icons.music_note,
                  color: Color(0xFFB4BA1C), // Custom icon color
                ),
                onTap: () {
                  // Navigate to Guitar Tuner screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GuitarTunerPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
