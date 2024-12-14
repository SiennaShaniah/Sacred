import 'package:flutter/material.dart';

class UserDailyDevo extends StatelessWidget {
  const UserDailyDevo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                      children: const [
                        Text(
                          'Devotional Title Here', // Devotional Title
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'December 13, 2024', // Date
                          style: TextStyle(
                            fontSize: 14.0, // Smaller font size
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal, // Remove italics
                            color: Colors.black, // Set color to black
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Bible Verse Section inside a box with 50% opacity
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFB4BA1C)
                      .withOpacity(0.5), // 50% opacity color
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Text(
                  'Jeremiah 29:11 - "For I know the plans I have for you," declares the Lord, "plans to prosper you and not to harm you, plans to give you a hope and a future."',
                  textAlign: TextAlign.justify, // Justify the text
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Color.fromARGB(
                        255, 0, 0, 0), // Text color to ensure readability
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Body Section inside a box with 50% opacity
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFB4BA1C)
                      .withOpacity(0.5), // 50% opacity color
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Text(
                  'Here is the body of the devotional. It contains a meaningful message to reflect on the teachings of the Bible and apply it to your daily life. This text can be dynamic or static depending on the use case.',
                  textAlign: TextAlign.justify, // Justify the text
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Color.fromARGB(
                        255, 0, 0, 0), // Text color to ensure readability
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
