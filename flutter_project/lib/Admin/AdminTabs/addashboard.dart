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
          // Admin Dashboard Title
          Container(
            width: 362, // Fixed width
            height: 47, // Fixed height
            decoration: BoxDecoration(
              color: const Color(0xFFB4BA1C), // Original color
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

          // GridView for stats cards
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildStatCard('USERS', '0'),
              _buildStatCard('SONGS', '0'),
              _buildStatCard('ARTISTS', '0'),
              _buildStatCard('DEVOTIONALS', '0'),
            ],
          ),
          const SizedBox(height: 20),

          // Stats Title - styled like Admin Dashboard (Removed opacity)
          Container(
            width: 362, // Fixed width
            height: 47, // Fixed height
            decoration: BoxDecoration(
              color: const Color(0xFFB4BA1C), // Full opacity color
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
            child: Center(
              child: Text(
                'Stats'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text color
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Stats Data Section
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFB4BA1C), // Full opacity color
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
      color: const Color(0xFFB4BA1C).withOpacity(0.5), // Full opacity color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB4BA1C),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                count,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
