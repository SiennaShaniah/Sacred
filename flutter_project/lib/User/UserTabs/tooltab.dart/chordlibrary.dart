import 'package:flutter/material.dart';

class ChordLibrary extends StatefulWidget {
  const ChordLibrary({super.key});

  @override
  _ChordLibraryState createState() => _ChordLibraryState();
}

class _ChordLibraryState extends State<ChordLibrary>
    with SingleTickerProviderStateMixin {
  // List of chord types
  final List<String> chordTabs = [
    'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#',
    'B', // Major keys
    'Cm', 'C#m', 'Dm', 'D#m', 'Em', 'Fm', 'F#m', 'Gm', 'G#m', 'Am', 'A#m',
    'Bm' // Minor keys
  ];

  // Example chord images based on chord types
  Map<String, List<String>> chordImages = {
    'C': [
      'lib/Images/chords/c.png',
      'lib/Images/chords/c7.png',
      'lib/Images/chords/cadd9.png',
      'lib/Images/chords/cmaj7.png', // Example additional chord images
    ],
    'C#': [
      'assets/images/c_sharp_chord.png',
      'assets/images/c_sharp_chord2.png',
    ],
    'D': [
      'assets/images/d_chord.png',
      'assets/images/d_chord2.png',
    ],
    // Add images for all other chords...
  };

  late TabController _tabController; // TabController to manage tab changes
  String selectedChord = 'C'; // Default selected chord

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: chordTabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedChord = chordTabs[_tabController.index];
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chord Library'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor:
              Color(0xFFB4BA1C), // Set the indicator color to the desired color
          labelColor:
              Color(0xFFB4BA1C), // Set the color of the selected tab text
          unselectedLabelColor: const Color.fromARGB(
              255, 0, 0, 0), // Set the color of unselected tab text
          tabs: chordTabs.map((chord) => Tab(text: chord)).toList(),
        ),
      ),
      body: Column(
        children: [
          // TabBar to switch between chord types
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: chordImages[selectedChord]?.length ?? 0,
              itemBuilder: (context, index) {
                // Get the chord image list based on the selected chord
                final images = chordImages[selectedChord] ?? [];
                return Card(
                  elevation:
                      8, // Increase the elevation for a more pronounced shadow
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12.0), // Rounded corners
                  ),
                  child: InkWell(
                    onTap: () {
                      // Implement action on tap (e.g., show chord details)
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          images[index], // Use the appropriate chord image
                          width: 150, // Increase the width for a bigger image
                          height: 300, // Increase the height for a bigger image
                        ),
                        const SizedBox(
                            height:
                                12), // Increase space between image and text
                      ],
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
