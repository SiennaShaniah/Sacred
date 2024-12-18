import 'package:flutter/material.dart';

class MainChordsAndLyrics extends StatefulWidget {
  const MainChordsAndLyrics({super.key});

  @override
  _MainChordsAndLyricsState createState() => _MainChordsAndLyricsState();
}

class _MainChordsAndLyricsState extends State<MainChordsAndLyrics> {
  String selectedKey = 'C'; // Default key

  // A map for chord transpositions
  final Map<String, List<String>> chordTranspose = {
    'C': ['C', 'D', 'E', 'F', 'G', 'A', 'B'],
    'C#': ['C#', 'D#', 'F', 'F#', 'G#', 'A#', 'B#'],
    'D': ['D', 'E', 'F#', 'G', 'A', 'B', 'C#'],
    'D#': ['D#', 'F', 'G', 'G#', 'A#', 'C', 'D'],
    'E': ['E', 'F#', 'G#', 'A', 'B', 'C#', 'D#'],
    'F': ['F', 'G', 'A', 'A#', 'C', 'D', 'E'],
    'F#': ['F#', 'G#', 'A#', 'B', 'C#', 'D#', 'E#'],
    'G': ['G', 'A', 'B', 'C', 'D', 'E', 'F#'],
    'G#': ['G#', 'A#', 'C', 'C#', 'D#', 'F', 'G'],
    'A': ['A', 'B', 'C#', 'D', 'E', 'F#', 'G#'],
    'A#': ['A#', 'B#', 'D', 'D#', 'F', 'G', 'A'],
    'B': ['B', 'C#', 'D#', 'E', 'F#', 'G#', 'A#'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB4BA1C),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'I Trust in God', // Song Title
              style: TextStyle(
                fontSize: 22, // Larger font size for song title
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0), // Set color to black
              ),
            ),
            const SizedBox(height: 4), // Space between title and artist
            const Text(
              'Elevation Worship', // Song Artist
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(
                    255, 73, 69, 69), // Set artist name color to grey
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow, color: Color(0xFF363636)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.zoom_in, color: Color(0xFF363636)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out, color: Color(0xFF363636)),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xFF363636)),
            onSelected: (value) {
              if (value == 'Add to lineup') {
                _showLineupDialog(
                    context); // Show the dialog for selecting lineup
              } else if (value == 'Add to favorites') {
                _addToFavorites(); // Add song to favorites
              } else if (value == 'Click Song Link') {
                _clickSongLink(); // Handle the song link click
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'Add to lineup',
                  child: Text('Add to lineup'),
                ),
                const PopupMenuItem<String>(
                  value: 'Add to favorites',
                  child: Text('Add to favorites'),
                ),
                const PopupMenuItem<String>(
                  value: 'Click Song Link',
                  child: Text('Click Song Link'),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chord Navigation - Wrapping in SingleChildScrollView for horizontal scrolling
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildChordButton('C'),
                    _buildChordButton('C#'),
                    _buildChordButton('D'),
                    _buildChordButton('D#'),
                    _buildChordButton('E'),
                    _buildChordButton('F'),
                    _buildChordButton('F#'),
                    _buildChordButton('G'),
                    _buildChordButton('G#'),
                    _buildChordButton('A'),
                    _buildChordButton('A#'),
                    _buildChordButton('B'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Lyrics Section
              _buildLyricsSection(),
            ],
          ),
        ),
      ),
    );
  }

  // Button for each chord
  Widget _buildChordButton(String chord) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedKey = chord;
          });
        },
        child: Text(
          chord,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB4BA1C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }

  // Lyrics Section
  Widget _buildLyricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildVerseSection('Intro', ['C Am F', 'C Dm F']),
        _buildVerseSection('Verse 1', [
          'C Am Blessed assurance Jesus is mine',
          'F C/E He’s been my fourth man in the fire',
          'C Am Time after time',
          'F Born of His spirit',
          'C/E Dm And what He did for me on Calvary',
          'G Is more than enough'
        ]),
        _buildChorusSection([
          'C I trust In God',
          'Am F My Savior the One who will',
          'Dm Never fail',
          'F He will never fail',
        ]),
      ],
    );
  }

  // Function to build each verse section
  Widget _buildVerseSection(String title, List<String> lyrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '[$title]',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        for (var line in lyrics) ...[
          _buildChordAndLyrics(line),
          const SizedBox(height: 8),
        ]
      ],
    );
  }

  // Function to build the chorus section
  Widget _buildChorusSection(List<String> lyrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '[Chorus]',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        for (var line in lyrics) ...[
          _buildChordAndLyrics(line),
          const SizedBox(height: 8),
        ]
      ],
    );
  }

  // Function to display the chords on one line and lyrics on the next
  Widget _buildChordAndLyrics(String line) {
    List<String> parts = line.split(' '); // Split chords and lyrics
    List<Widget> widgets = [];

    // Define a more specific regex to match only valid chords (e.g., "C", "Am", "F", etc.)
    RegExp chordRegex = RegExp(r'^[A-G](#|b|m|maj|dim|aug|sus[24]?)?$');

    // First add the chords on one line
    List<String> chords =
        parts.where((part) => chordRegex.hasMatch(part)).toList();

    // Transpose the chords based on the selected key
    chords = _transposeChords(chords);

    widgets.add(
      Row(
        children: chords
            .map((chord) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    chord,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFFB4BA1C), // Chord color
                    ),
                  ),
                ))
            .toList(),
      ),
    );

    // Then add the lyrics on the next line
    List<String> lyrics =
        parts.where((part) => !chordRegex.hasMatch(part)).toList();
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          lyrics.join(' '),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black, // Lyrics color
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  // Function to transpose the chords based on the selected key
  List<String> _transposeChords(List<String> chords) {
    List<String> transposedChords = [];
    for (var chord in chords) {
      if (chordTranspose.containsKey(selectedKey)) {
        List<String> possibleChords = chordTranspose[selectedKey]!;
        if (possibleChords.contains(chord)) {
          // If the chord exists in the selected key's chords, transpose it
          int index = possibleChords.indexOf(chord);
          transposedChords.add(possibleChords[index]);
        } else {
          // If the chord isn't found in the transposition list, keep it unchanged
          transposedChords.add(chord);
        }
      } else {
        // If no transposition exists for the key, keep the original chord
        transposedChords.add(chord);
      }
    }
    return transposedChords;
  }

  // Function to show lineup selection dialog
  void _showLineupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a Lineup'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Lineup 1'),
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                  },
                ),
                ListTile(
                  title: const Text('Lineup 2'),
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                  },
                ),
                ListTile(
                  title: const Text('Lineup 3'),
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to add to favorites
  void _addToFavorites() {
    // Add song to favorites logic
    print('Added to favorites');
  }

  // Function to handle song link click
  void _clickSongLink() {
    // Open the song link
    print('Opening song link');
  }
}
