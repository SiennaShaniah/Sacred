import 'package:flutter/material.dart';
import 'package:flutter_project/User/UserTabs/favorites.dart';
import 'package:flutter_project/User/UserTabs/mainList.dart';
import 'package:flutter_project/User/UserTabs/myLineUp.dart';
import 'package:flutter_project/User/UserTabs/mySongs.dart';
import 'package:flutter_project/User/UserTabs/tools.dart';
import 'package:flutter_project/User/UserTabs/userDailyDevo.dart';
import 'package:flutter_project/Services/auth.service.dart'; // Import the AuthService
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth import
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore import

class User extends StatefulWidget {
  const User({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<User> {
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

  // Method to get the user information
  Future<void> _getUserInfo() async {
    try {
      User? user = FirebaseAuth.instance.currentUser; // Get current user
      if (user != null) {
        // Update the email from FirebaseAuth
        setState(() {
          email = user.email ?? '';
        });

        // Fetch the user data from Firestore (if you have it there)
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users') // Assuming 'users' collection stores user data
            .doc(user.uid) // Use the UID to fetch the user document
            .get();

        if (userData.exists) {
          setState(() {
            username = userData['username'] ??
                'User'; // Assuming 'username' is stored in Firestore
          });
        } else {
          // Handle the case where no user data is found in Firestore
          print('User data not found in Firestore');
        }
      } else {
        // Handle the case where the user is not logged in
        print('No user is logged in');
      }
    } catch (e) {
      print('Error fetching user data: $e'); // Handle errors
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
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('lib/Images/logo.png'),
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
                        CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              AssetImage('lib/Images/logo.png.jpg'),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                username.isEmpty
                                    ? 'Loading...'
                                    : username, // Display username
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                email.isEmpty
                                    ? 'Loading...'
                                    : email, // Display email
                                style: const TextStyle(
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
        color: const Color(0xFFB4BA1C),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        if (index == -1) {
          // Handle Log Out logic
          _authService.signout(context: context); // Call the signout method
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
