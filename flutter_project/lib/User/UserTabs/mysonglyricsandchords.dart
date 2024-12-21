import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package
import 'dart:async'; // For Timer

class Mysonglyricsandchords extends StatefulWidget {
  final String songTitle;
  final String songArtist;
  final String songOriginalKey;
  final String songLink;
  final String songChordsAndLyrics;

  const Mysonglyricsandchords({
    Key? key,
    required this.songTitle,
    required this.songArtist,
    required this.songOriginalKey,
    required this.songLink,
    required this.songChordsAndLyrics,
  }) : super(key: key);

  @override
  _mysonglyricsandchordsstate createState() => _mysonglyricsandchordsstate();
}

class _mysonglyricsandchordsstate extends State<Mysonglyricsandchords> {
  bool isPlaying = false; // To toggle between play and pause state
  late ScrollController _scrollController;
  double _fontSize = 16.0; // Default font size for lyrics
  Timer? _scrollTimer; // Timer for periodic scrolling

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  // Function to launch URL
  Future<void> _launchURL() async {
    final url = widget.songLink;
    if (await canLaunch(url)) {
      await launch(url); // Open the link in the browser
    } else {
      throw 'Could not launch $url'; // Error handling if the link can't be opened
    }
  }

  // Function to handle play and pause behavior
  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });

    if (isPlaying) {
      // Start the timer for continuous scrolling
      _scrollTimer = Timer.periodic(Duration(seconds: 2), (timer) {
        _scrollToNextLine();
      });
    } else {
      // Stop the timer when pausing
      _scrollTimer?.cancel();
    }
  }

  // Scroll to the next line every 2 seconds while playing
  void _scrollToNextLine() {
    if (_scrollController.hasClients) {
      // Scroll to the next line with slower speed
      _scrollController.animateTo(
        _scrollController.offset +
            20, // Adjust 20 to control scroll speed (smoother)
        duration: Duration(milliseconds: 300), // Duration for smoother scroll
        curve: Curves.easeInOut, // Smoother curve for animation
      );
    }
  }

  // Zoom-in function to increase the font size
  void _zoomIn() {
    setState(() {
      if (_fontSize < 30.0) {
        // Limit the maximum zoom level
        _fontSize += 2.0; // Increase font size
      }
    });
  }

  // Zoom-out function to decrease the font size
  void _zoomOut() {
    setState(() {
      if (_fontSize > 10.0) {
        // Limit the minimum zoom level
        _fontSize -= 2.0; // Decrease font size
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollTimer?.cancel(); // Cancel the timer when disposing
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
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.songTitle, // Song Title
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.songArtist, // Song Artist
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 73, 69, 69),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Color(0xFF363636),
            ),
            onPressed: _togglePlayPause, // Handle play/pause button
          ),
          IconButton(
            icon: const Icon(Icons.zoom_in, color: Color(0xFF363636)),
            onPressed: _zoomIn, // Handle zoom-in action
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out, color: Color(0xFF363636)),
            onPressed: _zoomOut, // Handle zoom-out action
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController, // Attach the scroll controller
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Display the original key
              Text(
                'Original Key: ${widget.songOriginalKey}', // Show the original key from the database
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                  height: 10), // Space between the original key and lyrics
              // Display the lyrics directly from the database
              Text(
                widget.songChordsAndLyrics,
                style: TextStyle(
                    fontSize: _fontSize,
                    color: Colors.black), // Adjust font size
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _launchURL, // Call the function to launch the link
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Button background color
                ),
                child: Text(
                  'Open Song Link',
                  style: TextStyle(
                      color: Color(0xFFB4BA1C)), // Set button text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
