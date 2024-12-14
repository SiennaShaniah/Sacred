import 'package:flutter/material.dart';

import 'AdminTabs/addashboard.dart';
import 'AdminTabs/addsong.dart';
import 'AdminTabs/devotion.dart';
import 'AdminTabs/listdevotion.dart';
import 'AdminTabs/songarchive.dart';
import 'AdminTabs/songlist.dart';

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
      home: const Admin(),
    );
  }
}

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<Admin> {
  int _selectedIndex = 0; // Track the selected index for content
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize
              .min, // Ensures the Row doesn't take up the entire width
          children: [
            const SizedBox(
                width: 8), // Adds a small space between the icon and text
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
                            fontSize: 34,
                          ),
                        ),
                        TextSpan(
                          text: 'Strings',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Roboto',
                            color: Color(0xFFB4BA1C),
                            fontSize: 34,
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
              icon: Icons.add,
              title: 'Add Song',
              index: 1,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.library_music,
              title: 'Song List',
              index: 2,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.archive,
              title: 'Archive',
              index: 3,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.book,
              title: 'Add Daily Devotional',
              index: 4,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.list,
              title: 'Daily Devotional List',
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
        color: const Color(0xFFB4BA1C), // Updated icon color
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
        return AddSongTab();
      case 2:
        return SongListTab();
      case 3:
        return const ArchiveTab();
      case 4:
        return const AddDailyDevotionalTab();
      case 5:
        return const DailyDevotionalListTab();
      default:
        return const Center(child: Text('Select a tab'));
    }
  }
}
