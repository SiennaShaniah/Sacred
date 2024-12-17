import 'package:flutter/material.dart';
import 'package:flutter_project/User/UserTabs/favorites.dart';
import 'package:flutter_project/User/UserTabs/mainList.dart';
import 'package:flutter_project/User/UserTabs/myLineUp.dart';
import 'package:flutter_project/User/UserTabs/mySongs.dart';
import 'package:flutter_project/User/UserTabs/tools.dart';
import 'package:flutter_project/User/UserTabs/userDailyDevo.dart';
import 'package:flutter_project/Services/auth.service.dart'; // Import the AuthService
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore import

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedIndex = 0; // Track the selected index for content
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _authService = AuthService(); // Initialize AuthService
  String username = ''; // Store the username
  String email = ''; // Store the email

  @override
  void initState() {
    super.initState();
    _getUserInfo(); // Get user info on startup
  }

  // Fetch the user information from Firestore
  Future<void> _getUserInfo() async {
    try {
      firebase_auth.User? user =
          firebase_auth.FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          email = user.email ?? ''; // Set email from FirebaseAuth
        });

        // Fetch the user document from Firestore
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userData.exists) {
          setState(() {
            username = userData['username'] ?? 'User';
          });
        } else {
          print('User data not found');
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

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
            const Spacer(),
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('lib/Images/logo2.png'),
            ),
          ],
        ),
      ),
      drawer: Container(
        width: 325,
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
                        const CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('lib/Images/logo2.png'),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                username.isEmpty ? 'Loading...' : username,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                email.isEmpty ? 'Loading...' : email,
                                style: const TextStyle(
                                  color: Colors.black54,
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
                icon: Icons.favorite,
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
                icon: Icons.build,
                title: 'Tools',
                index: 4,
              ),
              _buildDrawerItem(
                context,
                icon: Icons.book,
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
      leading: Icon(icon, color: const Color(0xFFB4BA1C)),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        if (index == -1) {
          _authService.signout(context: context);
        } else {
          setState(() => _selectedIndex = index);
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
