import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddMySongTab extends StatefulWidget {
  const AddMySongTab({super.key});

  @override
  State<AddMySongTab> createState() => _AddSongTabState();
}

class _AddSongTabState extends State<AddMySongTab> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Controllers for text fields
  final _artistController = TextEditingController();
  final _songTitleController = TextEditingController();
  final _chordsAndLyricsController = TextEditingController();
  final _linkController = TextEditingController();

  // State variables
  String? selectedKey;
  String? selectedSongType;
  String? selectedLanguage;

  // Dropdown options
  List<String> artists = [];
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
    _loadArtists(); // Load artists from Firestore
  }

  Future<void> _loadArtists() async {
    final snapshot = await _firestore.collection('artists').get();
    setState(() {
      artists = snapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  Future<void> _saveSong() async {
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')));
      return;
    }

    if (_songTitleController.text.isNotEmpty &&
        _artistController.text.isNotEmpty &&
        selectedKey != null &&
        _chordsAndLyricsController.text.isNotEmpty &&
        selectedSongType != null &&
        selectedLanguage != null) {
      await _firestore.collection('userAddSong').add({
        'userId': user.uid, // Store userId from Firebase Authentication
        'songTitle': _songTitleController.text,
        'songArtist': _artistController.text,
        'songOriginalKey': selectedKey,
        'songChordsAndLyrics': _chordsAndLyricsController.text,
        'songType': selectedSongType,
        'songLanguage': selectedLanguage,
        'songLink': _linkController.text,
        'timestamp': FieldValue.serverTimestamp(), // Add timestamp field
      });

      _clearFields();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Song saved successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields')));
    }
  }

  void _clearFields() {
    _songTitleController.clear();
    _chordsAndLyricsController.clear();
    _linkController.clear();
    _artistController.clear();
    selectedKey = null;
    selectedSongType = null;
    selectedLanguage = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Song'),
        backgroundColor: const Color(0xFFB4BA1C), // Custom color for the AppBar
        elevation: 4.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Other Input Fields
              _buildTextField('Song Title', _songTitleController),
              _buildTextField('Song Artist', _artistController),
              _buildDropdown('Original Key', keys, selectedKey,
                  (value) => setState(() => selectedKey = value)),

              // Instruction before the Chords and Lyrics text field
              const SizedBox(height: 8),
              Text(
                'Each line with chords should start with the ">" symbol.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              // Chords and Lyrics TextField
              _buildTextField('Chords and Lyrics', _chordsAndLyricsController,
                  maxLines: 6),

              _buildDropdown('Song Type', songTypes, selectedSongType,
                  (value) => setState(() => selectedSongType = value)),
              _buildDropdown('Song Language', languages, selectedLanguage,
                  (value) => setState(() => selectedLanguage = value)),
              _buildTextField('Link', _linkController),
              const SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildButton('Clear', Icons.clear, _clearFields),
                  const SizedBox(width: 10),
                  _buildButton('Save', Icons.save, _saveSong),
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
                borderSide: const BorderSide(color: Color(0xFFB4BA1C))),
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
                borderSide: const BorderSide(color: Color(0xFFB4BA1C))),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
                  const BorderSide(color: Color(0xFFB4BA1C), width: 2.0),
            ),
          ),
          hint: Text('Select $label'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.black),
      label: Text(label, style: const TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB4BA1C),
          minimumSize: const Size(100, 40)),
    );
  }
}
