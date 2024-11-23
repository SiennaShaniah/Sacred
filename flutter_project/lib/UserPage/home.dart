import 'package:flutter/material.dart';

class home extends StatelessWidget {
  const home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sacred Strings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFB4BA1C),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Handle logout action here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Welcome message
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Welcome to Sacred Strings!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB4BA1C),
                ),
              ),
            ),

            // Quick actions
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildDashboardCard(
                  context,
                  'Songs List',
                  Icons.library_music,
                  () {
                    // Navigate to songs list page (functionality to be added)
                  },
                ),
                _buildDashboardCard(
                  context,
                  'Add Song',
                  Icons.add_circle_outline,
                  () {
                    // Navigate to add song page (functionality to be added)
                  },
                ),
                _buildDashboardCard(
                  context,
                  'Search Song',
                  Icons.search,
                  () {
                    // Navigate to search song page (functionality to be added)
                  },
                ),
                _buildDashboardCard(
                  context,
                  'My Songs',
                  Icons.favorite_border,
                  () {
                    // Navigate to user's song collection page (functionality to be added)
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create dashboard cards
  Widget _buildDashboardCard(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: const Color(0xFFB4BA1C),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
