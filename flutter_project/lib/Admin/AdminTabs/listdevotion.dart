import 'package:flutter/material.dart';

class DailyDevotionalListTab extends StatelessWidget {
  const DailyDevotionalListTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for daily devotionals
    final List<Map<String, String>> devotionals = [
      {
        "title": "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh",
        "date": "2024-11-28",
        "image": 'lib/Images/welcome.png', // Local image path
      },
      {
        "title": "Devotional Title 2",
        "date": "2024-11-27",
        "image": 'lib/Images/welcome.png', // Local image path
      },
      {
        "title": "Devotional Title 3",
        "date": "2024-11-26",
        "image": 'lib/Images/welcome.png', // Local image path
      },
    ];

    return Column(
      children: [
        // Title Text aligned to start
        const Align(
          alignment: Alignment.centerLeft, // Align text to the left
          child: Padding(
            padding: EdgeInsets.only(
                left: 16.0, top: 32.0), // Add left and top padding
            child: Text(
              'Daily Devotionals',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black, // You can change the color if needed
              ),
            ),
          ),
        ),

        // GridView for two cards per row
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0), // Reduced padding between items
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of items per row (2 cards)
              crossAxisSpacing: 10.0, // Space between cards horizontally
              mainAxisSpacing: 10.0, // Space between cards vertically
              childAspectRatio: 0.75, // Adjust the height and width ratio
            ),
            itemCount: devotionals.length,
            itemBuilder: (context, index) {
              final devotional = devotionals[index];

              return Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                elevation: 3.0,
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Ensure Column doesn't take more space than necessary
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stack to position 3-dots menu on top-right corner of the image
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(5), // Rounded corners
                          child: Image.asset(
                            devotional["image"]!,
                            width: double.infinity,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: PopupMenuButton<String>(
                            onSelected: (String value) {
                              if (value == 'view') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Viewing ${devotional["title"]}',
                                    ),
                                  ),
                                );
                              } else if (value == 'delete') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Deleting ${devotional["title"]}',
                                    ),
                                  ),
                                );
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                const PopupMenuItem<String>(
                                  value: 'view',
                                  child: Row(
                                    children: [
                                      Icon(Icons.remove_red_eye,
                                          color: Color(0xFFB4BA1C)),
                                      SizedBox(width: 8),
                                      Text('View'),
                                    ],
                                  ),
                                ),
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
                          Text(
                            devotional["title"]!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            devotional["date"]!,
                            style: const TextStyle(
                                fontSize: 14, color: Color(0xFFB4BA1C)),
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
    );
  }
}
