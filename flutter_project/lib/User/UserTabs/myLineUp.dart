import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package

class MyLineUp extends StatelessWidget {
  const MyLineUp({super.key});

  // Add a lineup to Firestore
  Future<void> _addLineUp(String lineupTitle, BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final timestamp = FieldValue.serverTimestamp();

      try {
        // Add the new lineup to Firestore
        await FirebaseFirestore.instance.collection('myLineUp').add({
          'userId': userId,
          'lineUpName': lineupTitle,
          'timestamp': timestamp,
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lineup "$lineupTitle" added successfully!')),
        );
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add lineup')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to add a lineup')),
      );
    }
  }

  // Delete a lineup from Firestore
  Future<void> _deleteLineUp(String lineupId, BuildContext context) async {
    try {
      // Delete the selected lineup from Firestore
      await FirebaseFirestore.instance
          .collection('myLineUp')
          .doc(lineupId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Line Up deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete lineup')),
      );
    }
  }

  // Show the dialog to add a new lineup
  void _showAddLineUpDialog(BuildContext context) {
    final TextEditingController lineupController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: const Text('Add Line Up Title',
              style: TextStyle(color: Colors.black)),
          content: TextField(
            controller: lineupController,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Enter Line Up Title',
              hintStyle: const TextStyle(color: Colors.black),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB4BA1C)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB4BA1C), width: 2.0),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB4BA1C)),
              onPressed: () {
                final lineupTitle = lineupController.text;
                if (lineupTitle.isNotEmpty) {
                  _addLineUp(lineupTitle, context); // Add the new lineup
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Title cannot be empty!')),
                  );
                }
              },
              child: const Text('Add', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text('Please log in to view and add your lineups.'),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, top: 15.0),
              child: Text(
                'My Line Up',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('myLineUp')
                  .where('userId',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('timestamp',
                      descending: true) // Changed to ascending
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No lineups available.'));
                }

                final lineups = snapshot.data!.docs;
                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1.0, // Adjusted for a square ratio
                  ),
                  itemCount: lineups.length,
                  itemBuilder: (context, index) {
                    final lineup = lineups[index];
                    final lineupTitle = lineup['lineUpName'];
                    final lineupId = lineup.id;

                    // Format the timestamp to only show the date
                    final timestamp = lineup['timestamp'].toDate();
                    final formattedDate =
                        DateFormat('MM/dd/yyyy').format(timestamp);

                    return Card(
                      color: const Color(0xFFB4BA1C).withOpacity(0.5),
                      elevation: 3.0,
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min, // Use min to prevent overflow
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.asset(
                                    'lib/Images/bible.jpg',
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert,
                                        color: Colors.black, size: 30),
                                    onSelected: (value) {
                                      if (value == 'delete') {
                                        _deleteLineUp(lineupId, context);
                                      }
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return [
                                        const PopupMenuItem<String>(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete,
                                                  color: Color(0xFFB4BA1C)),
                                              SizedBox(width: 8),
                                              Text('Delete'),
                                            ],
                                          ),
                                        ),
                                      ];
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lineupTitle,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  formattedDate, // Display formatted date
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddLineUpDialog(context),
        backgroundColor: const Color(0xFFB4BA1C),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
