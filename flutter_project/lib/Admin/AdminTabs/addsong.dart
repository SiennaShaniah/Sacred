import 'package:flutter/material.dart';

// Tab for Add Song content
class AddSongTab extends StatelessWidget {
  const AddSongTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for dropdowns
    final List<String> artists = ['Artist 1', 'Artist 2', 'Artist 3'];
    final List<String> keys = ['C', 'D', 'E', 'F', 'G'];
    final List<String> songTypes = [
      'Pop',
      'Rock',
      'Jazz',
      'Classical'
    ]; // Song Types
    final List<String> languages = [
      'English',
      'Spanish',
      'French',
      'Italian'
    ]; // Song Languages

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Padding(
                padding:
                    EdgeInsets.only(top: 8.0), // Adjust top padding as needed
                child: Text(
                  'Add Song',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Title color remains black
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Artist Section
              const Text(
                'Add Artist',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  // Text Field for entering the artist name
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter Artist Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16), // Adjust padding
                      ),
                    ),
                  ),
                  const SizedBox(
                      width: 8), // Space between the TextField and Button
                  // Circular Save Button
                  SizedBox(
                    height: 48, // Matches the height of the TextField
                    width: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle save artist logic
                      },
                      style: ElevatedButton.styleFrom(
                        shape:
                            const CircleBorder(), // Makes the button circular
                        backgroundColor:
                            const Color(0xFFB4BA1C), // Button color
                        padding:
                            EdgeInsets.zero, // Removes default button padding
                      ),
                      child: const Icon(
                        Icons.check, // Check icon
                        color: Colors.black, // Icon color
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Add Image Section
              const Text(
                'Add Image',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  // Handle image selection logic here
                },
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Song Title
              const Text(
                'Song Title',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Song Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Song Artist Dropdown
              const Text(
                'Song Artist',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                items: artists
                    .map(
                      (artist) => DropdownMenuItem<String>(
                        value: artist,
                        child: Text(artist),
                      ),
                    )
                    .toList(),
                onChanged: (value) {},
                hint: const Text('Select Artist'),
              ),
              const SizedBox(height: 20),

              // Original Key Dropdown
              const Text(
                'Original Key',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                items: keys
                    .map(
                      (key) => DropdownMenuItem<String>(
                        value: key,
                        child: Text(key),
                      ),
                    )
                    .toList(),
                onChanged: (value) {},
                hint: const Text('Select Original Key'),
              ),
              const SizedBox(height: 20),

              // Chords and Lyrics
              const Text(
                'Chords and Lyrics',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'Enter Chords and Lyrics...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Song Type Dropdown
              const Text(
                'Song Type',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                items: songTypes
                    .map(
                      (type) => DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      ),
                    )
                    .toList(),
                onChanged: (value) {},
                hint: const Text('Select Song Type'),
              ),
              const SizedBox(height: 20),

              // Song Language Dropdown
              const Text(
                'Song Language',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                items: languages
                    .map(
                      (language) => DropdownMenuItem<String>(
                        value: language,
                        child: Text(language),
                      ),
                    )
                    .toList(),
                onChanged: (value) {},
                hint: const Text('Select Song Language'),
              ),
              const SizedBox(height: 20),

              // Link
              const Text(
                'Link',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Link',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Buttons Section
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Aligns the buttons to the right
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle Clear logic
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text(
                      'Clear',
                      style: TextStyle(
                          color: Colors.black), // Set text color to black
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB4BA1C), // Green color
                      minimumSize: const Size(100, 40),
                      foregroundColor:
                          Colors.black, // Set text color to black for button
                    ),
                  ),
                  const SizedBox(width: 10), // Spacing between the buttons
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle Save logic
                    },
                    icon: const Icon(Icons.save),
                    label: const Text(
                      'Save',
                      style: TextStyle(
                          color: Colors.black), // Set text color to black
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB4BA1C), // Green color
                      minimumSize: const Size(100, 40),
                      foregroundColor:
                          Colors.black, // Set text color to black for button
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
