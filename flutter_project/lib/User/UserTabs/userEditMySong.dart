import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../userMain.dart'; // Import the UserDashboard page

class UserMySongEdit extends StatefulWidget {
  final Map<String, dynamic> songData;

  const UserMySongEdit({super.key, required this.songData});

  @override
  State<UserMySongEdit> createState() => _UserMySongEditState();
}

class _UserMySongEditState extends State<UserMySongEdit> {
  final _songTitleController = TextEditingController();
  final _chordsAndLyricsController = TextEditingController();
  final _linkController = TextEditingController();
  final _artistController = TextEditingController();

  String? selectedKey;
  String? selectedSongType;
  String? selectedLanguage;

  final List<String> keys = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B'
  ];
  final List<String> songTypes = ['Praise And Worship', 'Hymnal'];
  final List<String> languages = ['English', 'Tagalog', 'Cebuano'];

  @override
  void initState() {
    super.initState();
    _loadSongData();
  }

  void _loadSongData() {
    _songTitleController.text = widget.songData['songTitle'] ?? '';
    _chordsAndLyricsController.text =
        widget.songData['songChordsAndLyrics'] ?? '';
    _linkController.text = widget.songData['songLink'] ?? '';
    _artistController.text = widget.songData['songArtist'] ?? '';

    selectedKey = widget.songData['songOriginalKey'] ?? keys[0];
    selectedSongType = widget.songData['songType'] ?? songTypes[0];
    selectedLanguage = widget.songData['songLanguage'] ?? languages[0];
  }

  Future<void> _updateSong() async {
    try {
      String? songId =
          widget.songData['id']; // Ensure songId is properly retrieved
      if (songId == null) {
        print('Song ID is null, cannot update the song.');
        return;
      }

      // Reference the Firestore document using the song ID
      await FirebaseFirestore.instance
          .collection('userAddSong')
          .doc(songId) // Use the passed ID here
          .update({
        'songTitle': _songTitleController.text,
        'songArtist': _artistController.text,
        'songLink': _linkController.text,
        'songChordsAndLyrics': _chordsAndLyricsController.text,
        'songOriginalKey': selectedKey,
        'songType': selectedSongType,
        'songLanguage': selectedLanguage,
      });

      // Navigate to the UserDashboard page after the update
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserDashboard()),
      );
    } catch (e) {
      print("Error updating song: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Song'),
        backgroundColor: const Color(0xFFB4BA1C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildTextField('Song Title', _songTitleController),
              _buildTextField('Song Artist', _artistController),
              _buildDropdown('Original Key', keys, selectedKey,
                  (value) => setState(() => selectedKey = value)),
              _buildTextField('Chords and Lyrics', _chordsAndLyricsController,
                  maxLines: 6),
              _buildDropdown('Song Type', songTypes, selectedSongType,
                  (value) => setState(() => selectedSongType = value)),
              _buildDropdown('Song Language', languages, selectedLanguage,
                  (value) => setState(() => selectedLanguage = value)),
              _buildTextField('Link', _linkController),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildButton('Update', Icons.save,
                      _updateSong), // Update button action
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
                  const BorderSide(color: Color(0xFFB4BA1C), width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
                  const BorderSide(color: Color(0xFFB4BA1C), width: 2.0),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedValue,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedValue,
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
                  const BorderSide(color: Color(0xFFB4BA1C), width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
                  const BorderSide(color: Color(0xFFB4BA1C), width: 2.0),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: Colors.black),
      label: Text(
        text,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFB4BA1C),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        minimumSize: const Size(150, 40),
      ),
    );
  }
}
