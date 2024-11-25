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
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Key for Scaffold

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the key here
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(
              left:
                  0.0), // Adjust the number (16.0) to move it more to the left or right
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start, // Aligns to the left
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
                        fontSize: 24, // Increased font size
                      ),
                    ),
                    TextSpan(
                      text: 'Strings',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Roboto',
                        color: Color(0xFF615E5E),
                        fontSize: 24, // Increased font size
                      ),
                    ),
                    TextSpan(
                      text: '.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24, // Increased font size
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xFFB4BA1C),
        // No actions to avoid extra icons
      ),

      drawer: Drawer(
        backgroundColor: const Color(0xFFB4BA1C),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFB4BA1C),
              ),
              child: Text(
                'Admin Page',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.dashboard,
              title: 'Dashboard',
              index: 0, // Dashboard content
            ),
            _buildDrawerItem(
              context,
              icon: Icons.people,
              title: 'Manage Users',
              index: 1, // Manage Users content
            ),
            _buildDrawerItem(
              context,
              icon: Icons.add,
              title: 'Add Song',
              index: 2, // Add Song content
            ),
            _buildDrawerItem(
              context,
              icon: Icons.library_music,
              title: 'Song List',
              index: 3, // Song List content
            ),
            _buildDrawerItem(
              context,
              icon: Icons.archive,
              title: 'Archive',
              index: 4, // Archive content
            ),
            _buildDrawerItem(
              context,
              icon: Icons.music_note,
              title: 'Song Requests', // New Song Requests item
              index: 5, // Song Requests content
            ),
            _buildDrawerItem(
              context,
              icon: Icons.exit_to_app,
              title: 'Log Out',
              index: -1, // Log Out option
            ),
          ],
        ),
      ),
      body: _getSelectedTabContent(),
    );
  }

  // Helper method to build drawer items
  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int index,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        if (index == -1) {
          // Handle Log Out logic
        } else {
          setState(() {
            _selectedIndex = index; // Set the selected tab index
          });
        }
      },
    );
  }

  // Method to get the content based on selected index
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
        return const SongRequestsTab(); // Display content for Song Requests
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
          const Text(
            'ADMIN DASHBOARD',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFB4BA1C),
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
    return const Center(
      child: Text('Manage Users Content'),
    );
  }
}

// Tab for Add Song content
class AddSongTab extends StatelessWidget {
  const AddSongTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Add Song Content'),
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
