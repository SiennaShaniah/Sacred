import 'package:flutter/material.dart';
import 'package:flutter_project/User/UserTabs/favorites.dart';
import 'package:flutter_project/User/UserTabs/mainList.dart';
import 'package:flutter_project/User/UserTabs/myLineUp.dart';
import 'package:flutter_project/User/UserTabs/mySongs.dart';
import 'package:flutter_project/User/UserTabs/tools.dart';
import 'package:flutter_project/User/UserTabs/userDailyDevo.dart';

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
      home: const User(),
    );
  }
}

class User extends StatefulWidget {
  const User({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<User> {
  int _selectedIndex = 0; // Track the selected index for content
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFFB4BA1C),
        title: Row(
          children: [
            const Text(
              'SacredStrings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const Spacer(), // This will push the profile picture to the right
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(
                  'lib/Images/adminprofile.jpg'), // Replace with your image path
            ),
          ],
        ),
      ),
      drawer: Container(
        width: 325, // Set the desired width of the sidebar here
        child: Drawer(
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
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                              'lib/Images/adminprofile.jpg'), // Profile image path
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Shienna Laredo',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'shiennalaredo1617@gmail.com',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(
                context,
                icon: Icons.dashboard,
                title: 'Song List',
                index: 0,
              ),
              _buildDrawerItem(
                context,
                icon: Icons.add,
                title: 'Favorites',
                index: 1,
              ),
              _buildDrawerItem(
                context,
                icon: Icons.library_music,
                title: 'My Line Up',
                index: 2,
              ),
              _buildDrawerItem(
                context,
                icon: Icons.archive,
                title: 'My Songs',
                index: 3,
              ),
              _buildDrawerItem(
                context,
                icon: Icons.book,
                title: 'Tools',
                index: 4,
              ),
              _buildDrawerItem(
                context,
                icon: Icons.list,
                title: 'Daily Devotional',
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
        return const MainList();
      case 1:
        return const Favorites();
      case 2:
        return const MyLineUp();
      case 3:
        return Mysongs();
      case 4:
        return const tools();
      case 5:
        return const UserDailyDevo();
      default:
        return const Center(child: Text('Select a tab'));
    }
  }
}
