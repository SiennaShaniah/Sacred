import 'package:flutter/material.dart';

// Tab for Dashboard content
class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 362, // Fixed width
            height: 47, // Fixed height
            decoration: BoxDecoration(
              color: const Color(0xFFB4BA1C), // Background color
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
            child: Center(
              child: Text(
                'ADMIN DASHBOARD'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text color
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildStatCard('USERS', '0'),
              _buildStatCard('SONGS', '0'),
              _buildStatCard('ARTISTS', '0'),
              _buildStatCard('SONG REQUESTS', '0'),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Stats',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFB4BA1C),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFB4BA1C),
            child: const Text(
              'Stats Data Goes Here',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build the stat cards
  Widget _buildStatCard(String title, String count) {
    return Card(
      color: const Color(0xFFB4BA1C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              count,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tab for Manage Users content
