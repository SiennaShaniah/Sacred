import 'package:flutter/material.dart';

class MyLineUp extends StatelessWidget {
  const MyLineUp({super.key});

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.75, // Adjust this value if necessary
              ),
              itemCount: 10, // Placeholder item count
              itemBuilder: (context, index) {
                return Card(
                  color:
                      const Color(0xFFB4BA1C).withOpacity(0.5), // 50% opacity
                  elevation: 3.0,
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.max, // Allow card to take available height
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset(
                              'lib/Images/bible.jpg', // Local image path
                              width: double.infinity,
                              height: 150, // Increased height for the image
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: PopupMenuButton<String>(
                              icon: const Icon(
                                Icons.more_vert,
                                color: Color.fromARGB(255, 1, 1, 1),
                                size: 30, // Bigger size for the menu button
                              ),
                              onSelected: (String value) {
                                if (value == 'delete') {
                                  _deleteLineUp(context);
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title text now takes more space
                            Text(
                              'Sample Title', // Placeholder title
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              overflow: TextOverflow
                                  .ellipsis, // Truncate if text overflows
                              softWrap:
                                  true, // Allow text to wrap to the next line
                            ),
                            const SizedBox(
                                height: 8), // Space between title and date
                            // Formatted Date
                            Text(
                              '2024-12-07', // Placeholder date
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddLineUpDialog(context);
        },
        backgroundColor:
            const Color(0xFFB4BA1C), // Optional color for the button
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  // Function to delete the lineup
  void _deleteLineUp(BuildContext context) {
    // Placeholder for delete logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Line Up deleted successfully!')),
    );
  }

  void _showAddLineUpDialog(BuildContext context) {
    final TextEditingController lineupController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(
              255, 255, 255, 255), // Set the background color
          title: const Text(
            'Add Line Up Title',
            style: TextStyle(color: Colors.black), // Black text for the title
          ),
          content: TextField(
            controller: lineupController,
            style: const TextStyle(color: Colors.black), // Black text input
            decoration: InputDecoration(
              hintText: 'Enter Line Up Title',
              hintStyle:
                  const TextStyle(color: Colors.black), // Black hint text
              border: const OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color(0xFFB4BA1C)), // Default border
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color(0xFFB4BA1C),
                    width: 2.0), // Border when focused
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color(0xFFB4BA1C)), // Border when not focused
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black), // Black text for button
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB4BA1C), // Match background
              ),
              onPressed: () {
                // Action for adding a new lineup
                String lineupTitle = lineupController.text;
                if (lineupTitle.isNotEmpty) {
                  // Placeholder for adding logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added: $lineupTitle')),
                  );
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Title cannot be empty!')),
                  );
                }
              },
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.black), // Black text for button
              ),
            ),
          ],
        );
      },
    );
  }
}
