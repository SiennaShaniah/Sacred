import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../admin.dart'; // Import the SongListTab

class EditSong extends StatefulWidget {
  final Map<String, dynamic> songData;

  const EditSong({super.key, required this.songData});

  @override
  State<EditSong> createState() => _EditSongState();
}

class _EditSongState extends State<EditSong> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for text fields
  final _songTitleController = TextEditingController();
  final _chordsAndLyricsController = TextEditingController();
  final _linkController = TextEditingController();

  // State variables
  String? selectedArtist;
  String? selectedKey;
  String? selectedSongType;
  String? selectedLanguage;
  String? selectedImagePath;

  // Image options from the assets folder
  final List<String> imagePaths = [
    'lib/Images/imagesDropdown/ElevationWorship.jpg',
    'lib/Images/imagesDropdown/CastingCrowns.jpg',
    'lib/Images/imagesDropdown/MjFlores.jpg'
  ];

  // Dropdown options
  List<String> artists = [
    'Elevation Worship',
    'Casting Crowns',
    'Mj Flores'
  ]; // Example artist list
  final List<String> keys = [
    'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#',
    'B', // Major keys
    'Cm', 'C#m', 'Dm', 'D#m', 'Em', 'Fm', 'F#m', 'Gm', 'G#m', 'Am', 'A#m',
    'Bm' // Minor keys
  ];
  final List<String> songTypes = ['Praise And Worship', 'Hymnal'];
  final List<String> languages = ['English', 'Tagalog', 'Cebuano'];

  @override
  void initState() {
    super.initState();
    _loadSongData();
  }

  void _loadSongData() {
    _songTitleController.text = widget.songData['title'];
    _chordsAndLyricsController.text = widget.songData['chordsAndLyrics'];
    _linkController.text = widget.songData['link'] ?? '';

    // Set selected values, ensuring they match valid options
    selectedArtist = _getValidDropdownValue(widget.songData['artist'], artists);
    selectedKey = _getValidDropdownValue(widget.songData['key'], keys);
    selectedSongType =
        _getValidDropdownValue(widget.songData['type'], songTypes);
    selectedLanguage =
        _getValidDropdownValue(widget.songData['language'], languages);
    selectedImagePath =
        _getValidDropdownValue(widget.songData['imagePath'], imagePaths);
  }

  String _getValidDropdownValue(String? value, List<String> options) {
    // If the value is not in the list, return the first item as a default
    if (value != null && options.contains(value)) {
      return value;
    }
    return options.isNotEmpty ? options[0] : '';
  }

  Future<void> _saveSong() async {
    if (_songTitleController.text.isNotEmpty &&
        selectedArtist != null &&
        selectedKey != null &&
        _chordsAndLyricsController.text.isNotEmpty &&
        selectedSongType != null &&
        selectedLanguage != null) {
      // Update song data in Firestore
      await _firestore.collection('songs').doc(widget.songData['id']).update({
        'title': _songTitleController.text,
        'artist': selectedArtist,
        'key': selectedKey,
        'chordsAndLyrics': _chordsAndLyricsController.text,
        'type': selectedSongType,
        'language': selectedLanguage,
        'link': _linkController.text,
        'imagePath': selectedImagePath,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Song updated successfully')));

      // Navigate back to Admin page with SongListTab selected
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Admin(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields')));
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
              const Text('Select Image',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                value: selectedImagePath,
                items: imagePaths.map((path) {
                  return DropdownMenuItem(
                    value: path,
                    child: Text(path.split('/').last),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedImagePath = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Color(
                          0xFFB4BA1C), // Set border color to match the theme
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Color(0xFFB4BA1C), // Set focused border color
                      width: 2.0,
                    ),
                  ),
                ),
                hint: const Text('Select an image'),
              ),
              const SizedBox(height: 20),
              _buildTextField('Song Title', _songTitleController),
              _buildDropdown('Song Artist', artists, selectedArtist,
                  (value) => setState(() => selectedArtist = value)),
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
                  _buildButton('Update', Icons.save, _saveSong),
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
              borderSide: const BorderSide(
                color: Color(0xFFB4BA1C), // Set border color to match the theme
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Color(0xFFB4BA1C), // Set focused border color
                width: 2.0,
              ),
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
              borderSide: const BorderSide(
                color: Color(0xFFB4BA1C), // Set border color to match the theme
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Color(0xFFB4BA1C), // Set focused border color
                width: 2.0,
              ),
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
      icon: Icon(
        icon,
        size: 18,
        color: Colors.black, // Set the icon color to black
      ),
      label: Text(
        text,
        style: const TextStyle(
          color: Colors.black, // Set text color to black
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFB4BA1C),
        padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16), // Smaller padding for a smaller button
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        minimumSize: const Size(150, 40), // Reduced size for a smaller button
      ),
    );
  }
}
