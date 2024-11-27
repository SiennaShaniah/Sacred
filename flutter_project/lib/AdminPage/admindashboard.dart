import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SacredStrings',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0; // Track the selected index for content
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Sacred',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  TextSpan(
                    text: 'Strings',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Roboto',
                      color: Color(0xFF615E5E),
                      fontSize: 24,
                    ),
                  ),
                  TextSpan(
                    text: '.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFB4BA1C),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0x80B4BA1C),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Sacred',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                            color: Colors.white,
                            fontSize: 26,
                          ),
                        ),
                        TextSpan(
                          text: 'Strings',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Roboto',
                            color: Color(0xFFB4BA1C),
                            fontSize: 26,
                          ),
                        ),
                        TextSpan(
                          text: '.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Admin Page',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.dashboard,
              title: 'Dashboard',
              index: 0,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.people,
              title: 'Manage Users',
              index: 1,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.add,
              title: 'Add Song',
              index: 2,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.library_music,
              title: 'Song List',
              index: 3,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.archive,
              title: 'Archive',
              index: 4,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.music_note,
              title: 'Song Requests',
              index: 5,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.exit_to_app,
              title: 'Log Out',
              index: -1,
            ),
          ],
        ),
      ),
      body: _getSelectedTabContent(),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int index,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Color(0xFFB4BA1C), // Updated icon color
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black, // Updated text color
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        if (index == -1) {
          // Handle Log Out logic
        } else {
          setState(() {
            _selectedIndex = index;
          });
        }
      },
    );
  }

  Widget _getSelectedTabContent() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardTab();
      case 1:
        return const ManageUsersTab();
      case 2:
        return const AddSongTab();
      case 3:
        return const SongListTab();
      case 4:
        return const ArchiveTab();
      case 5:
        return const SongRequestsTab();
      default:
        return const Center(child: Text('Select a tab'));
    }
  }
}

// Tab for Dashboard content
class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 362, // Fixed width
            height: 47, // Fixed height
            decoration: BoxDecoration(
              color: const Color(0xFFB4BA1C), // Background color
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
            child: Center(
              child: Text(
                'ADMIN DASHBOARD'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text color
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildStatCard('USERS', '0'),
              _buildStatCard('SONGS', '0'),
              _buildStatCard('ARTISTS', '0'),
              _buildStatCard('SONG REQUESTS', '0'),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Stats',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFB4BA1C),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFB4BA1C),
            child: const Text(
              'Stats Data Goes Here',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build the stat cards
  Widget _buildStatCard(String title, String count) {
    return Card(
      color: const Color(0xFFB4BA1C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              count,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tab for Manage Users content

class ManageUsersTab extends StatelessWidget {
  const ManageUsersTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample user data
    final List<Map<String, String>> users = [
      {'UserID': '1', 'Username': 'JohnDoe'},
      {'UserID': '2', 'Username': 'JaneSmithfefqffefewfwrvrvsvrbrbrberbebeb'},
      {'UserID': '3', 'Username': 'SamuelLee'},
      {'UserID': '4', 'Username': 'MiaTaylor'},
      {'UserID': '5', 'Username': 'AlexBrown'},
      {'UserID': '6', 'Username': 'EmilyDavis'},
      // Add more users if needed...
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 362, // Fixed width
            height: 47, // Fixed height
            decoration: BoxDecoration(
              color: const Color(0xFFB4BA1C), // Background color
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
            child: Center(
              child: Text(
                'Manage Users'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text color
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Expanded to fill available vertical space
          Expanded(
            child: SingleChildScrollView(
              scrollDirection:
                  Axis.vertical, // Vertical scrolling for the table
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Horizontal scrolling
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('UserID')),
                    DataColumn(label: Text('Username')),
                  ],
                  rows: users
                      .map(
                        (user) => DataRow(cells: [
                          DataCell(Text(user['UserID']!)),
                          DataCell(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Username text aligned to the left
                                Text(user['Username']!),
                                const Spacer(), // Spacer to push the icon to the right
                                IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () {
                                    // Show a popup menu for actions
                                    showMenu(
                                      context: context,
                                      position: RelativeRect.fromLTRB(
                                          200, 200, 0, 0), // Adjust position
                                      items: [
                                        PopupMenuItem(
                                          value: 'disable',
                                          child: const Text('Disable User'),
                                        ),
                                      ],
                                    ).then((value) {
                                      if (value == 'disable') {
                                        // Handle disable user logic
                                        _showDisableUserDialog(context);
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ]),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dialog to confirm disabling a user
  void _showDisableUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Disable User'),
          content: const Text('Are you sure you want to disable this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Handle user disable logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User has been disabled')),
                );
              },
              child: const Text('Disable'),
            ),
          ],
        );
      },
    );
  }
}

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
      appBar: AppBar(
        title: const Text('Add Song'),
        backgroundColor: const Color(0xFFB4BA1C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Container(
                width: 362, // Fixed width
                height: 47, // Fixed height
                decoration: BoxDecoration(
                  color: const Color(0xFFB4BA1C), // Background color
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                child: Center(
                  child: Text(
                    'ADD SONG'.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text color
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Artist Section
              const Text(
                'Add Artist',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Artist Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      backgroundColor: Colors.grey,
                      minimumSize: const Size(100, 40),
                      foregroundColor:
                          Colors.black, // Set text color to black for button
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle Cancel logic
                    },
                    icon: const Icon(Icons.cancel),
                    label: const Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.black), // Set text color to black
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(100, 40),
                      foregroundColor:
                          Colors.black, // Set text color to black for button
                    ),
                  ),
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
                      backgroundColor: const Color(0xFFB4BA1C),
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

// Tab for Song List content
class SongListTab extends StatelessWidget {
  const SongListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Song List Content'),
    );
  }
}

// Tab for Archive content
class ArchiveTab extends StatelessWidget {
  const ArchiveTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Archive Content'),
    );
  }
}

// Tab for Song Requests content
class SongRequestsTab extends StatelessWidget {
  const SongRequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Song Requests Content'),
    );
  }
}
