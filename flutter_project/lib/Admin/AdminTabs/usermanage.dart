import 'package:flutter/material.dart';

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
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title "Manage Users" aligned with the table
          const Padding(
            padding: EdgeInsets.only(top: 8.0), // Adjust top padding as needed
            child: Text(
              'Manage Users',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Title color remains black
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Wrap the table in a Container to maintain consistent alignment
          Container(
            alignment: Alignment.centerLeft,
            child: Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all<Color>(
                        Color(0xFFB4BA1C).withOpacity(
                            0.5)), // 50% opacity of Color(0xFFB4BA1C) for header
                    dataRowColor:
                        MaterialStateProperty.all<Color>(Colors.white),
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
                                  Text(user['Username']!),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.more_vert),
                                    onPressed: () {
                                      showMenu(
                                        context: context,
                                        position: const RelativeRect.fromLTRB(
                                            200, 200, 0, 0),
                                        items: [
                                          const PopupMenuItem(
                                            value: 'disable',
                                            child: Text('Disable User'),
                                          ),
                                        ],
                                      ).then((value) {
                                        if (value == 'disable') {
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
          ),
        ],
      ),
    );
  }

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
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
