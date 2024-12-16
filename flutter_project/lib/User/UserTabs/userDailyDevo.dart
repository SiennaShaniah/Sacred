import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class UserDailyDevo extends StatelessWidget {
  const UserDailyDevo({super.key});

  // Method to fetch the most recent devotional from Firestore
  Future<DocumentSnapshot<Object?>> fetchMostRecentDevotional() async {
    // Fetch the most recent document from the Firestore collection
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('devotionals')
        .orderBy('timestamp', descending: true) // Sort by 'timestamp'
        .limit(1)
        .get();

    // Check if there are any documents, if so return the first document
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first; // Return the first document if available
    } else {
      // Return null if no documents found
      throw Exception('No devotional found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot<Object?>>(
        future: fetchMostRecentDevotional(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData ||
              snapshot.data == null ||
              !snapshot.data!.exists) {
            return Center(child: Text('No devotional available.'));
          }

          // Get the devotional data from Firestore
          var devotionalData = snapshot.data!;
          String title = devotionalData['title'] ?? 'No title';

          // Fetch the date directly from the 'date' field (not the timestamp)
          String rawDate = devotionalData['date'] ??
              'No date'; // Assuming 'date' is a string or formatted date

          // Format the date using DateFormat
          DateTime dateTime = DateTime.tryParse(rawDate) ?? DateTime.now();
          String date = DateFormat('MMMM dd, yyyy').format(dateTime);

          String bibleVerse = devotionalData['bible_verse'] ?? 'No Bible verse';
          String body = devotionalData['body'] ?? 'No body text';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stack to position the date and title over the image
                Stack(
                  children: [
                    // Image Section
                    Image.asset(
                      'lib/Images/bible2.jpg', // Replace with your image path
                      width: double.infinity,
                      height: 500.0, // Increased height for a longer image
                      fit: BoxFit.cover,
                    ),
                    // Positioned Title and Date at the top left corner
                    Positioned(
                      top: 16.0,
                      left: 16.0,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withOpacity(0.5), // 50% opacity white color
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title, // Dynamic Devotional Title
                              style: TextStyle(
                                fontSize: 16.0, // Smaller font size
                                fontWeight: FontWeight.bold,
                                overflow:
                                    TextOverflow.ellipsis, // Handles overflow
                              ),
                              maxLines: 2, // Limit to 2 lines if necessary
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              date, // Dynamic Date fetched and formatted
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),

                // Bible Verse Section inside a box with 50% opacity
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFB4BA1C)
                          .withOpacity(0.5), // 50% opacity color
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      bibleVerse,
                      textAlign: TextAlign.justify, // Justify the text
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),

                // Body Section inside a box with 50% opacity
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFB4BA1C)
                          .withOpacity(0.5), // 50% opacity color
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      body,
                      textAlign: TextAlign.justify, // Justify the text
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          );
        },
      ),
    );
  }
}
