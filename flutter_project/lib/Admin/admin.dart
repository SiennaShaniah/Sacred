import 'package:flutter/material.dart';

import 'AdminTabs/addashboard.dart';
import 'AdminTabs/addsong.dart';
import 'AdminTabs/devotion.dart';
import 'AdminTabs/listdevotion.dart';
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
          children: [
            const Text(
              'SacredStrings Admin',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Flexible(
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(
                    'lib/Images/adminprofile.jpg'), // Replace with your image path
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
                            fontSize: 30, // Adjusted font size
                          ),
                        ),
                        TextSpan(
                          text: 'Strings',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Roboto',
                            color: Color(0xFFB4BA1C),
                            fontSize: 30, // Adjusted font size
                          ),
                        ),
                        TextSpan(
                          text: '.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24, // Adjusted font size
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25, // Adjusted size
                        backgroundImage: AssetImage(
                            'lib/Images/adminprofile.jpg'), // Replace with your image path
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Shienna Laredo',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14, // Adjusted font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'shiennalaredo1617@gmail.com',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12, // Adjusted font size
                            ),
                          ),
                        ],
                      ),
                    ],
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
              icon: Icons.book,
              title: 'Add Daily Devotional',
              index: 3,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.list,
              title: 'Daily Devotional List',
              index: 4,
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
      body: SafeArea(
        child: _getSelectedTabContent(),
      ),
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
        return const AddDailyDevotionalTab();
      case 4:
        return const DailyDevotionalListTab();
      default:
        return const Center(child: Text('Select a tab'));
    }
  }
}
